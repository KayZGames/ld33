part of client;

abstract class UpagradeSystem extends EntityProcessingSystem {
  Mapper<Upgrade> um;

  Map<String, ButtonElement> buttons = {};

  Element parentNode;

  UpagradeSystem(this.parentNode, Aspect aspect)
      : super(aspect.allOf([Upgrade]));

  void executeUpgrade(Upgrade upgrade, Entity e) {
    (parentNode.querySelector('button') as ButtonElement).disabled = true;
    statusManager.values[upgrade.resource] -= upgrade.cost;
    upgrade.upgrade();
    upgrade.level++;
    upgrade.cost = (upgrade.cost * upgrade.costMultiplier).ceil() * 1.0;
    e.addComponent(new Owned());
    e.changedInWorld();
  }

  void inserted(Entity e) {
    var upgrade = um[e];

    var upgradeElement = new DivElement();
    var buttonContainer = new DivElement();
    var button = new ButtonElement();
    var progressBar = new DivElement();
    var descriptionContainer = new DivElement();
    var description = new DivElement();
    var level = new DivElement();
    var cost = new DivElement();
    upgradeElement.append(buttonContainer);
    buttonContainer.classes.add('buttonContainer');
    buttonContainer.append(button);
    buttonContainer.append(progressBar);
    upgradeElement.append(descriptionContainer);
    descriptionContainer.append(description);
    descriptionContainer.append(level);
    descriptionContainer.append(cost);

    upgradeElement.classes.add(upgrade.name);
    upgradeElement.style.display = 'none';
    button.text = upgrade.label;
    button.disabled = true;
    description.innerHtml = upgrade.description;
    level.text = 'Level: ${upgrade.level}';
    level.classes.add('level');
    cost.text = 'Cost: ${upgrade.cost.toStringAsFixed(0)}';
    cost.classes.add('cost');

    button.onClick.listen((_) => executeUpgrade(upgrade, e));
    parentNode.append(upgradeElement);
    buttons[upgrade.name] = button;
  }

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];
    var button = buttons[upgrade.name];
    var resource = statusManager.values[upgrade.resource];
    var percentage = min(1.0, resource / upgrade.cost) * 100;
    var level = parentNode.querySelector('.${upgrade.name} .level');
    var cost = parentNode.querySelector('.${upgrade.name} .cost');

    if (button.parent.parent.style.display == 'none' &&
        upgrade.thresholdToShow <= resource) {
      button.parent.parent.style.display = 'block';
    }
    if (upgrade.cost <= resource && upgrade.level < upgrade.maxLevel) {
      button.disabled = false;
    } else {
      button.disabled = true;
    }
    if (upgrade.level < upgrade.maxLevel) {
      button.nextElementSibling.style.width = '$percentage%';
    } else {
      button.nextElementSibling.style.width = '0%';
    }
    if (upgrade.level == upgrade.maxLevel) {
      level.text = 'Level: ${upgrade.level} (max level)';
      cost.text = '';
    } else {
      level.text = 'Level: ${upgrade.level}';
      cost.text = 'Cost: ${upgrade.cost.toStringAsFixed(0)}';
    }
  }

  StatusManager get statusManager;
}

class PlayerUpagradeSystem extends UpagradeSystem {
  PlayerStatusManager psm;
  PlayerUpagradeSystem()
      : super(querySelector('#player .upgrades'),
            Aspect.getAspectForAllOf([Player]));

  StatusManager get statusManager => psm;
}

class MonsterUpagradeSystem extends UpagradeSystem {
  MonsterStatusManager msm;
  MonsterUpagradeSystem()
      : super(querySelector('#monster .upgrades'),
            Aspect.getAspectForAllOf([Monster]));
  StatusManager get statusManager => msm;
}

class PlayerUpgradeBuyingSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  PlayerUpagradeSystem pus;
  Mapper<Upgrade> um;
  PlayerUpgradeBuyingSystem()
      : super(Aspect.getAspectForAllOf([Player, Upgrade]));

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];
    var resource = psm.values[upgrade.resource];

    if (upgrade.cost <= resource) {
      pus.executeUpgrade(upgrade, entity);
      psm.lastClick = time;
    }
  }

  bool checkProcessing() => 1.0 / (time - psm.lastClick) < psm.cps;
}