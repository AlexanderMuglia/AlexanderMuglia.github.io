/*
 * Alexander Muglia, Miguel Sulek
 * Black Diamond
 * BlackDiamond.java
 * October 17 2019 - January 17, 2020
 * ICS4U
 * A snowboarding game. Collect the coins and don't hit the obstacles!
 * Audience: high school students
 */

import processing.sound.*;
import controlP5.*;

ControlP5 cp5;
//username and password for accounts
String textValue = ""; 
String password;
//database
Table table;

int stageMover = 0;  //Moves the stage each frame
int numCoins = -1;  //number of coins that the player currently has
int tutMillis = 0;  // starts a clock at the start of the tutorial to control flow
int score = -1;  //score at the end of a game 
int brightness = 0; //game brightness
int coinsCollected; //for shop
int jumpsCompleted; //num jumps over rocks for challenges
int numPlays = 0;  //counts how many times the user starts the game
int prevScore;  //score in the previous round to find highscore
float rndStage = 300;  //sets the stage height for the game
float mX, mY;  //variables for the x and y position of the mouse
PImage background, menu;  //background images for the game and menu
PImage shopBackground, sign, stackOfCoins, biggerStackOfCoins, evenBiggerStackOfCoins, lock, biggerLock, evenBiggerLock, shopSign1, coin, Colour1Boarder1, Colour1Boarder2, Colour2Boarder1;
PImage boarderOnGround, boarderInAir, snowConeInAir, snowConeOnGround, sunsetInAir, sunsetOnGround, verbenaInAir, verbenaOnGround, flowerOnGround, flowerInAir;
PImage nightSkiing;
PImage bigCoin; 
PImage sunset, sunsetReverse;

int sunsetCounter, snowConeCounter, verbenaCounter, flowerBoarderCounter, nightSkiingCounter, sunsetSkiingCounter; // keeps track if item is bought or not 

float trans1 = 0;  //transparency of play button on main menu
float trans = 0;  //transparency of tutorial button on main menu
int stage;  //x position of the stage for drawing purposes
int x = 0; //integer to move game background each frame
int shopTextX = 500; //position of text in shop
float counter = 0; //controls what song is being played 
boolean overrideUpdateL = false; //  allows for player control left
boolean overrideUpdateR = false; //  allows for player control right
boolean pause = false; //allows for pausing
//variables for powerups and challenges
boolean isBonus1Added= true; 
boolean  isBonus2Added  = true;
boolean  isBonus3Added= true;
boolean isBonus4Added =true;
boolean isBonus5Added =true;
boolean isBonus6Added =true;
boolean shoudlAdd;
boolean isAhcv1Done;
boolean isAhcv2Done;
boolean isAhcv3Done;
boolean isAhcv4Done;
boolean isVisible1 = true; //To display lock or not in shop screen
boolean isVisible2= true;
boolean isVisible3= true;
boolean isVisible4= true;
boolean isVisible5= true;
boolean isVisible6= true;
boolean isSnowCone, isSunset, isVerbena, isFlower, isNightSkiing, isSunsetSkiing;
boolean changeFillSnowCone, changeFillisSunset, changeFillVerbena, changeFillFlower, changeFillNightSkiing, changeFillSunsetSkiing; 
boolean remove50Coins;
boolean allowPass;
int hitCounter;
boolean returningPlayer = false; //controls database actions
TableRow result; // holds a value for the current player
TableRow sameNames;
boolean canCollide = true;  //true when character is vulnerable, false when invincible 
int jumpsLeft = 2; // jump counter
int rockJumps;//counter for number of times user jumped over rocks
float rockAchv1, scoreAchv1, rockAchv2, scoreAchv2, rockAchv3, scoreAchv3;
int bank=0;


boolean[] equipedSkins = new boolean[4];
boolean[] equipedBackground = new boolean[2];

int myColor = color(130, 130, 255); 
boolean makeAccount = false;
boolean playingAsGuest = false;

/**
* creates the main stage for the game
* pre: none
* post: The stage / hill hass been created
* @param x
* @param mover
* @param rnd
*/
float stageFunction(float x, int mover, float rnd) {
  map(x, 0, width, 0, 5);
  float y;
  y = 40*sin(radians(-x - mover)) + (0.3 * x) + rnd;
  return y;
}

/**
* determines the change in velocity based on the stage
* pre: none
* post: The slope of the stage is returned
* @param x
* @param i
*/
float derSF(float x, int i) {
  map(x, 0, width, 0, 5);
  float y;
  y = (stageFunction(x, i, rndStage) - stageFunction((x-0.001), i, rndStage))/ 0.001;
  return y;
}

/**
* draws the main stage for the game
* pre: stageFunction has greated the stage
* post: The stage / hill has been drawn on the screen
* @param lnHeight
*/
void makeLine(float lnHeight) {
  float num;
  for ( int i = 0; i < width; i++) {
    num = random(200, 255);
    fill(num, num, num + (255-num));
    noStroke();
    ellipse(i, stageFunction(i, stageMover, lnHeight), 5, 5);
  }
}

/**
* fills the area under the stage curve
* pre: the stage has been created
* post: the area under the curve of the stage is filled 
*/
void fillStage() {
  fill(230, 230, 255);
  for (int i = 0; i <width; i++) {
    rect(i, stageFunction(i, stageMover, rndStage), 1, height);
  }
}

/**
* handes any events related to snowflakes
* pre: the snowflakes have been instantiatied 
* post: the snowflakes are drawn, move, and may respawn
*/
void letItSnow() {
  for (int i = 0; i< snowflakes.length; i++) {
    snowflakes[i].show();
    snowflakes[i].update();
    snowflakes[i].respawn();
  }
}

/**
* handes any events related to coins
* pre: the coins have been instantiatied 
* post: the coins are drawn, move, and collision is checked
*/
void coinTime() {
  for (int i = 0; i < coins.length; i++) {
    coins[i].show();
    coins[i].update();
    coins[i].collected(snowboarder.location.x, snowboarder.location.y);
  }
}

/**
* handles any events related to the snowboarder
* pre: the snowboarder has been instantiatied 
* post: the snowboarder is drawn, moves, and collision with the stage is checked
*/
void snowboarderUpdate() {
  snowboarder.show(); 
  snowboarder.update(); 
  snowboarder.checkStage();
}

/**
* used to reset all elements which need to be reset for another run
* pre: none 
* post: the appropriate variables are reset
*/
void reset() {
  for (int i = 0; i < 50; i++) {
    coins[i] = new Coin(i);
  }

  for (int i = 0; i < 30; i++) {
    barriers[i] = new Barrier(i);
  }

  for (int i = 0; i < 150; i++) {        // setup the snow
    snowflakes[i] = new Snowflake();
  }
  stageMover = 0;
  hitCounter = 0;
  if(isVerbena){
    allowPass = true;
  }else{
    allowPass = false;
  }
  snowboarder.location.x = width/5;
  snowboarder.location.y = stageFunction(width/5, stageMover, rndStage);
  snowball.x = 10000000;
  star.location.add(10000,-100000);
  
  if(drumLoop.isPlaying()){
    drumLoop.stop();
  }
}

/**
* statements are called when the app closes
* pre: the app is closed
* post: the database is saved 
*/
void stop(){
  if(!playingAsGuest){
    saveTable(table, "data/new1.csv");
  }
}

/**
* handes any events related to barriers
* pre: the barriers have been instantiatied 
* post: the barriers are drawn, move, and hit detection is checked
*/
void updateBarriers() {
  for (int i = 0; i < barriers.length; i++) {
    barriers[i].show();
    barriers[i].update();
    barriers[i].hit(snowboarder.location.x, snowboarder.location.y);
  }
}

/**
* Controls events when the "Go!" button is clicked 
* pre: the player has entered their name in the text field
* post: the name entered is saved to a variable
* @param theEvent
*/
public void controlEvent(ControlEvent theEvent){
  println(theEvent.getController().getName());
  
  if(theEvent.getController().getName() == "Go!" && millis() > 9000){
   textValue = cp5.get(Textfield.class, "PlayerName").getText();
   password = cp5.get(Textfield.class, "Password").getText();
   cp5.get(Textfield.class, "Password").clear();
   cp5.get(Textfield.class, "PlayerName").clear();
    
  }
  
  if(theEvent.getController().getName() == "Continue as Guest" && millis() > 9000){
    stage = 1;
    playingAsGuest = true;
    result = table.findRow("Guest", "name");
  }
  
  if(theEvent.getController().getName() == "Make New Account" && millis() > 9000){
    println("WE ARE MAKING ACC");
    makeAccount = true;
    textValue = "";
    password = "";
    stage = 0;
    myColor = color(130,255,130);
  }
}

/**
* handes any events related to the star
* pre: the star has been instantiatied 
* post: the star is drawn, moves, and hit detection is checked
*/
void starMethods(){
  star.update();
  star.show();
  if(!isSunset){
    star.respawn((int)random(3600));
  }else if(isSunset){
    star.respawn((int)random(1800));
  }
  star.collision();
}

/**
* handes any events related to the snowball
* pre: the snowball has been instantiatied 
* post: the snowball is drawn, moves, and hit detection is checked
*/
void snowballMethods(){
    snowball.show();
    snowball.update();
    snowball.collision();
}

Snowboarder snowboarder = new Snowboarder(); 
Snowball snowball = new Snowball();
Star star = new Star();
Barrier[] barriers = new Barrier[30];

SoundFile coinSound;
SoundFile poundCake, drumLoop;
SoundFile starBounce, starGrab;
SoundFile buzz;
PImage img; 
PImage img2; 
PImage warning;
PImage coinImg; 
PImage barrier;
PImage starImg;
PImage brokenRocks;
Snowflake[] snowflakes = new Snowflake[150]; 
Coin[] coins = new Coin[50]; 

/**
* sets up all elements needed when starting the game
* pre: all variables needed are declared
* post: the application is set up and ready to run
*/
void setup() {
  table = loadTable("data/new1.csv", "header");
  saveTable(table, "data/new1.csv");
  
  cp5 = new ControlP5(this);
  PFont font = createFont("arial", 20);
  
  //create new button called Go!
  cp5.addButton("Go!")
     //.setBroadcast(false)
     //.setValue(0)
     .setPosition(width/2-200, height/2 + 100)
     .setSize(400,100)
     .setFont(font)
     ;
  //create new button called Continue as Guest
  cp5.addButton("Continue as Guest")
     //.setBroadcast(false)
     //.setValue(0)
     .setPosition(width/2-200, height/2 + 225)
     .setSize(400,50)
     .setFont(font)
     ;
     
  cp5.addButton("Make New Account")
     //.setBroadcast(false)
     //.setValue(0)
     .setPosition(width/2-200, height/2 + 300)
     .setSize(400,50)
     .setFont(font)
     ;
     
  //create text field for player name 
  cp5.addTextfield("PlayerName")
     .setPosition(width/2 - 100, height/2 - 100)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     //.setColor(color(myColor))
     ;
     
    cp5.addTextfield("Password")
     .setPosition(width/2 - 100, height/2 - 20)
     .setSize(200,40)
     .setFont(font)
     .setFocus(false)
     .setPasswordMode(true)
     //.setColor(color(myColor))
     ;
  
  stage = 0; 
  size(1000, 800, P2D); 
  boarderOnGround = loadImage("snowboarder2.png"); 
  boarderInAir = loadImage("Snowboarder.png"); 



  snowConeInAir = loadImage("snowConeInAir.png");
  snowConeOnGround = loadImage("snowConeOnGround.PNG");

  sunsetInAir = loadImage("sunsetInAir.PNG");
  sunsetOnGround = loadImage("sunsetOnGround.PNG");

  verbenaInAir =loadImage("verbenaInAir.PNG");
  verbenaOnGround =loadImage("verbenaOnGround.PNG");

  flowerOnGround = loadImage("flowerOnGround.PNG");
  flowerInAir = loadImage("flowerInAir.PNG");

  //img2 = loadImage("snowboarder2.png"); 
  //img = loadImage("Snowboarder.png"); 
  warning = loadImage("warning.png");
  starImg = loadImage("star.png");
  coinImg = loadImage("coin.png"); 
  bigCoin =loadImage("coin.png"); 
  bigCoin.resize(75, 75);
  stackOfCoins = loadImage("stackOfCoins.png");
  biggerStackOfCoins = loadImage("stackOfCoins.png");
  biggerStackOfCoins.resize(60, 60);
  evenBiggerStackOfCoins = loadImage("stackOfCoins.png");
  evenBiggerStackOfCoins.resize(70, 70);
  lock = loadImage("lock.png");
  biggerLock = loadImage("lock.png");
  biggerLock.resize(105, 105);
  lock.resize(95, 95);
  evenBiggerLock = loadImage("lock.png");
  evenBiggerLock.resize(130, 118);
  shopSign1 = loadImage("shopSign1.png");
  shopSign1.resize(270, 230);
  stackOfCoins.resize(50, 50);

  barrier = loadImage("rock.png");
  brokenRocks = loadImage("brokenRocks.png");
  makeLine(rndStage); 
  background = loadImage("background.jpg"); 
  background.resize(1000, 800); 
  sunset = loadImage("sunset.jpg"); 
  sunsetReverse = loadImage("sunsetReversed.jpg");


  nightSkiing = loadImage("nightSkiing.jpg");
  background.resize(1000, 800); 
  nightSkiing.resize(1000, 800); 

  menu = loadImage("main1.jpg");
  
  menu.resize(700, 564);
  coin = loadImage("coin.png");
  coin.resize(30, 30);
  
  sign = loadImage("sign.png");
  sign.resize(100, 100);
  shopBackground = loadImage("shopScreen.jpg");
  shopBackground.resize(1200, 534 );

  rockAchv1 = int(random(5, 13));
  scoreAchv1 = int(random(10, 20));

  rockAchv2 = int(random(15, 30));
  scoreAchv2 = int(random(22, 50));

  rockAchv3 = int(random(35, 50));
  scoreAchv3 = int(random(60, 120));

  buzz = new SoundFile(this, "buzz.wav");
  coinSound = new SoundFile(this, "coin1.wav");
  poundCake = new SoundFile(this, "poundCake.mp3");
  drumLoop = new SoundFile(this, "drumLoop.wav");
  starBounce = new SoundFile(this, "starBounce.wav");
  starGrab = new SoundFile(this, "starGrab.wav");
  buzz.amp(0.5);

  for (int i = 0; i < 50; i++) {          // set up coins 
    coins[i] = new Coin(i);
  }

  for (int i = 0; i < 30; i++) {         //set up barriers
    barriers[i] = new Barrier(i);
  }

  for (int i = 0; i < 100; i++) {        // set up the snow
    snowflakes[i] = new Snowflake();
  }
  poundCake.amp(0.3);
  poundCake.play();
}

/**
* executes all statements each frame
* pre: setup() has been executed 
* post: a frame is drawn on the screen
*/
void draw() {
  if(stage == 0){          //in intro
    background(myColor);
    
    if(textValue != "" && !makeAccount){   //after name is submitted, not trying to make acc
      if(textValue != ""){
        String[] nameCol = table.getStringColumn("name");
        String[] passCol = table.getStringColumn("password");
        for(int i = 0; i < nameCol.length; i++){
          if(nameCol[i].equalsIgnoreCase(textValue) && passCol[i].equalsIgnoreCase(password)){
            returningPlayer = true;
            result = table.getRow(i);
            break;
          }else{
            returningPlayer = false;
          }
        }
      }
    }else if(makeAccount){
      if(textValue != ""){
        TableRow newRow = table.addRow();
        newRow.setString("name", textValue);
        newRow.setString("password", password);
        newRow.setInt("bank", 0);
        newRow.setInt("highscore", 0);
        newRow.setInt("SunsetCounter", 0);
        newRow.setInt("SnowConeCounter", 0);
        newRow.setInt("VerbenaCounter", 0);
        newRow.setInt("FlowerBoarderCounter", 0);
        newRow.setInt("NightSkiingCounter", 0);
        newRow.setInt("SunsetSkiingCounter", 0);
  
        saveTable(table, "data/new1.csv");
        makeAccount = false;
      }
    }
    
      if(returningPlayer && textValue != ""){ //if in database
        //access all variables needed, set them in the game
        bank = result.getInt("bank");
        score = result.getInt("highscore");
        sunsetCounter = result.getInt("SunsetCounter");
        snowConeCounter = result.getInt("SnowConeCounter");
        verbenaCounter = result.getInt("VerbenaCounter");
        flowerBoarderCounter = result.getInt("FlowerBoarderCounter");
        nightSkiingCounter = result.getInt("NightSkiingCounter");
        sunsetSkiingCounter = result.getInt("SunsetSkiingCounter");
        
        //start the game
        stage = 1;
      }else if (!returningPlayer && textValue != ""){            //name isn't in database, so ask for next step
        if(!makeAccount){
          background(myColor);
          myColor = lerpColor(myColor, color(255, 100, 100), 0.15);
          push();
          textSize(30);
          text("That account was not found.", width/2 - 200, height/ 2 - 250);
          pop();
        }
      }
    }
  if (stage == 1) {      //main menu
    reset();
    println(verbenaCounter);
    //hide cp5 stuff
    cp5.getController("Go!").hide();
    cp5.getController("PlayerName").hide();
    cp5.getController("Password").hide();
    cp5.getController("Continue as Guest").hide();
    cp5.getController("Make New Account").hide();
    numCoins = 0;
    rockJumps =0;

    surface.setSize(700, 564);

    image(menu, 0, 0); 

    fill (0, 0, 255, trans); 
    rect(150, 100, 400, 100); 
    textSize(50); 
    fill(255); 
    text("Play", width/2-50, 165); 

    fill (0, 0, 255, trans1); 
    rect(150, 240, 400, 100);
    textSize(50); 
    fill(255); 
    text("Instructions", width/2-150, 305);
    image(sign, 100, 400);
    textSize(30);
    text("Shop ", 113, 450);
    noFill();
    rect(140, 400, 22, 100);//sign vertical

    rect(100, 400, 100, 73);//sign horizontal
    if (score >= 0) {
      textSize(30);
      text("Highscore: " + score, 40, height-50);
      text("Your Score: " + prevScore, width-250, height-50);
    }


    if (score >= 0) {
      textSize(30);
      text("Highscore: " + score, 40, height-50);
      text("Your Score: " + prevScore, width-250, height-50);
      text("Your Bank: " + bank, 300, 50);
    }
    
    //play button 
    if (mouseX>= 150 && mouseX<=550 && mouseY>= 240 && mouseY <= 340) {
      while (trans1<255) {
        trans1+=1;
      }
    } else {
      while (trans1>0) {
        trans1 -= 1;
      }
    }
    //tutorial button
    if(mouseX>= 150 && mouseX<=550 && mouseY>= 100 && mouseY <= 200){
      while (trans<255) {
        trans+=1;
      }
    } else {
      while (trans>0) {
        trans -= 1;
      }
    }
    
    if(!poundCake.isPlaying()){
      poundCake.play();
    }
    
  } else if (stage == 2) {    //game screen
    poundCake.stop(); 
    if(!drumLoop.isPlaying()){
      drumLoop.play();
    }
    
    
    surface.setSize(1000, 800); 
    if (isSunsetSkiing ==true) {//creats moving background
      image(sunset, x-width, 0);
      image(sunsetReverse, x, 0);
      image(sunset, x+width, 0);
      x -=1; 

      if (x<=-width) {  
        x=width;
      }
    } else if (isNightSkiing) {
      image(nightSkiing, x-100, 0); 
      image(nightSkiing, x+background.width, 0); 
      x -=1; 
      if (x< -background.width) {
        x=0;
      }
    } else {
      image(background, x, 0); 
      image(background, x+background.width, 0); 
      x -=1; 
      if (x< -background.width) {
        x=0;
      }
    }

    push();
    fill(255,255,0);
    textSize(36);
    text(numCoins, 100, 100);
    pop();
    
//play and pause button
    fill(255, 0, 0); 
    triangle(950, 75, 950, 20, 990, 45); 
    rect(930, 20, 10, 55); 
    rect(910, 20, 10, 55); 

    stageMover += 3; //moves the sine function right 3 pixels each frame
    makeLine(rndStage); 
    letItSnow();  
    fillStage(); 
    coinTime(); 
    updateBarriers();
    snowboarderUpdate();
    starMethods();
    snowballMethods();
    
    fill(0, 0, 0, brightness);
    rect(0, 0, 1000, 800);
    
    if(!canCollide && star.x < 500){
      frameRate(100);
    }else if(!canCollide){
      frameRate(60);
      canCollide = true;
    }
    
    text(numCoins, 200, 100);
    if (numCoins > score) {
      score = numCoins;
      result.setInt("highscore", score);
      saveTable(table, "data/new1.csv");
    }
    
    if (snowball.x > width && frameCount % 1000 == 0 && frameCount > 100 ){
      snowball.respawn();
    }

    
  } else if (stage == 3) {      //tutorial
    poundCake.stop(); 
    surface.setSize(1000, 800); 
    image(background, x, 0); 
    image(background, x+background.width, 0); 

    if (x< -background.width) {
      x=0;
    }
    
    stageMover += 3;
    
    fill(255, 0, 0); 
    triangle(950, 75, 950, 20, 990, 45); 

    rect(930, 20, 10, 55); 
    rect(910, 20, 10, 55); 
 
    makeLine(rndStage); 
    letItSnow();  
    fillStage(); 
    snowboarderUpdate();
    
    if(millis()-tutMillis < 3000){
      fill(0);
      textSize(30);
      text("Welcome to the tutorial" , 100, 100);
    }else if(millis() - tutMillis < 6000){
      fill(0);
      textSize(30);
      text("Use A and D to control your speed" , 100, 100);
    }else if(millis()-tutMillis < 9000){
      fill(0);
      textSize(30);
      text("Press SPACE to jump and double jump" , 100, 100);
    }else if(millis() - tutMillis < 12000){
      fill(0);
      textSize(30);
      text("Avoid obstacles and collect the coins!" , 100, 100);
    }else {
      fill(0);
      textSize(30);
      text("Now you're ready! Press the back button to exit the tutorial." , 50, 100);
      
      push();
      fill(255,0,0);
      stroke(0);
      strokeWeight(1);
      rect(width-150, 150, 90, 40);
      
      fill(0); 
      text("Back", width-140, 180);
      pop();
    }
  }else if(stage == 4){
    surface.setSize(1200, 534);//resizes the screen for optimal gameplay size
    drawImages();
    writeTexts();
    drawRects();

    //println(bank);

    fill(255);
    textSize(50);
    text(bank, shopTextX, 100);//displays how much coins the user has

    if (bank<0) {//keeps coins from getting negative
      bank =0;
    }
    
    //if the acheivement has not been completed then the lock is visible, else the lock is invisible
    if (isVisible1) {
      image(lock, 220, 385);
    }
    if (isVisible2) {
      image(lock, 220, 453);
    }
    if (isVisible3) {
      image(biggerLock, 613, 365);
    }
    if (isVisible4) {
      image(biggerLock, 613, 445);
    }
    if (isVisible5) {
      image(evenBiggerLock, 1020, 352);
    }
    if (isVisible6) {
      image(evenBiggerLock, 1020, 437);
    }

//check if the user has completed an acheivement and execute code if so


    if (coinsCollected>=scoreAchv1 ) {
      if (isBonus1Added) {
        bank +=10;
        isBonus1Added = false;
      }
      isVisible1 = false;
      fill(255, 0, 0);
      rect(10, 415, 220, 50);
      push();
      textSize(25);
      fill(255);
      text("Collect " + (int)scoreAchv1+ " coins!", 20, 450);   
      text("+10", 294, 442);
      pop();
      fill(255);
      textSize(23);

      isAhcv1Done = true;
    }

    //println(jumpsCompleted,rockAchv1);
    if (jumpsCompleted>=rockAchv1) {

      isVisible2 = false;
      fill(255, 0, 0);
      rect(10, 480, 220, 50);

      push();
      textSize(25);
      fill(255);
      text("Clear "+ (int)rockAchv1 +" rocks!", 20, 515);
      text("+10", 294, 500);

      pop();
      if (isBonus2Added) {
        bank +=10;
        isBonus2Added = false;
      }
      isAhcv2Done = true;
    }
    if (isAhcv1Done ==true && isAhcv2Done == true) {


      if (coinsCollected>= scoreAchv2) {
        fill(255, 0, 0);
        rect(400, 415, 220, 50);
        push();
        textSize(25);
        fill(255);
        text("Collect " + (int)scoreAchv2+ " coins!", 423, 450);
        text("+25", 693, 422);

        pop();
        fill(255);
        textSize(23);
        //  text("+10 coins! ", 224, 442);
        if (isBonus3Added) {
          bank +=25;
          isBonus3Added = false;
          isVisible3 = false;
        }
      }
      isAhcv3Done=true;
    }


    if (isAhcv1Done ==true && isAhcv2Done == true) {
      if (jumpsCompleted>=rockAchv2) {
        fill(255, 0, 0);
        rect(400, 480, 220, 50);
        push();
        textSize(25);
        fill(255);
        text("Clear " + (int)rockAchv2+ " rock!", 423, 515);
        text("+25", 693, 500);
        pop();
        fill(255);
        textSize(23);
        //  text("+10 coins! ", 224, 442);
        if (isBonus4Added) {
          bank +=25;
          isBonus4Added = false;
          isVisible4 = false;
        }
      }
      isAhcv4Done =true;
    }


    if (isAhcv3Done ==true && isAhcv4Done == true) {


      if (coinsCollected>=scoreAchv3) {
        fill(255, 0, 0);
        rect(810, 415, 220, 50);
        push();
        textSize(25);
        fill(255);
        text("Collect " + (int)scoreAchv3+ " coins!", 816, 450);
        text("+50", 1120, 422);

        pop();
        fill(255);
        textSize(23);
        //  text("+10 coins! ", 224, 442);
        if (isBonus5Added) {
          bank +=50;
          isBonus5Added = false;
          isVisible5 = false;
        }
      }
    }


    if (isAhcv3Done ==true && isAhcv4Done == true) {


      if (jumpsCompleted>=rockAchv3) {
        fill(255, 0, 0);
        rect(810, 480, 220, 50);
        push();
        textSize(25);
        fill(255);
        text("Collect " + (int)rockAchv3+ " coins!", 816, 515);
        text("+50", 1120, 500);
        pop();
        fill(255);
        textSize(23);
        //  text("+10 coins! ", 224, 442);
        if (isBonus6Added) {
          bank +=50;
          isBonus6Added = false;
          isVisible6 = false;
        }
      }
    }
  }
}



/**
* draws images for the shop
* pre: none
* post: The images are drawn on screen
*/

void drawImages() {
  image(shopBackground, 0, 0);

  image(stackOfCoins, 240, 411);
  image(stackOfCoins, 240, 479);


  image(biggerStackOfCoins, 633, 392);
  image(biggerStackOfCoins, 633, 469);

  image(evenBiggerStackOfCoins, 1044, 380);
  image(evenBiggerStackOfCoins, 1044, 465);
  //Sunset
  image(shopSign1, 200, 100);
  image(coin, 322, 200);
  //SnowCone
  image(shopSign1, 200, 200);
  image(coin, 322, 300);
  //verbena
  image(shopSign1, 450, 100);
  image(coin, 572, 200);
  //flowerBoarder
  image(shopSign1, 450, 200);
  image(coin, 572, 300);
  //NightSkiing
  image(shopSign1, 700, 100);
  image(coin, 837, 200);
  //SunsetSkiing
  image(shopSign1, 700, 200);
  image(coin, 837, 300);

  //image(bigCoin, shopTextX+20, 40);
  if (bank>99) {
    image(bigCoin, shopTextX+80, 40);
  } else if (bank >9 && bank < 99) {
    image(bigCoin, shopTextX+50, 40);
  } else {
    image(bigCoin, shopTextX+20, 40);
  }
}
/**
*writes text and colours it for shop screen
* pre: none
* post: The texts are drawn on screen with proper colour
*/
void writeTexts() {
  //Sunset
  push();
  textSize(25);
  if (changeFillisSunset == false && sunsetCounter ==0) {
    fill(255);
  } else {
    fill(167);
  }
  text("Sunset", 270, 200);
  text("50", 295, 223);
  pop();

  //SnowCone
  push();
  textSize(25);
  if (changeFillSnowCone ==false && snowConeCounter ==0) {
    fill(255);
  } else {
    fill(167);
  }
  text("Snow Cone", 270, 300);
  text("50", 295, 323);
  pop();

  //Verbena
  push();
  textSize(25);
  if (changeFillVerbena ==false && verbenaCounter ==0) {
    fill(255);
  } else {
    fill(167);
  }
  text("Verbena", 520, 200);
  text("50", 545, 223);
  pop();

  //flower
  push();
  textSize(25);
  if (changeFillFlower ==false && flowerBoarderCounter ==0) {
    fill(255);
  } else {
    fill(167);
  }
  text("Flower Boarder", 487, 300);
  text("50", 545, 323);
  pop();

  //NightSkiing
  push();
  textSize(25);
  if (changeFillNightSkiing ==false && nightSkiingCounter ==0) {
    fill(255);
  } else {
    fill(167);
  }
  text("Night Skiing", 770, 200);
  text("100", 795, 223);
  pop();

  //Sunset Skiing
  push();
  textSize(25);
  if (changeFillSunsetSkiing ==false && sunsetSkiingCounter ==0) {
    fill(255);
  } else {
    fill(167);
  }
  text("Sunset Skiing", 750, 300);
  text("100", 795, 323);
  pop();

  push();
  textSize(25);
  fill(255);//first
  text("Collect " + (int)scoreAchv1+ " coins!", 20, 450);
  text("Clear "+ (int)rockAchv1 +" rocks!", 20, 515);
  //second
  text("Collect " + (int)scoreAchv2+ " coins!", 423, 450);
  text("Clear "+ (int)rockAchv2 +" rocks!", 423, 515);
  //third
  text("Collect " + (int)scoreAchv3+ " coins!", 816, 450);
  text("Clear "+ (int)rockAchv3 +" rocks!", 816, 515);
  pop();
}

/**
* draws rectanglesand necessary tests for the shop achievements
* pre: none
* post: The rects are drawn on screen
*/
void drawRects() {
  push();

  stroke(255, 0, 0);
  strokeWeight(6);
  noFill();
  //first
  rect(10, 415, 220, 50);
  rect(10, 480, 220, 50);
  //second
  rect(400, 415, 220, 50);
  rect(400, 480, 220, 50);
  //third
  rect(810, 415, 220, 50);
  rect(810, 480, 220, 50);

  pop();

  push();
  noFill();
  stroke(255);
  strokeWeight(6);
  pop();
  //rect(970, 75, 220, 300);
  push();
  textSize(31);
  fill(255);
  text("Skin Eqipped:", 970, 130);
  text("Background:", 970, 250);
  textSize(15);
  text("press 'r' to reset", 970, 340);
  pop();
  for (int i =0; i < equipedSkins.length; i++) {//displays which skins is equipped

    textSize(30);
    if ( equipedSkins[0] == true) {
      fill(255);
      text("Sunset", 970, 170);
    } else if ( equipedSkins[1] == true) {
      fill(255);
      text("Snow Cone", 970, 170);
    } else if ( equipedSkins[2] == true) {
      fill(255);
      text("Verbena", 970, 170);
    } else if ( equipedSkins[3] == true) {
      fill(255);
      text("Flower Boarder", 970, 170);
    } else {
      fill(255);
      text("Default", 970, 170);
    }
  }

  for (int i =0; i < equipedSkins.length; i++) { //diplays which background is equipped

    if ( equipedBackground[0] == true) {
      push();
      fill(0);

      textSize(30);
      text("Night Skiing", 970, 300);
      pop();
    } else if ( equipedBackground[1] == true) {
      fill(255, 165, 0);
      push();
      textSize(30);
      text("Sunset Skiing", 970, 300); 
      pop();
    } else {
      fill(255);
      text("Default", 970, 300);
    }
  }
}
