part of client;



class PlayerSwitchingSystem extends VoidEntitySystem {
  PlayerStatusManager psm;
  PlayerUpgradeReseetingSystem purs;
  MonsterStatusManager msm;
  Queue<PlayerInfo> players = new Queue<PlayerInfo>.from([
    new PlayerInfo(
        2.0,
        0.0,
        250.0,
        'Common Idler',
        '''
        Plays an idle game to unlock as many upgrades as possible. Does quite a
        bit of clicking and reads related threads every now and then.
        '''),
    new PlayerInfo(
        5.0,
        0.0,
        1000.0,
        'Experienced Idler',
        '''
        Plays an idle game to unlock as many upgrades as possible and is a fast
        clicker. Tries to buy upgrades as efficient as possible.
        '''),
    new PlayerInfo(
        3.0,
        8.0,
        2500.0,
        'Auto Clicker',
        '''
        Wants to see fast progress. Creates his own simple scripts to click
        automatically.
        '''),
    new PlayerInfo(
        0.2,
        0.0,
        5000.0,
        'Browser Extension User',
        '''
        Wants to see fast progress but doesn't want to invest a lot of his own
        time and seldomly clicks. Uses browser extensions to call the
        relevant functions instead of clicking.
        '''),
    new PlayerInfo(
        0.1,
        0.0,
        10000.0,
        'Browser Extension Programmer',
        '''
        Implements scripts for others to use in the game. Knows what's going on
        behind the scenes and can't be tricked easily.
        '''),
    new PlayerInfo(
        4.0,
        40.0,
        25000.0,
        'Ludum Dare Participant',
        '''
        Procrastinating. Should be developing a 48h or 72h game for an important
        Game Jam instead.
        '''),
    new PlayerInfo(
        4.0,
        60.0,
        50000.0,
        'Rocket Scientist',
        '''
        Procrastinating. Should be developing faster rocket engines instead.
        '''),
  ]);
  bool autoClickerAdded = false;

  @override
  void processSystem() {
    if (psm.values[statusHappiness] <= 0.0) {
      if (players.length == 0) {} else {
        var player = players.removeFirst();
        psm.reset(player);
        purs.execute = true;
        msm.values[statusDefeatedPlayers]++;
        if (!autoClickerAdded && player.acps > 0.0) {
          world.createAndAddEntity([
            new Player(),
            new AutoClicker(),
            new Action('autoClick', 'Auto Click Monster', 'Click the monster using a script. Earn Gold.', () {
            }, 0.015)
          ]);
          querySelector('.crashAutoClick').style.display = 'block';
          autoClickerAdded = true;
        }
      }
    }
  }
}
