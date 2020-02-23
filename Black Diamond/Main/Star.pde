/**
* Star class, creates the star power up in the game.
*/

class Star {
  PVector location;
  PVector velocity;
  PVector acceleration;
  int r;
  int x = 0;
  
  /**
  * Constructor for Star class
  * pre: none 
  * post: A Star object has been initialized with parameters
  */
  Star() {
    location = new PVector(100000, -10000000);
    velocity = new PVector(3, 1);
    acceleration = new PVector(0, 0.5);
    r = 40;
  }
  
  /**
  * updates the object each frame
  * pre: the object has been initialized
  * post: the object's position has been updated
  */
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    
    if(location.y >= stageFunction(location.x, stageMover, rndStage)){
      velocity.y *= -1;
      if(location.x > 0 && location.x < width){
        starBounce.play();
      }
    }
    
    x += 1;
  }
  
  /**
  * re-draws the object each frame after being updated
  * pre: the object has been initialized
  * post: the object is re-drawn on the screen
  */
  void show() {
    image(starImg, location.x, location.y, r, r);
  }
  
  /*
  * Checks for condition that would require the object to be reset
  * pre: the object has been initialized
  * post: the object is reset to its initial state and reused
  */
  void respawn(int x){
    //check distance between object and subject
    if (x == 5 && (location.x < 0 || location.x > width)){
      location.x = 0;
      location.y = 0;
      
      velocity.y = 0.5;
      
    }
  }
  
  /*
  * Checks for hit detection with the object and the snowboarder
  * pre: the object has been initialized
  * post: if the object has collided with the character, the statements are called
  */
  void collision() {
     if(dist(snowboarder.location.x + 25, snowboarder.location.y + 25, location.x, location.y) < (r/2)+60){
         canCollide = false;
         x = 0;
         starGrab.play();
         location.add(10000,-10000);
     }
  }
}
