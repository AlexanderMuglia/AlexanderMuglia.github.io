/**
* Snowflake class, creates the snowflakes within the game and sets their paths.
*/

class Snowflake {
  PVector location;
  PVector velocity;
  int size = (int)(random(10));

  /**
  * Constructor for Snowflake class
  * pre: none 
  * post: A Snowflake object has been initialized with parameters
  */
  Snowflake() {
    location = new PVector(random(width+200), random(-600, -10));
    velocity = new PVector(random(-10, 0), random(1, 10));
  }
  
  /**
  * re-draws the object each frame after being updated
  * pre: the object has been initialized
  * post: the object is re-drawn on the screen
  */
  void show() {
    fill(255);
    ellipse(location.x, location.y, size, size);
  }
  
  /**
  * updates the object each frame
  * pre: the object has been initialized
  * post: the object's position has been updated
  */
  void update() {
    location.add(velocity);
  }
  
  /*
  * Checks for condition that would require the object to be reset
  * pre: the object has been initialized
  * post: the object is reset to its initial state and reused
  */
  void respawn() {
    if (location.y> height) {
      location.y = random(-600, -10);
      location.x = random(width);
    }

    if (location.x < 0) {
      location.y = random(-600, -10);
      location.x = random(width);
    }
  }
}
