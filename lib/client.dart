library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;
import 'package:ld33/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
export 'package:gamedev_helpers/gamedev_helpers.dart';
//part 'src/client/systems/name.dart';
part 'src/client/systems/events.dart';
part 'src/client/systems/rendering.dart';

class Game extends GameBase {
  Game() : super.noCanvas('ld33');


  void createEntities() {
    addEntity([new Player(), new Status(statusClicks, 'Clicks'), new Clicker()]);
    addEntity([new Player(), new Status(statusMisses, 'Missed Clicks')]);

    addEntity([new Monster(), new Status(statusFrustration, 'Collected Frustration')]);

    addEntity([
      new Monster(),
      new Action(
          'move',
          'Movement',
          'Move a bit. The player won\'t hit you with his next click, thus raising his frustration.',
          () {
            var cs = world.getSystem(ClickerSystem) as ClickerSystem;
            cs.miss = true;
          })
    ]);
  }

  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new PlayerStatusRenderingSystem(),
        new MonsterStatusRenderingSystem(),
      ],
      GameBase.physics: [
        new ClickerSystem(),
        new PlayerActionSystem(),
        new MonsterActionSystem(),
      ]
    };
  }

  onInit() {
    world.addManager(new TagManager());
    world.addManager(new PlayerStatusManager(1.0));
    world.addManager(new MonsterStatusManager());
  }
}
