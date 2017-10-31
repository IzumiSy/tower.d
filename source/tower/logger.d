module tower.logger;

import consoled;
import tower.request;

class Logger {
  Request request;

  this(Request request) {
    request = request;
  }

  void output() {
    writecln("Accepted ", Fg.green, _request.method,
      Fg.white, FontStyle.bold, " ", _request.path);
    resetColors();
    resetFontStyle();
  }
}
