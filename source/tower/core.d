module tower.core;

import std.parallelism;
import std.socket;
import tower.connection;
import tower.sigint;

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
    setupSigintHandler(cast(shared)this);
    task(&requestHandlingLoop).executeInNewThread();
  }

  void exit() {
    listener.shutdown(SocketShutdown.BOTH);
    listener.close();
  }
}
