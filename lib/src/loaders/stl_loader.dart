part of three;

/**
 * @author aleeper / http://adamleeper.com/
 * @author mrdoob / http://mrdoob.com/
 * @author gero3 / https://github.com/gero3
 *
 * Ported to Dart from JS by:
 * @author nelson silva / http://www.inevo.pt/
 *
 * Description: A THREE loader for STL ASCII files, as created by Solidworks and other CAD programs.
 *
 * Supports both binary and ASCII encoded files, with automatic detection of type.
 *
 * Limitations:
 *         Binary decoding ignores header. There doesn't seem to be much of a use for it.
 *         There is perhaps some question as to how valid it is to always assume little-endian-ness.
 *         ASCII decoding assumes file is UTF-8. Seems to work for the examples...
 *
 * Usage:
 *         var loader = new THREE.STLLoader();
 *         loader.addEventListener( 'load', function ( event ) {
 *
 *                 var geometry = event.content;
 *                 scene.add( new THREE.Mesh( geometry ) );
 *
 *         } );
 *         loader.load( './models/stl/slotted_disk.stl' );
 */

class STLLoader extends Loader {
  STLLoader() : super();

  Future<Geometry> load(url) =>
      HttpRequest.request(url, responseType: "arraybuffer")
          .then((req) => _parse(req.response));

  Geometry _parse(Object resp) {
    Uint8List data;
    if (resp is! Uint8List) {
      data = new Uint8List.view(resp as ByteBuffer);
    } else {
      data = (resp as Uint8List);
    }
    var geom = isBinary(data)
        ? parseBinary(data.buffer)
        : parseASCII(new String.fromCharCodes(data));
    return geom;
  }

  /**
   * UINT8[80] – Header
   * UINT32 – Number of triangles
   */
  bool isBinary(Uint8List bytes) {
    var data = new ByteData.view(bytes.buffer);

    var face_size = (32 / 8 * 3) + ((32 / 8 * 3) * 3) + (16 / 8);
    var n_faces = data.getUint32(80, Endian.little);
    var expect = 80 + (32 / 8) + (n_faces * face_size);
    var flag = (expect == data.lengthInBytes);
    return flag;
  }

  /**
   * foreach triangle
   * REAL32[3] – Normal vector
   * REAL32[3] – Vertex 1
   * REAL32[3] – Vertex 2
   * REAL32[3] – Vertex 3
   * UINT16 – Attribute byte count
   * end
   */
  Geometry parseBinary(ByteBuffer bytes) {
    var data = new ByteData.view(bytes),
        n_faces = data.getUint32(80, Endian.little),
        geometry = new Geometry(),
        dataOffset = 84,
        faceLength = 12 * 4 + 2;

    for (var face = 0; face < n_faces; face++) {
      var start = dataOffset + (face * faceLength);

      var normal = new Vector3(
          data.getFloat32(start, Endian.little),
          data.getFloat32(start + 4, Endian.little),
          data.getFloat32(start + 8, Endian.little));

      for (var i = 1; i <= 3; i++) {
        var vertexstart = start + i * 12;
        geometry.vertices.add(new Vector3(
            data.getFloat32(vertexstart, Endian.little),
            data.getFloat32(vertexstart + 4, Endian.little),
            data.getFloat32(vertexstart + 8, Endian.little)));
      }

      var length = geometry.vertices.length;
      geometry.faces.add(new Face3(length - 3, length - 2, length - 1, normal));
    }

    geometry.computeCentroids();
    geometry.computeBoundingSphere();

    return geometry;
  }

  Geometry parseASCII(data) {
    var geometry = new Geometry();

    var patternFace = new RegExp(r"facet([\s\S]*?)endfacet");
    var patternNormal = new RegExp(
        r"normal[\s]+([\-+]?[0-9]+\.?[0-9]*([eE][\-+]?[0-9]+)?)+[\s]+([\-+]?[0-9]*\.?[0-9]+([eE][\-+]?[0-9]+)?)+[\s]+([\-+]?[0-9]*\.?[0-9]+([eE][\-+]?[0-9]+)?)+");
    var patternVertex = new RegExp(
        r"vertex[\s]+([\-+]?[0-9]+\.?[0-9]*([eE][\-+]?[0-9]+)?)+[\s]+([\-+]?[0-9]*\.?[0-9]+([eE][\-+]?[0-9]+)?)+[\s]+([\-+]?[0-9]*\.?[0-9]+([eE][\-+]?[0-9]+)?)+");

    var faceMatches = patternFace.allMatches(data);

    faceMatches.forEach((faceMatch) {
      var text = faceMatch.group(0);

      var normalMatch = patternNormal.allMatches(text).first;

      var normal = new Vector3(
          double.parse(normalMatch.group(1)),
          double.parse(normalMatch.group(3)),
          double.parse(normalMatch.group(5)));

      var vertexMatches = patternVertex.allMatches(text);

      vertexMatches.forEach((vertexMatch) {
        geometry.vertices.add(new Vector3(
            double.parse(vertexMatch.group(1)),
            double.parse(vertexMatch.group(3)),
            double.parse(vertexMatch.group(5))));
      });

      var length = geometry.vertices.length;
      geometry.faces.add(new Face3(length - 3, length - 2, length - 1, normal));
    });

    geometry.computeCentroids();
    geometry.computeBoundingBox();
    geometry.computeBoundingSphere();

    return geometry;
  }
}
