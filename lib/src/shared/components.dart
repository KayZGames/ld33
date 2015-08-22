part of shared;

class Status extends Component {
  String name;
  double value;
  Status(this.name, this.value);
}

class Upgrade extends Component {
  String name;
  Upgrade(this.name);
}

class Player extends Component {}
class Monster extends Component {}
class Clicker extends Component {}