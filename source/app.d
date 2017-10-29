import std.stdio;
import std.socket;
import std.getopt;
import std.utf;

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

  auto requestPayload = new ubyte[REQUEST_PAYLOAD_SIZE];

  while (true) {
    auto client = listener.accept();
    client.receive(requestPayload);
    client.send(data);
    client.close();
  }
}
