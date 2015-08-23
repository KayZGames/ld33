part of shared;

class ClickerSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  MonsterStatusManager msm;

  bool miss = false;
  bool randomMove = false;
  bool randomMoveTriggered = false;
  double lastTime = 0.0;

  Mapper<Status> sm;

  ClickerSystem() : super(Aspect.getAspectForAllOf([Status, Clicker]));

  @override
  void processEntity(Entity entity) {
    var target = statusClicks;
    if (miss || randomMove) {
      target = statusMisses;
      msm.values[statusFrustration] += 1.0;
    } else {
      psm.values[statusGold] += 1.0;
    }
    psm.values[target] += 1.0;

    if (randomMove) {
      randomMove = false;
    } else if (miss) {
      miss = false;
    }
    lastTime = time;
    randomMoveTriggered = false;
  }

  bool checkProcessing() => 1.0 / (time - lastTime) < psm.cps;
}
