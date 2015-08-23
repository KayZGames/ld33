part of shared;

abstract class StatusManager extends Manager {
  Map<String, double> values;
}

class PlayerStatusManager extends StatusManager {
  double cps;

  PlayerStatusManager(this.cps) {
    values = {statusClicks: 0.0, statusMisses: 0.0, statusGold: 0.0};
  }
}

class MonsterStatusManager extends StatusManager {
  MonsterStatusManager() {
    values = {statusFrustration: 0.0};
  }
}

class RandomMovementSystem extends EntityProcessingSystem {
  ClickerSystem cs;
  Mapper<Upgrade> um;
  RandomMovementSystem() : super(Aspect.getAspectForAllOf([Upgrade, RandomMovement, Owned]));

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];

    if (random.nextDouble() <= upgrade.level * 0.05) {
      cs.randomMove = true;
    }
    cs.randomMoveTriggered = true;
  }

  bool checkProcessing() => !cs.randomMoveTriggered;
}