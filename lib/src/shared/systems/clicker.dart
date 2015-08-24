part of shared;

class ClickerSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  MonsterStatusManager msm;

  Mapper<Action> am;

  ClickerSystem() : super(Aspect.getAspectForAllOf([Player, Action, Clicker]));

  @override
  void processEntity(Entity entity) {
    var action = am[entity];
    entity.addComponent(new Cooldown(action.cooldown));
    entity.changedInWorld();
    var target = statusClicks;
    if (miss > 0 || msm.randomMove) {
      target = statusMisses;
      msm.values[statusFrustration] += 1.0;
      psm.values[statusHappiness] -= 1.0;
    } else {
      psm.values[statusGold] += 1.0 * psm.goldMultiplier;
      psm.values[statusHappiness] += 0.25 * psm.goldMultiplier;
    }
    psm.values[target] += 1.0;

    if (msm.randomMove) {
      msm.randomMove = false;
    } else if (miss > 0) {
      miss--;
    }
    psm.lastClick = time;
    msm.randomMoveTriggered = false;

    if (msm.repetitiveStrainInjury) {
      psm.values[statusPain] += 1.0;
      psm.values[statusHappiness] -= 2.0;
      msm.values[statusFrustration] += 5.0;
      msm.repetitiveStrainInjury = false;
    }
    msm.repetitiveStrainInjuryTriggered = false;
  }

  bool checkProcessing() =>
      1.0 / (time - psm.lastClick) < psm.currentPlayer.cps;
  double get miss => msm.values[statusQueuedMoves];
  set miss(double newValue) => msm.values[statusQueuedMoves] = newValue;
}

class AutoClickerSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  MonsterStatusManager msm;
  double crashCooldown = 0.0;

  Mapper<Action> am;
  AutoClickerSystem()
      : super(Aspect.getAspectForAllOf([Player, AutoClicker, Action]));

  @override
  void processEntity(Entity entity) {
    if (!msm.crashAutoClicker && crashCooldown <= 0.0) {
      var action = am[entity];
      entity.addComponent(new Cooldown(action.cooldown));
      entity.changedInWorld();
      var target = statusClicks;
      if (miss > 0 || msm.randomMove) {
        target = statusMisses;
        msm.values[statusFrustration] += 1.0;
        psm.values[statusHappiness] -= 1.0;
      } else {
        psm.values[statusGold] += 1.0 * psm.goldMultiplier;
        psm.values[statusHappiness] += 0.25 * psm.goldMultiplier;
      }
      psm.values[target] += 1.0;

      if (msm.randomMove) {
        msm.randomMove = false;
      } else if (miss > 0) {
        miss--;
      }
    } else if (crashCooldown <= 0.0) {
      psm.values[statusCrashes] += 1.0;
      psm.values[statusHappiness] -= 100.0;
      msm.values[statusFrustration] += 100.0;
      msm.crashAutoClicker = false;
      crashCooldown = 5.0;
    }
    psm.lastAutoClick = time;
    msm.randomMoveTriggered = false;
  }

  bool checkProcessing() {
    crashCooldown -= world.delta;
    return 1.0 / (time - psm.lastAutoClick) < psm.currentPlayer.acps;
  }

  double get miss => msm.values[statusQueuedMoves];
  set miss(double newValue) => msm.values[statusQueuedMoves] = newValue;
}


class BrowserExtensionClickerSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  MonsterStatusManager msm;
  double crashCooldown = 0.0;
  double obfuscationCooldown = 0.0;

  Mapper<Action> am;
  BrowserExtensionClickerSystem()
      : super(Aspect.getAspectForAllOf([Player, BrowserExtensionClicker, Action]));

  @override
  void processEntity(Entity entity) {
    if (!msm.obfuscateCode && !msm.crashAutoClicker && crashCooldown <= 0.0 && obfuscationCooldown <= 0.0) {
      var action = am[entity];
      entity.addComponent(new Cooldown(action.cooldown));
      entity.changedInWorld();
      psm.values[statusGold] += 1.0 * psm.goldMultiplier;
      psm.values[statusHappiness] += 0.25 * psm.goldMultiplier;
      if (msm.hackScript) {
        msm.values[statusFrustration] += psm.values[statusHappiness] * 0.1;
        psm.values[statusHappiness] *= 0.9;
        msm.hackScript = false;
      }
      msm.hackScriptTriggered = false;
    } else if (msm.crashAutoClicker && crashCooldown <= 0.0) {
      psm.values[statusCrashes] += 1.0;
      psm.values[statusHappiness] -= 100.0;
      msm.values[statusFrustration] += 100.0;
      if (psm.currentPlayer.acps == 0.0) {
        msm.crashAutoClicker = false;
      }
      crashCooldown = 5.0;
    } else if (msm.obfuscateCode && obfuscationCooldown <= 0.0) {
      psm.values[statusHappiness] -= 500.0;
      msm.values[statusFrustration] += 500.0;
      msm.obfuscateCode = false;
      obfuscationCooldown = 10.0;
    }
    psm.lastFunctionCall = time;
    msm.randomMoveTriggered = false;
  }

  bool checkProcessing() {
    crashCooldown -= world.delta;
    obfuscationCooldown -= world.delta;
    return 1.0 / (time - psm.lastFunctionCall) < psm.currentPlayer.becps;
  }

}
