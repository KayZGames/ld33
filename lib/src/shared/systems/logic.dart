part of shared;

class MovementSystem extends EntityProcessingSystem {
  MovementSystem() : super(Aspect.getAspectForAllOf([Position]));


  @override
  void processEntity(Entity entity) {
    // TODO: implement processEntity
  }
}

class CameraPositioningSystem extends VoidEntitySystem {
  Mapper<Position> pm;
  TagManager tm;

  int invocations = 0;
  static final int maxInvocations = 200;

  @override
  void processSystem() {
    invocations++;

    var camera = tm.getEntity(cameraTag);
    var pos = pm[camera];
    var factor = invocations / maxInvocations;
    var angle = easeInOutBack(factor, 0.0, PI, 1.0);

    var xFactor = sin(angle);
    var zFactor = cos(angle);

    pos.value.x = xFactor * 700.0;
    pos.value.z = zFactor * -700.0;
  }

  bool checkProcessing() => invocations < maxInvocations;

  double easeInOutBack(factor, start, end, maxFactor) {
    var s = 1.1;
    if ((factor/=maxFactor/2) < 1) return end/2*(factor*factor*(((s*=(1.525))+1)*factor - s)) + start;
    return end/2*((factor-=2)*factor*(((s*=(1.525))+1)*factor + s) + 2) + start;
  }
}