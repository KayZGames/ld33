part of shared;

class Position extends Component {
  Vector3 value;
  Position(double x, double y, double z) : value = new Vector3(x, y, z);
}

class Dimensions extends Component {
  Vector3 value;
  Dimensions(double width, double height, double depth)
      : value = new Vector3(width, height, depth);
}

class Renderable extends Component {
  Vector3 rgb;
  Renderable(double red, double green, double blue)
      : rgb = new Vector3(red, green, blue);
}

class Camera extends Component {}
