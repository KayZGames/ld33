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
    var descriptionContainer = new DivElement();
    var description = new DivElement();
    var level = new DivElement();
    var cost = new DivElement();
    parentNode.append(upgradeElement);
    upgradeElement.append(button);
    upgradeElement.append(descriptionContainer);
    descriptionContainer.append(description);
    descriptionContainer.append(level);
    descriptionContainer.append(cost);

    upgradeElement.classes.add(upgrade.name);
    button.text = upgrade.label;
    button.disabled = true;
    description.innerHtml = upgrade.description;
    level.text = 'Level: ${upgrade.level}';
    cost.text = 'Cost: ${upgrade.cost}';
    buttons[upgrade.name] = button;

    button.onClick.listen((_) {
      button.disabled = true;
      statusManager.values[upgrade.resource] -= upgrade.cost;
      upgrade.level++;
      upgrade.cost = (upgrade.cost * upgrade.costMultiplier).ceil();
      level.text = 'Level: ${upgrade.level}';
      cost.text = 'Cost: ${upgrade.cost}';
      e.addComponent(new Owned());
      e.changedInWorld();
    });
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