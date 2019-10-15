part of three;

class CompressedTexture extends Texture {
  var mipmaps;
  var images;
  CompressedTexture({this.mipmaps, width, height, format, type, mapping, wrapS, wrapT, magFilter, minFilter})
      : images = {
        "width": width,
        "height": height
      },
      
      super(null, mapping, wrapS, wrapT, magFilter, minFilter, format, type)
        ;
}
