import 'dart:ui';

class Element {
  List<Element> nodes;

  var name;

  Element();

  factory Element.tag(String name) {
    if (name == "canvas") {
      return CanvasElement.fresh();
    } else {
      return Element();
    }
  }

  var style;

  var innerHtml;
}

class ImageElement extends Element {
  num _width;
  num _height;

  var src;
  var crossOrigin;
  var onLoad;
  var onError;

  set width(num value) => _width = value;
  set height(num value) => _height = value;

  num get width => _width;
  num get height => _height;
}

class CanvasElement extends ImageElement {
  Canvas _canvas;

  var context2D;

  get dartCanvas => _canvas;

  CanvasElement();

  factory CanvasElement.fresh() =>
      CanvasElement.dartCanvas(Canvas(PictureRecorder()));

  CanvasElement.dartCanvas(this._canvas);

  CanvasRenderingContext2D getContext([String dimension]) {
    return CanvasRenderingContext2D(this);
  }
}

class HttpRequest {
  static var DONE = 'DONE';
  static var LOADING = 'LOADING';
  static var HEADERS_RECEIVED = 'HEADERS_RECEIVED';

  HttpRequest();

  HttpRequest.request(String url, {String responseType});

  // getters
  var open;
  var send;
  var status;
  var responseText;
  var getResponseHeader;
  var readyState;
  var onReadyStateChange;
  var onLoad;
  var onError;
  var response;
  var responseType;
  var then;
}

class document extends Element {
  static Element createElement(String name) => Element();

  static Element body;

  static var onMouseDown;
  static var onMouseMove;
  static var onMouseUp;
  static var onMouseOut;
  static var onTouchStart;
  static var onTouchMove;
}

class CanvasRenderingContext2D {
  // not implemented
  var clearRect;
  var clip;
  var createPatternFromImage;
  var drawImage;
  var drawImageScaledFromSource;
  var fill;
  var putImageData;
  var restore;
  var rotate;
  var save;
  var scale;
  var setTransform;
  var stroke;
  var strokeRect;
  var transform;
  var translate;
  var globalAlpha;
  var globalCompositeOperation;
  var lineCap;
  var lineJoin;
  var lineWidth;
  var _strokeStyle;

  // start implementation

  CanvasElement _canvas;
  Path _path;
  Paint _paint = Paint();

  Paint _fillStyle;

  CanvasRenderingContext2D(this._canvas);

  set strokeStyle(dynamic style) {
    _strokeStyle = Paint();
  }

  void set fillStyle(String cssColor) {
    this._fillStyle = Paint();
  }

  getImageData(int sx, int sy, int sw, int sh) {
    return {};
  }

  // The CanvasRenderingContext2D.fillRect() method of the Canvas 2D API draws a rectangle that is filled according to the current fillStyle
  // This method draws directly to the canvas without modifying the current path, so any subsequent fill() or stroke() calls will have no effect on it.
  void fillRect(num x, num y, num width, num height) =>
      _canvas.dartCanvas.drawRect(
          Rect.fromPoints(Offset(x, y), Offset(x + width, y + height)),
          _fillStyle);

  // path methods
  beginPath() => _path = Path();
  moveTo(double x, double y) => _path.moveTo(x, y);
  lineTo(double x, double y) => _path.lineTo(x, y);
  closePath() {
    _paint.color = Color.fromRGBO(0, 0, 0, 1);
    _paint.strokeWidth = 4;
    _canvas.dartCanvas.drawPath(_path, _paint);
  }

  Canvas getDartCanvas() => _canvas.dartCanvas;
  Paint getPaint() => _paint;
}

class window {
  static num innerWidth = 100.0;
  static num innerHeight = 100.0;

  static void requestAnimationFrame(var cb) {
    // cb();
  }
}

class Event {}

class ProgressEvent extends Event {}
