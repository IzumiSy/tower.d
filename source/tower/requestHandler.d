module tower.requestHandler;

import std.socket;
import tower.request;
import tower.logger;

class RequestHandler {
  private immutable long REQUEST_PAYLOAD_SIZE = 1024;

  private Request request;
  private Logger logger;
  private Socket client;
  private ubyte[REQUEST_PAYLOAD_SIZE] rawRequestBody;

  this(Socket client) {
    this.client = client;
    this.logger = new Logger();
  }

  void handle() {
    client.receive(rawRequestBody);
    request = new Request(rawRequestBody);

    ubyte[] data = cast(ubyte[])"HTTP/1.1 200 OK

    <html><body>Hello World!</body></html>";

    //
    // TODO
    //

    client.send(data);
  }

  void finish() {
    logger.output(request);
    client.close();
  }
}
