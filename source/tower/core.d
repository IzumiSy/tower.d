module tower.core;

import std.stdio;
import std.parallelism;
import std.socket;
import core.stdc.stdlib;
import core.sys.posix.signal;
import tower.requestHandler;

extern (C) {
  void cleanup(int _signal) {
    writeln("The server is shutting down...");
    exit(-1);
  }
}

struct TowerOpts {
  ushort port = 3000;
  int backlog = 1;
}

class Tower {
  TcpSocket listener;
  TowerOpts _opts;

  this(TowerOpts opts) {
    listener = new TcpSocket();
    listener.blocking = true;
    listener.bind(new InternetAddress(opts.port));
    listener.listen(opts.backlog);

    _opts = opts;
  }

  private void requestHandlingLoop() {
    while (true) {
      auto client = listener.accept();
      RequestHandler req = new RequestHandler(client);
      req.handle();
      req.finish();
    }
  }

  TowerOpts start() {
    sigset(SIGINT, &cleanup);
    task(&requestHandlingLoop).executeInNewThread();
    return _opts;
  }
}
