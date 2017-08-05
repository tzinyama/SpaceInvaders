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

// number of lasers and emps player has
int numLasers;
int numEmps;

// number of enemies killes before you get bullets for special guns
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


void manageGame(){
  
  if (gameState == GameState.PREGAME){ //
    welcomeScreen();
  }
  else if(gameState == GameState.INGAME){
    inGame();
  }
  else if(gameState == GameState.PAUSED){
    gamePaused();
  }
  else if(gameState == GameState.LEVELUP){
    levelUp();
  }
  else if (gameState == GameState.GAMEOVER){
    gameOver();
  }
  else if (gameState == GameState.BOSSBATTLE){
    bossBattle();
  }
}

void welcomeScreen(){
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

void inGame(){
  backParticles1.run();
  backParticles2.run();
  backParticles3.run();
  
  player.move();
  player.collide(enemyManager.bullets);
  player.display();
  
  weaponManager.run();
  enemyManager.run();
  showScore();
  
  // check for guns upgrade
  if (laserUpgrade == 5){
    numLasers++;
    laserUpgrade = 0;
  }
  if (empUpgrade == 10){
    numEmps++;
    empUpgrade = 0;
  }
  
  // check for level up condition
  if (enemyManager.enemies.size() == 0){
    level++; //level up
    gameState = GameState.LEVELUP; //Level Up
  }
  
  // check for game over condition
  if(player.lives == 0){
    gameState = GameState.GAMEOVER;
  }
}

void gamePaused(){
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

void levelUp(){
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
  
  // set next level
  if(player.lives <= 5)
    player.lives += 2;
  setupLevel();
}

void gameOver(){
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

void bossBattle(){
  //background particles
    backParticles1.run();
    backParticles2.run();
    backParticles3.run();
    
    // PLAYER
    player.collide(bossMan.mainBullets);
    player.collide(bossMan.sideBullets);
    player.collideEMP(bossMan.emps);
    player.move();
    player.display();
 
    weaponManager.run();
    bossMan.run();
    // BOSS
    
    showScore();
    
    // check for guns upgrade
    if (laserUpgrade == 5){
      numLasers++;
      laserUpgrade = 0;
    }
    if (empUpgrade == 10){
      numEmps++;
      empUpgrade = 0;
    }
    
    // check for game over condition
    if(player.lives == 0){
      gameState = GameState.GAMEOVER;
    }
    // check for player won condition
    if(bossMan.isDead()){
      playerWon = true;
      gameState = GameState.GAMEOVER;
    }
}


void showScore(){
   // display score
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
    
    // WEAPON STATS
    // lasers
    fill(#FF0000, 200);
    rectMode(CENTER);
    rect(850, 570, 15, 5);
    // emps
    stroke(#0A67A3);
    noFill();
    strokeWeight(3);
    ellipseMode(CENTER);
    ellipse(850, 550, 12, 12);
    // details
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(15);
    text(numEmps, 875, 545);
    text(numLasers, 875, 565);
    text(player.guns[player.weapon], 860, 585);
}


void setupLevel(){
  int y;
  int numPerRow;
  switch(level){
    // LEVEL 1
    case 1:
      // place level 1 enemies
      y = 60;
      numPerRow = 7;
      for(int i = 0, x = 90; i < 7; i++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
      }
      break;
    // LEVEL 2
    case 2:
      // reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      // place level 2 enemies
      y = 60;
      numPerRow = 7;
      for(int i = 0, x = 90, count = 1; i < 14; i++, x += 120, count++){
        enemyManager.addEnemy(x, y, 0, 1);
        // only add 7 per row
        if(count % numPerRow == 0){
          x = -30;
          y += 120;
        }
      }
      break;
    // LEVEL 3
    case 3:
      // reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      // first row
      y = 60;
       for(int i = 0, x = 90; i < 7; i++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
       }
       // second row
       y = 180;
       for (int i = 0, x = 210; i < 5; i++, x += 120){
         enemyManager.addEnemy(x, y, 0, 1);
       }
       // thrid row
       y = 300;
       for (int i = 0, x = 330; i < 3; i++, x += 120){
         enemyManager.addEnemy(x, y, -1, 0);
       }
       break;
    // LEVEL 4
    case 4:
     // reset gameManagers;
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
      // right enemies
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
    // LEVEL 5
    case 5:
      // reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      y = 60;
      // left enemies
      for (int i = 0, x = 90, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 0, 1);
        // jump to next row
        if(count % 3 == 0){
          x = -30;
          y += 120;
        }
      }
      enemyManager.addEnemy(330, 300, 1, 1);
      // right enemies
      y = 60;
      for (int i = 0, x = 570, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 0, -1);
        // jump to next row
        if(count % 3 == 0){
          x = 450;
          y += 120;
        }
      }
      enemyManager.addEnemy(570, 300, 1, 1);
      break;
    // LEVEL 6
    case 6:
      // reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      y = 60;
      // left enemies
      for (int i = 0, x = 90, count = 1; i < 6; i++, count++, x += 120){
        enemyManager.addEnemy(x, y, 1, 1);
        // jump to next row
        if(count % 2 == 0){
          x = -30;
          y += 120;
        }
      }
      // middle Enemeies
      y = 60;
      for (int i = 0, x = 450; i < 3; i++){
        enemyManager.addEnemy(x, y, 1, 0);
        // jump to next row
        y += 120;
      }
      // right enemies
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
    // Level 7
    case 7:
      // reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      // first row
      y = 60;
       for(int i = 0, x = 90; i < 7; i++, x += 120){
        enemyManager.addEnemy(x, y, 1, 0);
       }
       // second row
       y = 180;
       for (int i = 0, x = 210; i < 5; i++, x += 120){
         enemyManager.addEnemy(x, y, 1, 1);
       }
      break;
    // Level 8
    case 8:
      // reset gameManagers;
      enemyManager = new EnemyManager();
      weaponManager = new WeaponManager(player);
      // place level 2 enemies
      y = 60;
      numPerRow = 7;
      for(int i = 0, x = 90, count = 1; i < 21; i++, x += 120, count++){
        enemyManager.addEnemy(x, y, 1, 1);
        // only add 7 per row
        if(count % numPerRow == 0){
          x = -30;
          y += 120;
        }
      }
      break;
    // BOSS BATTLES
    case 9:
      // reset gameManagers;
      bossMan = new BossManager();
      weaponManager = new WeaponManager(player);
      if(player.lives <= 5)
        player.lives += 5;
      gameState = GameState.LEVELUP;  // show level up screen
      break;
    default:
      gameState = GameState.GAMEOVER; // game over
      break;
  }
}

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
      gameState = GameState.PAUSED;
    else if(gameState == GameState.PAUSED)
      gameState = GameState.INGAME;
  }
}

void mouseReleased(){
  if (gameState == GameState.PREGAME){
    gameState = GameState.INGAME;
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