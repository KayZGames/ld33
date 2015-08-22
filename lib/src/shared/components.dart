part of shared;

class Position extends Component {
  Vector3 value;
  Position(double x, double y, double z) : value = new Vector3(x, y, z);
}

class Renderable extends Component {}