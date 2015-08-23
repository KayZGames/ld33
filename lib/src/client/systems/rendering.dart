part of client;





class ClickerSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  MonsterStatusManager msm;

  bool miss = false;
  double lastTime = 0.0;

  Mapper<Status> sm;
  ClickerSystem() : super(Aspect.getAspectForAllOf([Status, Clicker]));

  @override
  void processEntity(Entity entity) {
    var target = statusClicks;
    if (miss) {
      target = statusMisses;
      msm.values[statusFrustration] += 1.0;
    } else {
      psm.values[statusGold] += 1.0;
    }
    psm.values[target] += 1.0;

    miss = false;
    lastTime = time;
  }

  bool checkProcessing() => 1.0 / (time - lastTime) < psm.cps;
}
