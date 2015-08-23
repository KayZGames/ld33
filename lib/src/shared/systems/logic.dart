part of shared;

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
    }
    psm.values[target] += 1.0;

    miss = false;
    lastTime = time;
  }

  bool checkProcessing() => 1.0 / (time - lastTime) < psm.cps;
}

abstract class StatusManager extends Manager {
  Map<String, double> values;
}

class PlayerStatusManager extends StatusManager {
  double cps;

  PlayerStatusManager(this.cps) {
    values = {statusClicks: 0.0, statusMisses: 0.0,};
  }
}

class MonsterStatusManager extends StatusManager {
  MonsterStatusManager() {
    values = {statusFrustration: 0.0};
  }
}
