part of shared;

abstract class StatusManager extends Manager {
  Map<String, double> values;
}

class PlayerStatusManager extends StatusManager {
  double cps;

  PlayerStatusManager(this.cps) {
    values = {statusClicks: 0.0, statusMisses: 0.0, statusGold: 0.0};
  }
}

class MonsterStatusManager extends StatusManager {
  MonsterStatusManager() {
    values = {statusFrustration: 0.0};
  }
}
