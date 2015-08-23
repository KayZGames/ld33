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
      psm.values[statusHappiness] -= 1.0;
      msm.values[statusFrustration] += 2.0;
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
      psm.values[statusHappiness] -= 50.0;
      msm.values[statusFrustration] += 50.0;
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
