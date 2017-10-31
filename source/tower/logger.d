module tower.logger;

import consoled;
import tower.request;

class Logger {
  Request request;

  this(Request request) {
    this.request = request;
  }

  void output() {
    writecln("Accepted ", Fg.green, request.method,
        Fg.white, FontStyle.bold, " ", request.path);
    resetColors();
    resetFontStyle();
  }
}
