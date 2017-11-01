module tower.sigint;

import tower.core;
import core.stdc.stdlib;
import core.sys.posix.signal;
import std.signals;

private class SigObserver {
  Tower tower;

  void terminator(int _signal) {
    tower.exit();
    exit(-1);
  }

  this(Tower tower) {
    this.tower = tower;
  }
}

private class SigHandler {
  void terminate() {
    emit(SIGINT);
  }

  mixin Signal!(int);
}

extern (C) {
  private void cleanup(int _signal) {
    handler.terminate();
  }
}

private __gshared SigHandler handler;
private __gshared SigObserver observer;

void setupSigintHandler(shared Tower tower) {
  handler = new SigHandler();
  observer = new SigObserver(cast()tower);
  handler.connect(&observer.terminator);
  sigset(SIGINT, &cleanup);
}
