module tower.logger;

import consoled;
import tower.request;

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
