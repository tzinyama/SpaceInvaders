/*
Space Invaders
by Tino Zinyama
*/
enum GameState{
  PREGAME,
  INGAME,
  PAUSED,
  LEVELUP,
  GAMEOVER,
  BOSSBATTLE
}

Rocket player;
WeaponManager weaponManager;
EnemyManager  enemyManager;
BossManager bossMan;
boolean playerWon = false;

GameState gameState;
int level;
int score;

//Number of lasers and emps player has. Are globals coz WeaponManger is reset
//every level and these need to carry over to new levels
int numLasers;
int numEmps;
//Number of enemies killes before you get bullets for special guns
int laserUpgrade;
int empUpgrade;

ParticleManager backParticles1;
ParticleManager backParticles2;
ParticleManager backParticles3;

void setup(){
  size(900, 600);
  smooth();
  
  player = new Rocket();
  bossMan = new BossManager();
  enemyManager = new EnemyManager();
  weaponManager = new WeaponManager(player);
  gameState = GameState.PREGAME;
  level = 1;
  score = 0;
  
  numLasers = 0;
  numEmps = 0;
  laserUpgrade = 0;
  empUpgrade = 0;
  
  //add these to setupLevels()
  backParticles1 = new ParticleManager(100, -100, 10);
  backParticles2 = new ParticleManager(450, -100, 10);
  backParticles3 = new ParticleManager(800, -100, 10);
  
  setupLevel();  
}

void draw(){
  background(0);
  manageGame();
  
}

//************************************
//Method to manage gameplay
void manageGame(){
  
  //WELCOME SCREEN
  if (gameState == GameState.PREGAME){ //
    noStroke();
    ellipseMode(CENTER);
    fill(#E9FB00);
    ellipse(450, 300, 600, 300);
    fill(#8106A9);
    ellipse(450, 300, 550, 250);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("SPACE INVADERS", 450, 250);
    textSize(25);
    text("Click to Start", 450, 300);
    textSize(15);
    text("Use Arrow Keys to Move", 450, 350);
    text("Press TAB to Shoot", 450, 375);
    text("Press Q to Switch Guns", 450, 400);
  
  }
  //INGAME
  else if(gameState == GameState.INGAME){
    
    backParticles1.run();
    backParticles2.run();
    backParticles3.run();
    
    player.move();
    player.collide(enemyManager.bullets);
    player.display();
    
    weaponManager.run();
    enemyManager.run();
    showScore();
    
    //check for guns upgrade
    if (laserUpgrade == 5){
      numLasers++;
      laserUpgrade = 0;
    }
    if (empUpgrade == 10){
      numEmps++;
      empUpgrade = 0;
    }
    
    //Check for level up condition
    if (enemyManager.enemies.size() == 0){
      level++; //level up
      gameState = GameState.LEVELUP; //Level Up
    }
    
    //Check for game over condition
    if(player.lives == 0){
      gameState = GameState.GAMEOVER;
    }
  }
  //PAUSED
  else if(gameState == GameState.PAUSED){
    noStroke();
    ellipseMode(CENTER);
    fill(#E9FB00);
    ellipse(450, 300, 600, 300);
    fill(#8106A9);
    ellipse(450, 300, 550, 250);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("PAUSED", 450, 250);
    textSize(25);
    text("Press ENTER to Continue", 450, 300);
    textSize(15);
  }
  //LEVEL UP
  else if(gameState == GameState.LEVELUP){
    noStroke();
    ellipseMode(CENTER);
    fill(#E9FB00);
    ellipse(450, 300, 600, 300);
    fill(#8106A9);
    ellipse(450, 300, 550, 250);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("SPACE INVADERS", 450, 250);
    textSize(25);
    text("Click to Start Level " + level, 450, 300);
    
    //Set next level
    if(player.lives <= 5)
      player.lives += 2;
    setupLevel();
  }
  //GAME OVER
  else if (gameState == GameState.GAMEOVER){
    noStroke();
    ellipseMode(CENTER);
    fill(#E9FB00);
    ellipse(450, 300, 600, 300);
    fill(#8106A9);
    ellipse(450, 300, 550, 250);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(40);
    text(!playerWon ? "Game Over" : "You Won!", 450, 250);
    textSize(25);
    text("Your Score : " + score , 450, 300);
    textSize(20);
    text("Click to Play Again", 450, 360);
    
  }
  //BOSS BATTLE
  else if (gameState == GameState.BOSSBATTLE){
    //background particles
    backParticles1.run();
    backParticles2.run();
    backParticles3.run();
    
    //PLAYER
    player.collide(bossMan.mainBullets);
    player.collide(bossMan.sideBullets);
    player.collideEMP(bossMan.emps);
    player.move();
    player.display();
 
    weaponManager.run();
    bossMan.run();
    //BOSS
    
    showScore();
    
    //check for guns upgrade
    if (laserUpgrade == 5){
      numLasers++;
      laserUpgrade = 0;
    }
    if (empUpgrade == 10){
      numEmps++;
      empUpgrade = 0;
    }
    
    //Check for game over condition
    if(player.lives == 0){
      gameState = GameState.GAMEOVER;
    }
    //Check for player won condition
    if(bossMan.isDead()){
      playerWon = true;
      gameState = GameState.GAMEOVER;
    }
  }
}

//************************************
//Method to display game stats
void showScore(){
   //display score
    noStroke();
    ellipseMode(CENTER);
    fill(#FFFF00);
    ellipse(width, 0, 120, 90);
    fill(#8106A9);
    ellipse(width, 0, 110, 80);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(score, 880, 12);
    
    //WEAPON STATS
    //lasers
    fill(#FF0000, 200);
    rectMode(CENTER);
    rect(850, 570, 15, 5);
    //emps
    stroke(#0A67A3);
    noFill();
    strokeWeight(3);
    ellipseMode(CENTER);
    ellipse(850, 550, 12, 12);
    //details
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(15);
    text(numEmps, 875, 545);
    text(numLasers, 875, 565);
    text(player.guns[player.weapon], 860, 585);
}

//************************************
//Method to manage levels
void setupLevel(){
  int y;
  int numPerRow;
  switch(level){
    //LEVEL 1
    case 1:
      //PLace level 1 enemies
      y = 60;
      numPerRow = 7;
      for(int i = 0, x = 90; i < 7; i++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
      }
      break;
    //LEVEL 2
    case 2:
      //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      //Place level 2 enemies
      y = 60;
      numPerRow = 7;
      for(int i = 0, x = 90, count = 1; i < 14; i++, x += 120, count++){
        enemyManager.addEnemy(x, y, 0, 1);
        //only add 7 per row
        if(count % numPerRow == 0){
          x = -30;
          y += 120;
        }
      }
      break;
    //LEVEL 3
    case 3:
      //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      //first row
      y = 60;
       for(int i = 0, x = 90; i < 7; i++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
       }
       //second row
       y = 180;
       for (int i = 0, x = 210; i < 5; i++, x += 120){
         enemyManager.addEnemy(x, y, 0, 1);
       }
       //thrid row
       y = 300;
       for (int i = 0, x = 330; i < 3; i++, x += 120){
         enemyManager.addEnemy(x, y, -1, 0);
       }
       break;
    //LEVEL 4
    case 4:
     //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      y = 60;
      //Left enemies
      for (int i = 0, x = 90, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
        //Jump to next row
        if(count % 3 == 0){
          x = -30;
          y += 120;
        }
      }
      //Right enemies
      y = 60;
      for (int i = 0, x = 570, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, -1, 0);
        //Jump to next row
        if(count % 3 == 0){
          x = 450;
          y += 120;
        }
      }
      break;
    //LEVEL 5
    case 5:
      //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      y = 60;
      //Left enemies
      for (int i = 0, x = 90, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 0, 1);
        //Jump to next row
        if(count % 3 == 0){
          x = -30;
          y += 120;
        }
      }
      enemyManager.addEnemy(330, 300, 1, 1);
      //Right enemies
      y = 60;
      for (int i = 0, x = 570, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 0, -1);
        //Jump to next row
        if(count % 3 == 0){
          x = 450;
          y += 120;
        }
      }
      enemyManager.addEnemy(570, 300, 1, 1);
      break;
    //LEVEL 6
    case 6:
      //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      y = 60;
      //Left enemies
      for (int i = 0, x = 90, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 1, 1);
        //Jump to next row
        if(count % 2 == 0){
          x = -30;
          y += 120;
        }
      }
      //Middle Enemeies
      y = 60;
      for (int i = 0, x = 450; i < 3; i++){
        enemyManager.addEnemy(x, y, 1, 0);
        //Jump to next row
        y += 120;
      }
      //Right Enemies
      y = 60;
      for (int i = 0, x = 690, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 1, 1);
        //Jump to next row
        if(count % 2 == 0){
          x = 570;
          y += 120;
        }
      }
      break;
    //Level 7
    case 7:
      //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      //first row
      y = 60;
       for(int i = 0, x = 90; i < 7; i++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
       }
       //second row
       y = 180;
       for (int i = 0, x = 210; i < 5; i++, x += 120){
         enemyManager.addEnemy(x, y, 1, 1);
       }
      break;
    //Level 8
    case 8:
      //Reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      //Place level 2 enemies
      y = 60;
      numPerRow = 7;
      for(int i = 0, x = 90, count = 1; i < 21; i++, x += 120, count++){
        enemyManager.addEnemy(x, y, 1, 1);
        //only add 7 per row
        if(count % numPerRow == 0){
          x = -30;
          y += 120;
        }
      }
      break;
    //BOSS BATTLES
    case 9:
      //Reset gameManagers;
      bossMan = new BossManager();
      weaponManager = new WeaponManager(player);
      if(player.lives <= 5)
        player.lives += 5;
      gameState = GameState.LEVELUP;  //show level up screen
      break;
    default:
      gameState = GameState.GAMEOVER; //game over
      break;
  }
}

//************************************
//Method to respond to keyboard input
void keyPressed(){
  
  //Shoot
  if(keyCode == TAB){
    weaponManager.shoot();
  }
  //Toggle guns
  if(key == 'q'){
    int gun = player.weapon;
    gun++;
    player.weapon = gun % 4;
  }
  //Pause Game
  if (key == ENTER || key == RETURN){
    if (gameState == GameState.INGAME)
      gameState = GameState.PAUSED; //Paused
    else if(gameState == GameState.PAUSED)
      gameState = GameState.INGAME;  //Continue Playing
  }
}

//************************************
//Method to respond to mouse input
void mouseReleased(){
  //START SCREEN
  if (gameState == GameState.PREGAME){
    gameState = GameState.INGAME;  //start the game
  }
  
  if (gameState == GameState.LEVELUP && level < 9){
    gameState = GameState.INGAME;
  }else if(gameState == GameState.LEVELUP && level == 9){
    gameState = GameState.BOSSBATTLE;
  }
  
  if (gameState == GameState.GAMEOVER){
    gameState = GameState.PREGAME;
    setup();
  }
}