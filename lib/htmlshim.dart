import 'dart:typed_data';
import 'dart:ui';

class Element {
  List<Element> nodes;

  var name;

  Element();

  var style;

  var innerHtml;

  // implemented

  factory Element.tag(String name) {
    if (name == "canvas") {
      return CanvasElement.fresh();
    } else {
      return Element();
    }
  }

  num _width;
  num _height;
  set width(num value) => _width = value;
  set height(num value) => _height = value;

  num get width => _width;
  num get height => _height;
}

class ImageElement extends Element {
  var src;
  var crossOrigin;
  var onLoad;
  var onError;
}

class CanvasElement extends ImageElement {
  Canvas _canvas;

  var context2D;

  Canvas get dartCanvas => _canvas;

  CanvasElement();

  factory CanvasElement.fresh() =>
      CanvasElement.dartCanvas(Canvas(PictureRecorder()));

  factory CanvasElement.dartCanvas(canvas) {
    var canvasElement = CanvasElement();
    canvasElement._canvas = canvas;
    return canvasElement;
  }

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
  static createElement(String name) {
    if (name == 'canvas') {
      return CanvasElement();
    } else {
      return Element();
    }
  }

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
  var putImageData;
  var restore;
  var rotate;
  var save;
  var strokeRect;
  var globalCompositeOperation;

  // start implementation

  double _lineWidth;
  StrokeCap _lineCap;
  StrokeJoin _lineJoin;
  Paint _strokeStyle = Paint();
  var _globalAlpha = 1.0;

  CanvasElement _canvas;
  Path _path;
  Paint _paint = Paint();

  Paint _fillStyle = Paint();

  CanvasRenderingContext2D(this._canvas);

  set globalAlpha(value) {
    _globalAlpha = value;
  }

  // "butt", "round", "square"
  set lineCap(value) {
    var lineCapMap = {
      "butt": StrokeCap.butt,
      "round": StrokeCap.round,
      "square": StrokeCap.square,
    };
    _lineCap =
        lineCapMap[value] != null ? lineCapMap[value] : lineCapMap["square"];
  }

  set lineJoin(value) {
    // "round", "bevel", "miter"
    var lineJoinMap = {
      "round": StrokeJoin.round,
      "bevel": StrokeJoin.bevel,
      "miter": StrokeJoin.miter,
    };
    _lineJoin =
        lineJoinMap[value] != null ? lineJoinMap[value] : lineJoinMap["round"];
  }

  set lineWidth(double value) {
    _lineWidth = value;
  }

  set strokeStyle(dynamic value) {
    _strokeStyle.isAntiAlias = true;
    _strokeStyle.style = PaintingStyle.stroke;
    _strokeStyle.color = parseColor(value);
  }

  Color parseColor(String value) {
    var m = RegExp("[0-9]+").allMatches(value);
    num r, g, b, a = 1.0;

    if (m.length >= 3) {
      r = int.parse(m.elementAt(0).group(0));
      g = int.parse(m.elementAt(1).group(0));
      b = int.parse(m.elementAt(2).group(0));

      if (m.length == 4) {
        a = double.parse(m.elementAt(3).group(0));
      }

      return Color.fromRGBO(r, g, b, a);
    }
    return Color.fromRGBO(0, 0, 0, 1.0);
  }

  set fillStyle(dynamic value) {
    _fillStyle.color = parseColor(value);
  }

  ImageData getImageData(int sx, int sy, int sw, int sh) {
    return ImageData();
  }

  // The CanvasRenderingContext2D.fill() method of the Canvas 2D API fills the current or given path with the current fillStyle.
  void fill([dynamic path_OR_winding, String winding]) {
    if (_path != null) {
      var c = _fillStyle.color.withOpacity(_globalAlpha);
      _fillStyle.color = c;
      _canvas.dartCanvas.drawPath(_path, _fillStyle);
    }
  }

  void stroke([dynamic path_OR_winding, String winding]) {
    if (_path != null) {
      _strokeStyle.strokeWidth = _lineWidth;
      _strokeStyle.strokeJoin = _lineJoin;
      _strokeStyle.strokeCap = _lineCap;
      _canvas.dartCanvas.drawPath(_path, _strokeStyle);
    }
  }

  // The CanvasRenderingContext2D.fillRect() method of the Canvas 2D API draws a rectangle that is filled according to the current fillStyle
  // This method draws directly to the canvas without modifying the current path, so any subsequent fill() or stroke() calls will have no effect on it.
  void fillRect(num x, num y, num width, num height) {
    _canvas.dartCanvas.drawRect(
        Rect.fromLTWH(
            x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble()),
        _fillStyle);
  }

  // The CanvasRenderingContext2D.translate() method of the Canvas 2D API adds a translation transformation to the current matrix.
  void translate(num x, num y) {
    _canvas.dartCanvas.translate(x.toDouble(), y.toDouble());
  }

  // The CanvasRenderingContext2D.scale() method of the Canvas 2D API adds a scaling transformation to the canvas units horizontally and/or vertically.
  // By default, one unit on the canvas is exactly one pixel. A scaling transformation modifies this behavior. For instance, a scaling factor of 0.5 results in a unit size of 0.5 pixels; shapes are thus drawn at half the normal size. Similarly, a scaling factor of 2.0 increases the unit size so that one unit becomes two pixels; shapes are thus drawn at twice the normal size.
  void scale(num x, num y) {
    _canvas.dartCanvas.scale(x.toDouble(), y.toDouble());
  }

  // The CanvasRenderingContext2D.setTransform() method of the Canvas 2D API resets (overrides) the current transformation to the identity matrix, and then invokes a transformation described by the arguments of this method. This lets you scale, rotate, translate (move), and skew the context.
  void setTransform(num a, num b, num c, num d, num e, num f) {
    // save current transform to the stack
    if (_canvas.dartCanvas.getSaveCount() == 2) {
      _canvas.dartCanvas.save();
    } else {
      _canvas.dartCanvas.restore();
      _canvas.dartCanvas.save();
    }

    // _canvas.dartCanvas.save();
    this.transform(a, b, c, d, e, f);
  }

  void transform(num a, num b, num c, num d, num e, num f) {
    // new transform
    _canvas.dartCanvas.translate(e.toDouble(), f.toDouble());
    _canvas.dartCanvas.transform(Float64List.fromList([
      //1
      a.toDouble(),
      b.toDouble(),
      0.0,
      0.0,
      //2
      c.toDouble(),
      d.toDouble(),
      0.0,
      0.0,
      //3
      0.0,
      0.0,
      1.0,
      0.0,
      //4
      0.0,
      0.0,
      0.0,
      1.0
    ]));
  }

  // path methods
  beginPath() => _path = Path();
  moveTo(double x, double y) => _path.moveTo(x, y);
  lineTo(double x, double y) => _path.lineTo(x, y);
  closePath() => _path.close();

  Canvas getDartCanvas() => _canvas.dartCanvas;
  Paint getPaint() => _paint;
}

class window {
  // static num innerWidth = 100.0;
  // static num innerHeight = 100.0;

  static void requestAnimationFrame(var cb) {
    // cb();
  }
}

class Event {}

class ProgressEvent extends Event {}

class ImageData {
  Uint8ClampedList _data;
  int height;
  int width;

  Uint8ClampedList get data {
    return _data;
  }
}
