module tower.core;

import std.stdio;
import std.parallelism;
import std.concurrency;
import std.socket;
import core.thread;
import core.stdc.stdlib;
import core.sys.posix.signal;
import tower.connection;

extern (C) {
  private void cleanup(int _signal) {
    writeln("The server is shutting down...");
    exit(-1);
  }
}

struct TowerOpts {
  ushort port = 3000;
  uint backlog = 1;
  uint maxConnections = 1024;
}

class Tower {
  private TcpSocket listener;
  private TowerOpts opts;
  private Connection[] connections;

  this(TowerOpts opts) {
    listener = new TcpSocket();
    listener.blocking = true;
    listener.bind(new InternetAddress(opts.port));
    listener.listen(opts.backlog);

    opts = opts;
  }

  private void requestHandlingLoop() {
    for (size_t i = 0; i < opts.maxConnections; ++i) {
      connections ~= new Connection(thisTid);
    }

    while (true) {
      foreach (ref connection; connections) {
        receiveOnly!ConnectionReady;
        send(connection.getId(), cast(shared)listener);
      }
      Thread.sleep(dur!("msecs")(500));
    }
  }

  void start() {
    sigset(SIGINT, &cleanup);
    task(&requestHandlingLoop).executeInNewThread();
  }
}
