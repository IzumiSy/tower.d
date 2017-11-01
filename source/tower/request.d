module tower.request;

import std.string;

class Request {
  private string _method;
  private string _path;
  private string _httpVersion;

  private immutable ushort METHOD = 0;
  private immutable ushort PATH = 1;
  private immutable ushort VERSION = 2;

  this(ubyte[] rawRequestBody) {
    string[] payload = (cast(string)rawRequestBody).split();
    _method = payload[METHOD];
    _path = payload[PATH];
    _httpVersion = payload[VERSION];
  }

  @property string method() immutable {
    return _method;
  }

  @property string path() immutable {
    return _path;
  }

  @property string httpVersion() immutable {
    return _httpVersion;
  }
}
