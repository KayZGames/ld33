part of client;

class ActionSystem extends EntityProcessingSystem {
  Mapper<Action> am;

  DivElement parentNode;

  ActionSystem(this.parentNode, Aspect aspect) : super(aspect.allOf([Action]));

  void inserted(Entity e) {
    var action = am[e];

    var actionElement = new DivElement();
    var button = new ButtonElement();
    var descrition = new DivElement();
    parentNode.append(actionElement);
    actionElement.append(button);
    actionElement.append(descrition);

    actionElement.classes.add(action.name);
    button.text = action.label;
    descrition.text = action.description;
    button.onClick.listen((_) => action.action());
  }

  @override
  void processEntity(Entity entity) {}
}

class PlayerActionSystem extends ActionSystem {
  PlayerActionSystem() : super(querySelector('#player .actions'), Aspect.getAspectForAllOf([Player]));
}

class MonsterActionSystem extends ActionSystem {
  MonsterActionSystem() : super(querySelector('#monster .actions'), Aspect.getAspectForAllOf([Monster]));
}