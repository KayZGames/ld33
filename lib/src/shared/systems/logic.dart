part of shared;

class ClickerSystem extends EntityProcessingSystem {
  Mapper<Status> sm;
  ClickerSystem() : super(Aspect.getAspectForAllOf([Status, Clicker]));

  @override
  void processEntity(Entity entity) {
    sm[entity].value += 1.0;
  }
}