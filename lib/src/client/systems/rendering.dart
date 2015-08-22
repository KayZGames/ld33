part of client;

abstract class StatusRenderingSystem extends EntityProcessingSystem {
  Mapper<Status> sm;

  DivElement parentNode;

  StatusRenderingSystem(this.parentNode, Aspect aspect) : super(aspect.allOf([Status]));

  @override
  void processEntity(Entity entity) {
    var status = sm[entity];

    parentNode.querySelector('.${status.name}').innerHtml = status.value.toStringAsFixed(0);
  }
}

class PlayerStatusRenderingSystem extends StatusRenderingSystem {
  PlayerStatusRenderingSystem() : super(querySelector('#player .status'), Aspect.getAspectForAllOf([Player]));
}

class MonsterStatusRenderingSystem extends StatusRenderingSystem {
  MonsterStatusRenderingSystem() : super(querySelector('#monster .status'), Aspect.getAspectForAllOf([Monster]));
}