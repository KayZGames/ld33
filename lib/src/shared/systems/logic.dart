part of shared;

class MovementSystem extends EntityProcessingSystem {
  MovementSystem() : super(Aspect.getAspectForAllOf([Position]));


  @override
  void processEntity(Entity entity) {
    // TODO: implement processEntity
  }
}