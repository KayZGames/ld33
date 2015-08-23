library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;
import 'package:ld33/shared.dart';
import 'dart:collection';
import 'package:gamedev_helpers/gamedev_helpers.dart';
export 'package:gamedev_helpers/gamedev_helpers.dart';
//part 'src/client/systems/name.dart';
part 'src/client/systems/actions.dart';
part 'src/client/systems/rendering.dart';
part 'src/client/systems/upgrades.dart';
part 'src/client/systems/status.dart';
part 'src/client/systems/player_switching_system.dart';

class Game extends GameBase {
  Game() : super.noCanvas('ld33');

  void createEntities() {
    var psm = world.getManager(PlayerStatusManager) as PlayerStatusManager;
    var msm = world.getManager(MonsterStatusManager) as MonsterStatusManager;

    addEntity([new Player(), new Status(statusHappiness, 'Happiness')]);
    addEntity([new Player(), new Status(statusGold, 'Gold')]);
    addEntity([new Player(), new Status(statusClicks, 'Successful Clicks')]);
    addEntity([new Player(), new Status(statusMisses, 'Missed Clicks')]);
    addEntity([new Player(), new Status(statusPain, 'Painful Clicks')]);
    addEntity([new Player(), new Status(statusCrashes, 'Script Crashes')]);

    addEntity([
      new Player(),
      new Clicker(),
      new Action('click', 'Click Monster', 'Click the monster. Earn Gold.', () {
      }, 0.25)
    ]);

    addEntity([
      new Player(),
      new Upgrade(
          'goldPerClick',
          statusGold,
          0.0,
          10.0,
          2.0,
          'Gold Digger',
          'Earn 1 more piece of gold per click.',
          10,
          1.0,
          () => psm.goldMultiplier++),
    ]);

    addEntity([
      new Monster(),
      new Status(statusFrustration, 'Collected Frustration')
    ]);
    addEntity(
        [new Monster(), new Status(statusQueuedMoves, 'Queued Evasions')]);
    addEntity(
        [new Monster(), new Status(statusDefeatedPlayers, 'Beaten Players')]);

    var autoClickerAction =
        new Action('crashAutoClick', 'Crash Script', 'Crashes any script a player is currently running.', () {
      msm.crashAutoClicker = true;
    }, 10.0);
    addEntity([new Monster(), autoClickerAction]);

    var moveAction = new Action('move', 'Evade', 'Evade the next click.', () {
      var cs = world.getSystem(ClickerSystem) as ClickerSystem;
      cs.miss++;
    }, 5.0);
    addEntity([new Monster(), moveAction]);

    addEntity([
      new Monster(),
      new Upgrade(
          'crashAutoClickerCooldown',
          statusFrustration,
          450.0,
          500.0,
          1.6,
          'Party Crasher',
          'Script crashes can be triggered faster.',
          10,
          1.0, () {
        moveAction.cooldown -= 0.5;
      }),
    ]);

    addEntity([
      new Monster(),
      new Upgrade(
          'randomMove',
          statusFrustration,
          15.0,
          25.0,
          1.6,
          'Chicken Mode',
          'You\'ll randomly evade a click on your own.<br />Evasion chance: 5.0% per level',
          10,
          0.05, () {}),
      new RandomMovement(),
    ]);

    addEntity([
      new Monster(),
      new Upgrade(
          'randomFingerPain',
          statusFrustration,
          5.0,
          10.0,
          1.4,
          'Repetitive Strain Injury',
          'The player may feel a stinging pain in his finger and/or hand when clicking. 5.0% chance per level.',
          10,
          0.05, () {}),
      new RepetitiveStrainInjury(),
    ]);

    addEntity([
      new Monster(),
      new Upgrade(
          'movementCooldown',
          statusFrustration,
          0.0,
          4.0,
          1.5,
          'Fast Mover',
          'Manual evasion cooldown will be reduced by 1s per level.',
          5,
          1.0,
          () => moveAction.cooldown--),
    ]);
  }

  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new PlayerStatusRenderingSystem(),
        new MonsterStatusRenderingSystem(),
        new PlayerUpagradeSystem(),
        new MonsterUpagradeSystem(),
        new PlayerActionSystem(),
        new MonsterActionSystem(),
        new PlayerInfoRenderingSystem(),
      ],
      GameBase.physics: [
        // player systems by priority
        new PlayerUpgradeBuyingSystem(),
        new ClickerSystem(),
        // rest
        new AutoClickerSystem(),
        new RandomMovementSystem(),
        new RepetitiveStrainInjurySystem(),
        new CooldownSystem(),
        new PlayerSwitchingSystem(),
        new PlayerUpgradeReseetingSystem(),
      ]
    };
  }

  onInit() {
    world.addManager(new TagManager());
    world.addManager(new PlayerStatusManager(new PlayerInfo(
        1.0,
        0.0,
        100.0,
        'Casual Idler',
        '''Plays an idle game every now and then. Isn't very invested and clicks quite slowly.''')));
    world.addManager(new MonsterStatusManager());
  }
}
