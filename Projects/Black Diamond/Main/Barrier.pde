/**
 * Barrier class, creates the obstacles within the game.
 */
class Barrier {
  float location;
  PImage img;

  /**
   * Constructor for Barrier class
   * pre: none 
   * post: A Barrier object has been initialized with parameters
   */
  Barrier(float num) {
    location = width + num*random(500, 600) + 100;
    img = barrier;
  }

  /**
   * updates the object each frame
   * pre: the object has been initialized
   * post: the object's position has been updated
   */
  void update() {
    location -= 3;

    if (location < -100) {
      location = width + random(15, 20)*random(500, 600) + 100;
    }
  }

  /**
   * re-draws the object each frame after being updated
   * pre: the object has been initialized
   * post: the object is re-drawn on the screen
   */
  void show() {
    if (img == barrier) {
      image(img, location, stageFunction(location, stageMover, rndStage)-60, 100, 100);
    } else if (img == brokenRocks) {
      image(img, location, stageFunction(location, stageMover, rndStage)-30, 100, 100);
    }
  }

  /*
  * Checks for hit detection with the object and the snowboarder
   * pre: the object has been initialized
   * post: if the object has collided with the character, the statements are called
   */
  void hit(float ballX, float ballY) {
    //check distance between object and subject
    if (Math.abs((ballX + 25) - (location + 50)) < 50) {
      if (Math.abs((ballY + 25) - (stageFunction(location, stageMover, rndStage) + 50)) < 50) {
        if (canCollide && img == barrier) {
          prevScore = numCoins;
          coinsCollected += numCoins;// cancels fram rate
  
          if (allowPass == false) {
            stage = 1;
          } else {
            hitCounter+=1;
            println(hitCounter);
            img = brokenRocks;
          }

          if (hitCounter > 0) { 
            allowPass = false;
          }

          if (isSnowCone) {
            bank += (2 * numCoins);
          } else {
            bank += numCoins;
          }

          if (!playingAsGuest) {
            result.setInt("bank", bank);
            saveTable(table, "data/new1.csv");
          }
        } else {
          img = brokenRocks;
        }
      } else {// the rock and the snowboarder have the same x location but not y, they have jumped over the rock so add to counter
        rockJumps += 1;
        jumpsCompleted = rockJumps/ 14;//cancels frame rate
      }
    }
  }
}
