library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;
import 'package:ld33/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
export 'package:gamedev_helpers/gamedev_helpers.dart';
//part 'src/client/systems/name.dart';
part 'src/client/systems/actions.dart';
part 'src/client/systems/rendering.dart';
part 'src/client/systems/upgrades.dart';
part 'src/client/systems/status.dart';

class Game extends GameBase {
  Game() : super.noCanvas('ld33');

  void createEntities() {
    var psm = world.getManager(PlayerStatusManager) as PlayerStatusManager;

    addEntity([new Player(), new Status(statusHappiness, 'Happiness')]);
    addEntity([new Player(), new Status(statusGold, 'Gold')]);
    addEntity(
        [new Player(), new Status(statusClicks, 'Clicks')]);
    addEntity([new Player(), new Status(statusMisses, 'Missed Clicks')]);

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
          () => psm.goldMultiplier++),
    ]);

    addEntity([
      new Monster(),
      new Status(statusFrustration, 'Collected Frustration')
    ]);
    addEntity([
      new Monster(),
      new Status(statusQueuedMoves, 'Queued Evasions')
    ]);
    addEntity([
      new Monster(),
      new Status(statusDefeatedPlayers, 'Beaten Players')
    ]);

    var moveAction = new Action('move', 'Evade',
        'Evade the next click.', () {
      var cs = world.getSystem(ClickerSystem) as ClickerSystem;
      cs.miss++;
    }, 5.0);
    addEntity([new Monster(), moveAction]);

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
          () => moveAction.cooldown--),
    ]);

    addEntity([
      new Monster(),
      new Upgrade(
          'randomMove',
          statusFrustration,
          5.0,
          10.0,
          1.5,
          'Chicken Mode',
          'You\'ll randomly evade a click on your own.<br />Evasion chance: 5% per level',
          10, () {}),
      new RandomMovement(),
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
      ],
      GameBase.physics: [
        // player systems by priority
        new PlayerUpgradeBuyingSystem(),
        new ClickerSystem(),
        // rest
        new RandomMovementSystem(),
        new CooldownSystem(),
        new PlayerSwitchingSystem(),
        new PlayerUpgradeReseetingSystem(),
      ]
    };
  }

  onInit() {
    world.addManager(new TagManager());
    world.addManager(new PlayerStatusManager(1.0, 100.0));
    world.addManager(new MonsterStatusManager());
  }
}
