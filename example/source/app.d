import std.stdio;

import tower.core;

void main(string[] args) {
  TowerOpts opts;
  opts.backlog = 10;

  Tower server = new Tower(opts);
  server.start();

  writeln("Listening on port ", opts.port);
}
