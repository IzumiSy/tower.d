module tower.logger;

import consoled;
import tower.request;

class Logger {
  void output(Request request) {
    writecln("Accepted ", Fg.green, request.method,
        Fg.white, FontStyle.bold, " ", request.path);
    resetColors();
    resetFontStyle();
  }
}
