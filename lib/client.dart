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
  CanvasElement hudCanvas;
  CanvasRenderingContext2D hudCtx;

  Game() : super.noAssets('ld33', '#game', 800, 600, webgl: true) {
    hudCanvas = querySelector('#hud');
    hudCtx = hudCanvas.context2D;
    hudCtx
      ..textBaseline = 'top'
      ..font = '16px Verdana';
  }

  void createEntities() {
    var tm = world.getManager(TagManager) as TagManager;
    addEntity([new Position(-150.0, 0.0, 0.1), new Dimensions(10.0, 100.0, 0.1), new Renderable(1.0, 0.0, 0.0)]);
    addEntity([new Position(-50.0, 0.0, 0.1), new Dimensions(10.0, 50.0, 0.1), new Renderable(0.0, 1.0, 0.0)]);
    addEntity([new Position(-250.0, 0.0, 0.1), new Dimensions(10.0, 50.0, 0.1), new Renderable(0.0, 0.0, 1.0)]);
    addEntity([new Position(100.0, -300.0, -1.0), new Dimensions(300.0, 600.0, 0.1), new Renderable(0.8, 0.8, 0.8)]);
    addEntity([new Position(200.0, 0.0, -10.0), new Dimensions(150.0, 50.0, 0.1), new Renderable(0.2, 0.2, 0.2)]);

    var camera = addEntity([new Position(0.0, 0.0, -700.0), new Camera()]);
    tm.register(camera, cameraTag);
  }

  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new CameraPositioningSystem(),
        new WebGlCanvasCleaningSystem(ctx),
        new RenderingSystem(ctx),
        new CanvasCleaningSystem(hudCanvas),
        new FpsRenderingSystem(hudCtx, fillStyle: 'white'),
      ],
      GameBase.physics: [
        new MovementSystem()
      ]
    };
  }

  onInit() {
    world.addManager(new TagManager());
  }


}
