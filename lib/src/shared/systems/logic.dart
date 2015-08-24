part of shared;

abstract class StatusManager extends Manager {
  Map<String, double> values;
}

class PlayerStatusManager extends StatusManager {
  double goldMultiplier;
  double lastClick = 0.0;
  double lastAutoClick = 0.0;
  double lastFunctionCall = 0.0;
  PlayerInfo currentPlayer;

  PlayerStatusManager(PlayerInfo player) {
    reset(player);
  }

  void reset(PlayerInfo player) {
    values = {
      statusClicks: 0.0,
      statusMisses: 0.0,
      statusGold: 0.0,
      statusPain: 0.0,
      statusCrashes: 0.0,
      statusHappiness: player.happiness
    };
    goldMultiplier = 1.0;
    currentPlayer = player;
  }
}

class MonsterStatusManager extends StatusManager {
  bool randomMove = false;
  bool randomMoveTriggered = false;
  bool repetitiveStrainInjury = false;
  bool repetitiveStrainInjuryTriggered = false;
  bool crashAutoClicker = false;
  bool obfuscateCode = false;
  bool hackScript = false;
  bool hackScriptTriggered = false;

  MonsterStatusManager() {
    values = {
      statusFrustration: 0.0,
      statusQueuedMoves: 0.0,
      statusDefeatedPlayers: 0.0
    };
  }
}

class RandomMovementSystem extends EntityProcessingSystem {
  MonsterStatusManager msm;
  Mapper<Upgrade> um;
  RandomMovementSystem()
      : super(Aspect.getAspectForAllOf([Upgrade, RandomMovement, Owned]));

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];

    if (random.nextDouble() <= upgrade.level * upgrade.chance) {
      msm.randomMove = true;
    }
    msm.randomMoveTriggered = true;
  }

  bool checkProcessing() => !msm.randomMoveTriggered;
}

class RepetitiveStrainInjurySystem extends EntityProcessingSystem {
  MonsterStatusManager msm;
  Mapper<Upgrade> um;
  RepetitiveStrainInjurySystem()
      : super(Aspect.getAspectForAllOf([Upgrade, RepetitiveStrainInjury, Owned]));

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];

    if (random.nextDouble() <= upgrade.level * upgrade.chance) {
      msm.repetitiveStrainInjury = true;
    }
    msm.repetitiveStrainInjuryTriggered = true;
  }

  bool checkProcessing() => !msm.repetitiveStrainInjuryTriggered;
}

class HackScriptSystem extends EntityProcessingSystem {
  MonsterStatusManager msm;
  Mapper<Upgrade> um;
  HackScriptSystem()
      : super(Aspect.getAspectForAllOf([Upgrade, HackScript, Owned]));

  @override
  void processEntity(Entity entity) {
    var upgrade = um[entity];

    if (random.nextDouble() <= upgrade.level * upgrade.chance) {
      msm.hackScript = true;
    }
    msm.hackScriptTriggered = true;
  }

  bool checkProcessing() => !msm.hackScriptTriggered;
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
class PlayerInfo {
  double cps;
  double acps;
  double becps;
  double happiness;
  String type;
  String description;
  PlayerInfo(this.cps, this.acps, this.becps, this.happiness, this.type, this.description);
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
