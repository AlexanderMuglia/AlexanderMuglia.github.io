/**
* handes any events when a key is pressed
* pre: a relevant key has been pressed
* post: The appropriate statements have been called based on the key pressed
*/
void keyPressed() {
  if (stage==2 || stage ==3) {
    //for brightness
    if (key == 'u') {
      brightness =33;
    } else if (key == 'i') {
      brightness =63;
    } else if (key == 'o') {
      brightness =127;
    } else if (key == 'p') {
      brightness =191;
    } else if (key == 'y') {
      brightness =0;
    } else if (key == ' ') {
      if (snowboarder.velocity.y > -30 && jumpsLeft > 0) {
        jumpsLeft -= 1;              // prevents spamming jump
        if(isFlower){
          snowboarder.velocity.y -= 35;
        }else{
          snowboarder.velocity.y -= 30;       //jump
        }
      }
    } else if (key == 'd' || key == 'D') {
      overrideUpdateR = true;
    } else if (key == 'a' || key == 'A') {
      overrideUpdateL = true;
    }
  } else   if (stage==4) {
    if (key == 'b') {//get out of shop
      stage =1;
      //for testing coins
    } else if (key == 'a') {
      bank += 50;
    } else if (key == 's') {
      bank -= 50;
    } else if (key == 'r') {//reset skin to default
      isSnowCone = false;
      isFlower = false;
      isVerbena = false;
      isSunset =false;
      isNightSkiing = false;
      isSunsetSkiing = false;
      
      for(int i = 0; i < equipedSkins.length; i++){
        equipedSkins[i] = false;
      }
      
     for(int i = 0; i < equipedBackground.length; i++){
        equipedBackground[i] = false;
      }
    }
  }
}

/**
* handles events which are to be called upon a key being released 
* pre: none
* post: The stage / hill hass been created
*/

void keyReleased() {
  if (key == 'd' || key == 'D') {
    overrideUpdateR = false;
  } else if (key == 'a' | key == 'A') {
    overrideUpdateL = false;
  }
}
