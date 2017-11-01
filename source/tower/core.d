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
    while (true) {
      auto client = listener.accept();
      auto connection = new Connection(cast(shared)client);
      connection.handle();
    }
  }

  void start() {
    sigset(SIGINT, &cleanup);
    task(&requestHandlingLoop).executeInNewThread();
  }
}
