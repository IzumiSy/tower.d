module tower.connection;

import std.concurrency;
import std.socket;
import tower.requestHandler;

class Connection {
  private Tid id;
  shared private Socket socket;

  this(shared Socket client) {
    this.socket = client;
  }

  void handle() {
    id = spawn(&connectionHandler, socket);
  }

  Tid getId() {
    return id;
  }
}

void connectionHandler(shared Socket socket) {
  RequestHandler req = new RequestHandler(cast()socket);
  req.handle();
  req.finish();
}

