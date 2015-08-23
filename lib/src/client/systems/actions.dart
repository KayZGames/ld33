part of client;

class ActionSystem extends EntityProcessingSystem {
  Mapper<Action> am;
  Mapper<Cooldown> cm;

  Map<String, ButtonElement> buttons = {};

  Element parentNode;

  ActionSystem(this.parentNode, Aspect aspect) : super(aspect.allOf([Action]));

  void inserted(Entity e) {
    var action = am[e];

    var actionElement = new DivElement();
    var buttonContainer = new DivElement();
    var button = new ButtonElement();
    var progressBar = new DivElement();
    var descrition = new DivElement();
    actionElement.append(buttonContainer);
    buttonContainer.classes.add('buttonContainer');
    buttonContainer.append(button);
    buttonContainer.append(progressBar);
    actionElement.append(descrition);

    actionElement.classes.add(action.name);
    button.text = action.label;
    descrition.text = action.description;
    button.onClick.listen((_) {
      button.disabled = true;
      action.action();
      e.addComponent(new Cooldown(action.cooldown));
      e.changedInWorld();
    });
    parentNode.append(actionElement);
    buttons[action.name] = button;
  }

  @override
  void processEntity(Entity entity) {
    var action = am[entity];
    var cooldown = cm.getSafe(entity);
    var button = buttons[action.name];

    var percentage = 100.0;
    if (null != cooldown) {
      percentage = min(1.0, (action.cooldown - cooldown.value) / action.cooldown) * 100;
      button.disabled = true;
    } else {
      button.disabled = false;
    }

    button.nextElementSibling.style.width = '$percentage%';
  }
}

class PlayerActionSystem extends ActionSystem {
  PlayerActionSystem() : super(querySelector('#player .actions'), Aspect.getAspectForAllOf([Player]));
}

class MonsterActionSystem extends ActionSystem {
  MonsterActionSystem() : super(querySelector('#monster .actions'), Aspect.getAspectForAllOf([Monster]));
}