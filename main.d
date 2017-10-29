import std.stdio;
import std.socket;

void main() {
  ushort port = 3000;
  auto listener = new TcpSocket();

  writeln("Listening on port ", port);

  listener.blocking = true;
  listener.bind(new InternetAddress(port));
  listener.listen(1);

  ubyte[] data = cast(ubyte[])"HTTP/1.1 200 OK

  <html><body>Hello World!</body></html>";

  auto request = new ubyte[1024];

  while (true) {
    auto client = listener.accept();
    client.receive(request);
    client.send(data);
    client.close();
  }
}
