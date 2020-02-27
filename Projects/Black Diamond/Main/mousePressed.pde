/**
 * Controls all actions to be completed when the mouse is pressed.
 * pre: the mouse is pressed
 * post: the appropriate statements have been called based on the location and time of click
 */
void mousePressed() {
  if (mouseX>=940 && mouseX <=990 && mouseY >=20 && mouseY <=75) {
    pause = false; 
    counter +=1; 
    if (counter>3) {
      counter = 1;
    }
    println("yes"); 
    println(counter);
  }
  //pause buttton
  if (mouseX>= 82 && mouseX<=482 && mouseY>= 100 && mouseY <= 200 && stage == 1) { //play button
    stage =2;
    numPlays += 1;
  }
  if (trans1 > 0 && stage != 3) {      //tutorial begins
    stage = 3;
    tutMillis = millis();
  }
  //back buttton for tutorial
  if (stage == 3) {
    if (mouseX > width-150 && mouseX < width-40) {
      if (mouseY < 190 && mouseY > 150) {
        stage = 1;
        reset();
      }
    }
  }
  //shop button
  if (mouseX >=140 && mouseX <=162 && mouseY>=400 && mouseY <=500) {
    // println("yes sir!");
    stage =4;
  } 
  //shop button
  if (mouseX >=100 && mouseX <=200 && mouseY>=400 && mouseY <=473) {
    stage =4;
  } 
  //each of the shop items
  if (stage ==4) {
    //snowCone
    if ( mouseX>=200 && mouseX <=455 && mouseY >=260 && mouseY <=320 && (bank >=50 || snowConeCounter >0)) {
      if (snowConeCounter >0) {
        remove50Coins = false;
      } else {
        remove50Coins = true;
      }
      isSnowCone = true;

      isFlower = false;
      isVerbena = false;
      isSunset =false;
      for (int i =0; i < equipedSkins.length; i++) {
        equipedSkins[i]  = false;
      }

      equipedSkins[1] = true;


      if (remove50Coins== true) {
        bank -=50;
        changeFillSnowCone = true;
        remove50Coins = false;
      }
      snowConeCounter +=1;
      if (!playingAsGuest) {
        result.setInt("SnowConeCounter", snowConeCounter);
        saveTable(table, "data/new1.csv");
      }
      //Sunset
    } else if (mouseX>=200 && mouseX <=455 && mouseY >=160 && mouseY <=235 && (bank >=50|| sunsetCounter >0)) {
      if (sunsetCounter> 0) {
        remove50Coins = false;
      } else { 
        remove50Coins = true;
      }




      isSunset = true;
      isSnowCone = false;
      isFlower = false;
      isVerbena = false;

      for (int i =0; i < equipedSkins.length; i++) {
        equipedSkins[i]  = false;
      }

      equipedSkins[0] = true;

      if (remove50Coins) {
        bank -=50;
        changeFillisSunset = true;
        remove50Coins = false;
      }
      sunsetCounter +=1;
      if (!playingAsGuest) {
        result.setInt("SunsetCounter", sunsetCounter);
        saveTable(table, "data/new1.csv");
      }
    } else if ( mouseX>=450 && mouseX <=705 && mouseY >=160 && mouseY <=235 && (bank >=50 || verbenaCounter >0)) {
      if (verbenaCounter >0) {
        remove50Coins = false;
      } else {
        remove50Coins = true;
      }

      allowPass = true;
      isVerbena = true;
      isSnowCone = false;
      isFlower = false;
      isSunset = false;
      for (int i =0; i < equipedSkins.length; i++) {
        equipedSkins[i]  = false;
      }

      equipedSkins[2] = true;

      if (remove50Coins== true) {
        bank -=50;
        changeFillVerbena = true;
        remove50Coins = false;
      }
      verbenaCounter +=1;
      if (!playingAsGuest) {
        result.setInt("VerbenaCounter", verbenaCounter);
        saveTable(table, "data/new1.csv");
      }
    } else  if (mouseX>=450 && mouseX <=705 && mouseY >=260 && mouseY <=320 && (bank >=50|| flowerBoarderCounter >0)) {
      if (flowerBoarderCounter>0) {
        remove50Coins = false;
      } else {
        remove50Coins = true;
      }
      isFlower = true;
      isSnowCone = false;
      isSunset = false;
      isVerbena = false;
      for (int i =0; i < equipedSkins.length; i++) {
        equipedSkins[i]  = false;
      }

      equipedSkins[3] = true;

      if (remove50Coins== true) {
        bank -=50;
        changeFillFlower = true;
        remove50Coins = false;
      }
      flowerBoarderCounter +=1;

      if (!playingAsGuest) {
        result.setInt("FlowerBoarderCounter", flowerBoarderCounter);
        saveTable(table, "data/new1.csv");
      }
    } else if ( mouseX>=720 && mouseX <=960 && mouseY >=160 && mouseY <=235 && (bank >=100|| nightSkiingCounter >0)) {
      if (nightSkiingCounter >0) {
        remove50Coins = false;
      } else {
        remove50Coins = true;
      }
      isNightSkiing = true;
      for (int i =0; i < equipedBackground.length; i++) {
        equipedBackground[i]  = false;
      }

      equipedBackground[0] = true;

      isSunsetSkiing = false;
      if (remove50Coins== true) {
        bank -=100;
        changeFillNightSkiing = true;
        remove50Coins = false;
      }
      nightSkiingCounter +=1;
      if (!playingAsGuest) {
        result.setInt("NightSkiingCounter", nightSkiingCounter);
        saveTable(table, "data/new1.csv");
      }
    } else if ( mouseX>=720 && mouseX <=960 && mouseY >=260 && mouseY <=320 && (bank >=100|| sunsetSkiingCounter >0)) {
      if (sunsetSkiingCounter >0) {
        remove50Coins = false;
      } else { 
        remove50Coins = true;
      }
      for (int i =0; i < equipedBackground.length; i++) {
        equipedBackground[i]  = false;
      }

      equipedBackground[1] = true;


      isSunsetSkiing = true;
      isNightSkiing = false;
      if (remove50Coins== true) {
        bank -=100;
        changeFillSunsetSkiing = true;
        remove50Coins = false;
      }
      sunsetSkiingCounter +=1;
      if (!playingAsGuest) {
        result.setInt("SunsetSkiingCounter", sunsetSkiingCounter);
        saveTable(table, "data/new1.csv");
      }
    }
  }
}
