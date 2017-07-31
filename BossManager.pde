class BossManager{
  
  Boss boss;
  ArrayList<Bullet> mainBullets;
  ArrayList<Bullet> sideBullets;
  ArrayList<EMP> emps;
  
  int gun;  // Gun that the boss will use. 0 = main gun, 1 = side guns, 2 = emp
  
  /*
    Boss picks random gun from guns array so he has 50% probability of using main gun, 
    40% probability of using side gun and 10% probability of using EMP
  */
  int guns[] = {0, 0, 1, 1, 0, 0, 1, 2, 0, 1};
  int shootDelay = 0; // number of frames to wait before boss can shoot
  
  BossManager(){
    boss = new Boss();
    mainBullets = new ArrayList<Bullet>();
    sideBullets = new ArrayList<Bullet>();
    emps = new ArrayList<EMP>();
  }
  
  void shoot(){
    gun = guns[int(random(guns.length))];
    
    switch(gun){
      //Main Gun
      case 0:
        if (mainBullets.size() < 3){
          mainBullets.add(new Bullet(boss.x, boss.y + 75, 12, -1));
        }
        break;
      // Side bullets
      case 1:
        if (sideBullets.size() < 3){
          sideBullets.add(new Bullet(boss.x - 0.3* boss.len, boss.y + 30, 9, -1));
          sideBullets.add(new Bullet(boss.x + 0.3* boss.len, boss.y + 30, 9, -1));
        }
        break;
      // EMPs
      case 2:
        if(emps. size() < 1){
          emps.add(new EMP(boss.x, boss.y, 1.5)); //scale of 1.5
        }
        break;
      default:
        break;
    }
  }
  
  void run(){
    boss.move();
    boss.collide(weaponManager.mainBullets);
    boss.collide(weaponManager.sideBullets);
    boss.collideLaser(weaponManager.lasers);
    boss.collideEMP(weaponManager.emps);
    boss.display();
    
    // see if game is over
    if(bossMan.isDead())
      gameState = GameState.GAMEOVER;  // Another game state for beat the game
      
    // main Bullets
    for(int i = 0; i < mainBullets.size(); i++){
      Bullet bullet = mainBullets.get(i);
      bullet.move();
      bullet.display();
      if(bullet.isDead)
        mainBullets.remove(i);
    }
    
     // side bullets
   for (int i = 0; i < (sideBullets.size()); i++){
     Bullet bullet = sideBullets.get(i);
     bullet.move();
     bullet.display();
     //get rid of dead bullets
     if(bullet.isDead)
      sideBullets.remove(i);
   }
   
   // EMP
   for (int k = 0; k < emps.size(); k++){
     EMP emp = emps.get(k);
     emp.display();
     emp.move();
     if(emp.isDead)  
        emps.remove(k);
   }
   
   shootDelay++;
   if(shootDelay == 80){
     shoot();
     shootDelay = 0;
   }
  
  }
  
  boolean isDead(){
    return boss.lives == 0;
  }
}