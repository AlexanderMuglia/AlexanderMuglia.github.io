/**
* Coin class, creates the collectable coins within the game.
*/

class Coin {
  float x;
  float y;
  float rnd;
  boolean gone;
  PVector pos;

  /**
  * Constructor for Coin class
  * pre: none 
  * post: A Coin object has been initialized with parameters
  */
  Coin(float num) {
    x = width + (num * random(200, 400));
    y = stageFunction(x, stageMover, rndStage);
    rnd = random(20, 150);
    gone = false;
    pos = new PVector(x, y-rnd);
  }
  
  /**
  * re-draws the object each frame after being updated
  * pre: the object has been initialized
  * post: the object is re-drawn on the screen
  */
  void show() {
    if (!gone) {
      image(coinImg, pos.x, pos.y, 20, 20);
    }
  }
  
  /**
  * updates the object each frame
  * pre: the object has been initialized
  * post: the object's position has been updated
  */
  void update() {
    if (gone) {
      respawn();
    } else {
      pos.x -= 3;
      pos.y = stageFunction(pos.x, stageMover, rndStage) - rnd;
    }
  }
  
  /*
  * Checks for condition that would require the object to be reset
  * pre: the object has been initialized
  * post: the object is reset to its initial state and reused
  */
  void respawn() {
    gone = false;
    pos.x = width + random(10000);
    pos.y = stageFunction(pos.x, stageMover, rndStage);
  }
  
  /*
  * Checks for hit detection with the object and the snowboarder
  * pre: the object has been initialized
  * post: if the object has collided with the character, the statements are called
  */
  void collected(float ballX, float ballY) {
    //check distance between object and subject
    if (Math.abs((ballX) - (pos.x+20)) < 40 ) {
      if (Math.abs((ballY) - (pos.y+20)) < 40 ) {
        gone = true;
        numCoins += 1;
        coinSound.play();
      }
    }

    if (pos.x < 0) {
      respawn();
    }
  }
}
