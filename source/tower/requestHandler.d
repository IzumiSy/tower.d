module tower.requestHandler;

import std.socket;
import std.string;
import tower.request;
import tower.logger;

class RequestHandler {
  private immutable long REQUEST_PAYLOAD_SIZE = 1024;

  private immutable ushort METHOD = 0;
  private immutable ushort PATH = 1;
  private immutable ushort VERSION = 2;

  private Request request;
  private Logger logger;
  private Socket client;

  this(Socket client) {
    this.client = client;

    auto requestBody = new ubyte[REQUEST_PAYLOAD_SIZE];
    this.client.receive(requestBody);

    auto payload = (cast(string)requestBody).split();
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

    client.send(data);
  }

  void finish() {
    logger.output();
    client.close();
  }
}
