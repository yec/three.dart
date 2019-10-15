part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 */

class Uniform {
  var value;

  Uniform(this.value);

  Uniform clone() {
    return Uniform(value);
  }
}
