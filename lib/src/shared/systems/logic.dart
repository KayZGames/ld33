part of shared;

abstract class StatusManager extends Manager {
  Map<String, double> values;
}

class PlayerStatusManager extends StatusManager {
  double cps;
  double goldMultiplier;
  double lastClick = 0.0;

  PlayerStatusManager(double cps, double happiness) {
    reset(cps, happiness);
  }

  void reset(double cps, happiness) {
    values = {
      statusClicks: 0.0,
      statusMisses: 0.0,
      statusGold: 0.0,
      statusHappiness: happiness
    };
    goldMultiplier = 1.0;
    this.cps = cps;
    this.goldMultiplier = 1.0;
  }
}

class MonsterStatusManager extends StatusManager {
  MonsterStatusManager() {
    values = {
      statusFrustration: 0.0,
      statusQueuedMoves: 0.0,
      statusDefeatedPlayers: 0.0
    };
  }
}

class RandomMovementSystem extends EntityProcessingSystem {
  ClickerSystem cs;
  Mapper<Upgrade> um;
  RandomMovementSystem()
      : super(Aspect.getAspectForAllOf([Upgrade, RandomMovement, Owned]));

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

class CooldownSystem extends EntityProcessingSystem {
  Mapper<Cooldown> cm;
  CooldownSystem() : super(Aspect.getAspectForAllOf([Cooldown]));

  @override
  void processEntity(Entity entity) {
    var cooldown = cm[entity];
    cooldown.value -= world.delta;
    if (cooldown.value <= 0.0) {
      entity.removeComponent(Cooldown);
      entity.changedInWorld();
    }
  }
}

class PlayerSwitchingSystem extends VoidEntitySystem {
  PlayerStatusManager psm;
  PlayerUpgradeReseetingSystem purs;
  MonsterStatusManager msm;
  Queue<Map<String, double>> players = new Queue<Map<String, double>>.from([
    {statusCps: 2.0, statusHappiness: 1000.0}
  ]);

  @override
  void processSystem() {
    if (psm.values[statusHappiness] <= 0.0) {
      if (players.length == 0) {} else {
        var player = players.removeFirst();
        psm.reset(player[statusCps], player[statusHappiness]);
        purs.execute = true;
        msm.values[statusDefeatedPlayers]++;
      }
    }
  }
}

class PlayerUpgradeReseetingSystem extends EntityProcessingSystem {
  Mapper<Upgrade> um;
  bool execute = false;
  PlayerUpgradeReseetingSystem()
      : super(Aspect.getAspectForAllOf([Player, Upgrade, Owned]));

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];
    upgrade.level = 0;
    upgrade.cost = upgrade.initialCost;
    entity.removeComponent(Owned);
    entity.changedInWorld();
    execute = false;
  }

  bool checkProcessing() => execute;
}
