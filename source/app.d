import std.stdio;
import std.socket;
import std.getopt;
import std.utf;
import std.string;
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
  immutable ushort METHOD = 0;
  immutable ushort PATH = 1;
  immutable ushort VERSION = 2;

  Request request;
  Logger logger;

  this(Socket client) {
    auto _request = new ubyte[REQUEST_PAYLOAD_SIZE];
    client.receive(_request);

    auto payload = (cast(string)_request).split();
    request.method = payload[METHOD];
    request.path = payload[PATH];
    request.httpVersion = payload[VERSION];

    logger = new Logger(request);
  }

  void handle() {
    logger.output();
  }
}

immutable long REQUEST_PAYLOAD_SIZE = 1024;
immutable ushort DEFAULT_PORT = 3000;

void main(string[] args) {
  ushort port = DEFAULT_PORT;
  auto listener = new TcpSocket();

  listener.blocking = true;
  listener.bind(new InternetAddress(port));
  listener.listen(1);

  auto arguments = getopt(
    args, "port", &port
  );

  writeln("Listening on port ", port);

  ubyte[] data = cast(ubyte[])"HTTP/1.1 200 OK

  <html><body>Hello World!</body></html>";

  while (true) {
    auto client = listener.accept();
    RequestHandler req = new RequestHandler(client);
    req.handle();

    client.send(data);
    client.close();
  }
}
