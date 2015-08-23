part of shared;

typedef void MonsterAction();

class Status extends Component {
  String name;
  String label;
  Status(this.name, this.label);
}

class Upgrade extends Component {
  String name;
  String resource;
  double thresholdToShow;
  double cost;
  double costMultiplier;
  String label;
  String description;
  int level;
  Upgrade(this.name, this.resource, this.thresholdToShow, this.cost, this.costMultiplier, this.label,
      this.description, [this.level = 0]);
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

class RandomMovement extends Component {}

class Owned extends Component {}