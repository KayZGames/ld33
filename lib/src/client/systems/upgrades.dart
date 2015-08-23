part of client;


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