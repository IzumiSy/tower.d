module tower.connection;

import std.concurrency;
import std.socket;
import core.thread;
import tower.requestHandler;

struct ConnectionReady {};

class Connection {
  private Tid id;

  this(Tid parentId) {
    parentId = parentId;
    id = spawn(&connectionHandler, parentId);
  }

  Tid getId() {
    return id;
  }
}

void connectionHandler(Tid parentId) {
  send(parentId, ConnectionReady());

  while (true) {
    receive(
      (shared TcpSocket listener) {
        auto client = (cast()listener).accept();
        RequestHandler req = new RequestHandler(client);
        req.handle();
        req.finish();
        send(parentId, ConnectionReady());
      }
    );
  }
}

