/**
 * Snowball class, creates the snowball obstacle in the game.
 */

class Snowball {
  float x;
  float y;
  float r;

  /**
   * Constructor for Snowball class
   * pre: none 
   * post: A Snowball object has been initialized with parameters
   */
  Snowball() {
    r = 1;
    x = 10000000;
  }

  /*
  * Checks for condition that would require the object to be reset
   * pre: the object has been initialized
   * post: the object is reset to its initial state and reused
   */
  void respawn() {
    r = 1;
    x = -10;
  }

  /**
   * updates the object each frame
   * pre: the object has been initialized
   * post: the object's position has been updated
   */
  void update() {
    r += 0.3;  //grows as it travels

    x += 3;
    y = stageFunction(x, stageMover, rndStage);
  }

  /**
   * re-draws the object each frame after being updated
   * pre: the object has been initialized
   * post: the object is re-drawn on the screen
   */
  void show() {
    push();
    fill(255);
    stroke(200, 200, 255);
    ellipse(x, y-(r/2), r, r);
    pop();

    if (x < width) {
      if (frameCount % 60 < 31) {
        image(warning, width/2 - 40, height - 100, 80, 80);
        if (!buzz.isPlaying()) {
          buzz.play();
        }
      } else {
        if (buzz.isPlaying()) {
          buzz.stop();
        }
      }
    }
  }

  /*
  * Checks for hit detection with the object and the snowboarder
   * pre: the object has been initialized
   * post: if the object has collided with the character, the statements are called
   */
  void collision() {
    //check distance between object and subject
    if (dist(snowboarder.location.x + 15, snowboarder.location.y + 15, x, y) < (r/2)+15) {
      if (canCollide) {
        prevScore = numCoins;
        stage = 1;
        if (isSnowCone) {
          bank += (2 * numCoins);
        } else {
          bank += numCoins;
        }
        if (!playingAsGuest) {
          result.setInt("bank", bank);
          saveTable(table, "data/new1.csv");
        }
      }
    }
  }
}
