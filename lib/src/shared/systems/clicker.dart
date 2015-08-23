part of shared;

class ClickerSystem extends EntityProcessingSystem {
  PlayerStatusManager psm;
  MonsterStatusManager msm;

  bool randomMove = false;
  bool randomMoveTriggered = false;
  double lastTime = 0.0;

  Mapper<Action> am;

  ClickerSystem() : super(Aspect.getAspectForAllOf([Player, Action, Clicker]));

  @override
  void processEntity(Entity entity) {
    var action = am[entity];
    entity.addComponent(new Cooldown(action.cooldown));
    entity.changedInWorld();
    var target = statusClicks;
    if (miss > 0 || randomMove) {
      target = statusMisses;
      msm.values[statusFrustration] += 1.0;
      psm.values[statusHappiness] -= 1.0;
    } else {
      psm.values[statusGold] += 1.0 * psm.goldMultiplier;
      psm.values[statusHappiness] += 0.1 * psm.goldMultiplier;
    }
    psm.values[target] += 1.0;

    if (randomMove) {
      randomMove = false;
    } else if (miss > 0) {
      miss--;
    }
    psm.lastClick = time;
    randomMoveTriggered = false;
  }

  bool checkProcessing() => 1.0 / (time - psm.lastClick) < psm.cps;
  double get miss => msm.values[statusQueuedMoves];
  set miss(double newValue) => msm.values[statusQueuedMoves] = newValue;
}
