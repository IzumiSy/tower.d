import std.stdio;
import std.socket;
import std.getopt;
import std.utf;
import std.string;
import std.parallelism;
import consoled;

struct Request {
  string method;
  string path;
  string httpVersion;
}

class Logger {
  Request _request;

  this(Request request) {
    _request = request;
  }

  void output() {
    writecln("Accepted ", Fg.green, _request.method,
      Fg.white, FontStyle.bold, " ", _request.path);
    resetColors();
    resetFontStyle();
  }
}

class RequestHandler {
  immutable long REQUEST_PAYLOAD_SIZE = 1024;

  immutable ushort METHOD = 0;
  immutable ushort PATH = 1;
  immutable ushort VERSION = 2;

  Request request;
  Logger logger;
  Socket _client;

  this(Socket client) {
    _client = client;

    auto _request = new ubyte[REQUEST_PAYLOAD_SIZE];
    _client.receive(_request);

    auto payload = (cast(string)_request).split();
    request.method = payload[METHOD];
    request.path = payload[PATH];
    request.httpVersion = payload[VERSION];

    logger = new Logger(request);
  }

  void handle() {
    ubyte[] data = cast(ubyte[])"HTTP/1.1 200 OK

    <html><body>Hello World!</body></html>";

    //
    // TODO
    //

    _client.send(data);
  }

  void finish() {
    logger.output();
    _client.close();
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

  void requestHandlingLoop() {
    while (true) {
      auto client = listener.accept();
      RequestHandler req = new RequestHandler(client);
      req.handle();
      req.finish();
    }
  }

  TowerOpts start() {
    task(&requestHandlingLoop).executeInNewThread();
    return _opts;
  }
}

void main(string[] args) {
  TowerOpts opts;
  opts.backlog = 10;

  Tower server = new Tower(opts);
  server.start();

  writeln("Listening on port ", opts.port);
}
