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