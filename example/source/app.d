import std.stdio;

import tower.core;

void main(string[] args) {
  Tower server = new Tower;
  server.start();

  auto opts = server.getOpts();
  writeln("Listening on port ", opts.port);
}
