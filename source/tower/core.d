module tower.core;

import std.parallelism;
import std.socket;
import tower.connection;
import tower.sigint;

struct TowerOpts {
  ushort port = 3000;
  uint backlog = 128;
}

class Tower {
  private TcpSocket listener;
  private TowerOpts opts;
  private Connection[] connections;

  this() {
    TowerOpts _opts;
    this(_opts);
  }

  this(TowerOpts opts) {
    this.opts = opts;
    listener = new TcpSocket();
    listener.blocking = true;
    listener.bind(new InternetAddress(this.opts.port));
    listener.listen(this.opts.backlog);
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

  TowerOpts getOpts() const {
    return opts;
  }
}
