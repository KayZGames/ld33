library shared;
import 'dart:collection';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
part 'src/shared/components.dart';
//part 'src/shared/systems/name.dart';
part 'src/shared/systems/logic.dart';
part 'src/shared/systems/clicker.dart';


const String cameraTag = 'camera';

const String statusCps = 'cps';
const String statusClicks = 'clicks';
const String statusMisses = 'misses';
const String statusGold = 'gold';
const String statusHappiness = 'happiness';
const String statusFrustration = 'frustration';
const String statusQueuedMoves = 'queuedMoves';
const String statusDefeatedPlayers = 'defeatedPlayers';