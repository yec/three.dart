class Element {

  List<Element> nodes;

  var name;

  Element();

  factory Element.tag(String name) => Element();

  var style;

  var innerHtml;
}

class ImageElement extends Element {

  num width;
  num height;

  var src;
  var crossOrigin;
  var onLoad;
  var onError;
}

class CanvasElement extends ImageElement {
  var getContext;
  var context2D;
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
  var beginPath;
  var clearRect;
  var clip;
  var closePath;
  var createPatternFromImage;
  var drawImage;
  var drawImageScaledFromSource;
  var fill;
  var fillRect;
  var getImageData;
  var lineTo;
  var moveTo;
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
  var fillStyle;
  var globalAlpha;
  var globalCompositeOperation;
  var lineCap;
  var lineJoin;
  var lineWidth;
  var strokeStyle;
}

class window {
  static num innerWidth = 100.0;
  static num innerHeight = 100.0;

  static void requestAnimationFrame(var cb) {
    // cb();
  }
}

class Event {

}

class ProgressEvent extends Event {
  
}
