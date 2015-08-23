part of shared;

typedef void MonsterAction();

class Status extends Component {
  String name;
  String label;
  Status(this.name, this.label);
}

class Upgrade extends Component {
  String name;
  Upgrade(this.name);
}

class Action extends Component {
  String name;
  String label;
  String description;
  MonsterAction action;
  Action(this.name, this.label, this.description, this.action);
}

class Player extends Component {}
class Monster extends Component {}
class Clicker extends Component {}