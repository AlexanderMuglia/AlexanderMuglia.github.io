/**
* Snowboarder class, creates the main character in the game and controlls all movement.
*/

class Snowboarder {
  PVector velocity;
  PVector acceleration;
  PVector location;
  int colorNum = 0;
  
  /**
  * Constructor for Snowboarder class
  * pre: none 
  * post: A Snowboarder object has been initialized with parameters
  */
  Snowboarder() {
    location = new PVector(width/5, stageFunction(width/5, stageMover, rndStage));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0.5, 1.5);
  }

  /**
  * updates the object each frame
  * pre: the object has been initialized
  * post: the object's position has been updated
  */
  void update() {
    //allows for user control of player
    if (overrideUpdateL) {
      velocity.x = -2;
    } else if (overrideUpdateR) {
      velocity.x = 3;
    } else {
      velocity.x = derSF(location.x, stageMover)*3;
    }
    
    //updates the velocity of the snowboarder in a realistic manner
    velocity.y += derSF(location.x, stageMover); // uses derivative of stage func
    velocity.add(acceleration);
    location.add(velocity);
    velocity.y *= 0.9;
    if (velocity.x < 15) {
      velocity.x *= 1.005;
    } else {
      velocity.x *= 0.9;
    }
  }
  
  /*
  * Checks for hit detection with the object and the stage
  * pre: the object has been initialized
  * post: if the object has collided with the stage, the statements are called
  */
  void checkStage() {
    //check distance between object and subject
    if (location.x > width) { 
      location.y = 0;
      location.x = 0;
    } else if (location.x < 0) { 
      velocity.x *= -1;
      //location.x = 0;
    }

    if (location.y > stageFunction(location.x, stageMover, rndStage)) { 
      velocity.y = 0;
      jumpsLeft = 2;   // reset jump counter
      if (derSF(location.x, stageMover)<0) { //if it hits the slope at a positive value
        velocity.x *= -1;
      }
      location.y = stageFunction(location.x, stageMover, rndStage);
    }
  }
  
  /**
  * re-draws the object each frame after being updated
  * pre: the object has been initialized
  * post: the object is re-drawn on the screen
  */
  void show() {
    if (snowboarder.location.y < stageFunction(location.x, stageMover, rndStage)) {   //mid jump
      if (isSnowCone) {
        image(snowConeInAir, location.x-25, location.y-40, 50, 50);
      } else if (isSunset) {
        image(sunsetInAir, location.x-25, location.y-40, 50, 50);
      } else if (isVerbena) {
        image(verbenaInAir, location.x-25, location.y-40, 50, 50);
      } else if (isFlower) {
        image(flowerInAir, location.x-25, location.y-40, 50, 50);
      } else {
        image(boarderInAir, location.x-25, location.y-40, 50, 50);
      }
    } else {                         
      if (isSnowCone) {
        image(snowConeOnGround, location.x-25, location.y-40, 50, 50);// if on the line
      } else if (isSunset) {
        image(sunsetOnGround, location.x-25, location.y-40, 50, 50);
      } else if (isVerbena) {
        image(verbenaOnGround, location.x-25, location.y-40, 50, 50);
      } else if (isFlower) {
        image(flowerOnGround, location.x-25, location.y-40, 50, 50);
      } else {

        image(boarderOnGround, location.x-25, location.y-40, 50, 50);// if on the line
      }
    }
  }
}
