import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:mygame/components/enemy_spawner.dart';
import 'package:mygame/components/health_bar.dart';
import 'package:mygame/components/highscore_text.dart';
import 'package:mygame/components/score_text.dart';
import 'package:mygame/components/start_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_state.dart';
import 'dart:ui';

import 'components/enemy.dart';
import 'components/player.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  int score;
  Size screenSize;
  double tileSize;
  Player player;
  List<Enemy> enemies;
  EnemySpawner enemySpawner;
  HealthBar healthBar;
  ScoreText scoreText;
  GameState state;
  HighscoreText highscoreText;
  StartButton startButton;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = GameState.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    healthBar = HealthBar(this);
    enemySpawner = EnemySpawner(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startButton = StartButton(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state == GameState.menu) {
      highscoreText.render(c);
      startButton.render(c);
    } else if (state == GameState.playing) {
      enemies.forEach((Enemy e) => e.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == GameState.menu) {
      highscoreText.update(t);
      startButton.update(t);
    } else if (state == GameState.playing) {
      enemySpawner.update(t);
      enemies.forEach((Enemy e) => e.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      scoreText.update(t);
      healthBar.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == GameState.menu) {
      state = GameState.playing;
    } else if (state == GameState.playing) {
      enemies.forEach((Enemy e) {
        if (e.enemyRect.contains(d.globalPosition)) {
          e.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        //Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        //right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        //bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        //left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
