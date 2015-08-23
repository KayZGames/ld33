part of shared;

typedef void Script();

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
  int maxLevel;
  double chance;
  Script upgrade;
  double initialCost;


  Upgrade(
      this.name,
      this.resource,
      this.thresholdToShow,
      this.cost,
      this.costMultiplier,
      this.label,
      this.description,
      this.maxLevel,
      this.chance,
      this.upgrade,
      [this.level = 0]) {
    this.initialCost = cost;
  }
}

class Action extends Component {
  String name;
  String label;
  String description;
  Script action;
  double cooldown;
  Action(this.name, this.label, this.description, this.action, this.cooldown);
}

class Player extends Component {}

class Monster extends Component {}

class Clicker extends Component {}

class AutoClicker extends Component {}

class RandomMovement extends Component {}

class RepetitiveStrainInjury extends Component {}

class Owned extends Component {}

class Cooldown extends Component {
  double value;
  Cooldown(this.value);
}
