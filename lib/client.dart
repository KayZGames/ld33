library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;
import 'dart:typed_data';
import 'dart:web_gl';
import 'package:ld33/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
export 'package:gamedev_helpers/gamedev_helpers.dart';
//part 'src/client/systems/name.dart';
part 'src/client/systems/events.dart';
part 'src/client/systems/rendering.dart';

class Game extends GameBase {

  Game() : super.noCanvas('ld33');

  void createEntities() {
    addEntity([new Player(), new Status('clicks', 0.0), new Clicker()]);
  }

  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new PlayerStatusRenderingSystem(),
        new MonsterStatusRenderingSystem(),
      ],
      GameBase.physics: [
        new ClickerSystem()
      ]
    };
  }

  onInit() {
    world.addManager(new TagManager());
  }


}
