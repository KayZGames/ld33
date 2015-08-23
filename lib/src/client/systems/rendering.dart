part of client;

abstract class StatusRenderingSystem extends EntityProcessingSystem {
  Mapper<Status> sm;

  Map<String, DivElement> contentElements = {};

  Element parentNode;

  StatusRenderingSystem(this.parentNode, Aspect aspect)
      : super(aspect.allOf([Status]));

  void inserted(Entity e) {
    var status = sm[e];

    var statusElement = new DivElement();
    var label = new LabelElement();
    var content = new DivElement();
    parentNode.append(statusElement);
    statusElement.append(label);
    statusElement.append(content);

    statusElement.classes.add(status.name);
    label.text = status.label;
    contentElements[status.name] = content;
  }

  @override
  void processEntity(Entity entity) {
    var status = sm[entity];
    var value = statusManager.values[status.name];
    var element = contentElements[status.name];

    element.text = value.toStringAsFixed(0);

    if (element.parent.style.display == '' && value > 0) {
      element.parent.style.display = 'block';
    }
  }

  StatusManager get statusManager;
}

class PlayerStatusRenderingSystem extends StatusRenderingSystem {
  PlayerStatusManager psm;
  PlayerStatusRenderingSystem()
      : super(querySelector('#player .status'),
            Aspect.getAspectForAllOf([Player]));

  StatusManager get statusManager => psm;
}

class MonsterStatusRenderingSystem extends StatusRenderingSystem {
  MonsterStatusManager msm;
  MonsterStatusRenderingSystem()
      : super(querySelector('#monster .status'),
            Aspect.getAspectForAllOf([Monster]));
  StatusManager get statusManager => msm;
}


abstract class UpagradeRenderingSystem extends EntityProcessingSystem {
  Mapper<Upgrade> um;

  Map<String, ButtonElement> buttons = {};

  Element parentNode;

  UpagradeRenderingSystem(this.parentNode, Aspect aspect) : super(aspect.allOf([Upgrade]));
  void inserted(Entity e) {
    var upgrade = um[e];

    var upgradeElement = new DivElement();
    var button = new ButtonElement();
    var description = new DivElement();
    parentNode.append(upgradeElement);
    upgradeElement.append(button);
    upgradeElement.append(description);

    upgradeElement.classes.add(upgrade.name);
    button.text = upgrade.label;
    button.disabled = true;
    description.text = upgrade.description;
    buttons[upgrade.name] = button;
  }

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];
    var button = buttons[upgrade.name];
    var resource = statusManager.values[upgrade.resource];

    if (button.parent.style.display == 'none' && upgrade.thresholdToShow > resource) {
      button.parent.style.display = 'blocl';
    }
    if (upgrade.cost <= resource) {
      button.disabled = false;
    } else {
      button.disabled = true;
    }
  }

  StatusManager get statusManager;
}

class PlayerUpagradeRenderingSystem extends UpagradeRenderingSystem {
  PlayerStatusManager psm;
  PlayerUpagradeRenderingSystem()
      : super(querySelector('#player .upgrades'),
      Aspect.getAspectForAllOf([Player]));

  StatusManager get statusManager => psm;
}

class MonsterUpagradeRenderingSystem extends UpagradeRenderingSystem {
  MonsterStatusManager msm;
  MonsterUpagradeRenderingSystem()
      : super(querySelector('#monster .upgrades'),
      Aspect.getAspectForAllOf([Monster]));
  StatusManager get statusManager => msm;
}

