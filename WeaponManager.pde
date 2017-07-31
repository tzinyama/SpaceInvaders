class WeaponManager{
  
  Rocket roc;
  Laser laser;
  
  ArrayList<Enemy> foes;
  ArrayList<Bullet> mainBullets;
  ArrayList<Bullet> sideBullets;
  ArrayList<Laser> lasers;
  ArrayList<EMP> emps;
  
  int maxLasers;
  int maxEmp;
  int maxBullets; // max bullets gun can shoot at a time
  
  WeaponManager(Rocket troc){
    roc = troc;
    maxLasers = 1;  // only one laser a time
    maxEmp = 1;     // only one emp at a time
    maxBullets = 5;
    
    mainBullets = new ArrayList<Bullet>();
    sideBullets = new ArrayList<Bullet>();
    lasers = new ArrayList<Laser>();
    emps = new ArrayList<EMP>();
    
    //get all current enemies
    foes = enemyManager.enemies;
  }
  
  void shoot(){
    
    switch(roc.weapon){
      case 0:  // main gun
        if (mainBullets.size() < maxBullets){
          mainBullets.add(new Bullet(roc.x, roc.y, 10, 1));
        }
        break;
      case 1: // main gun & side guns
        if (mainBullets.size() < maxBullets){
          mainBullets.add(new Bullet(roc.x, roc.y, 10, 1));
          sideBullets.add(new Bullet(roc.x - roc.gunOffset, roc.y, 8, 1));
          sideBullets.add(new Bullet(roc.x + roc.gunOffset, roc.y, 8, 1));
        }
        break;
      case 2: // laser
        if (lasers.size() < maxLasers && numLasers > 0){
          lasers.add( new Laser(roc.x, (roc.y - roc.myHeight/2) - 5));
          numLasers--;
        }
        break;
      case 3:// emps
        if(emps.size() < maxEmp && numEmps > 0){
          emps.add(new EMP(roc.x, roc.y, 1));  //scale of 1
          numEmps--;
        }
        break;
      default:
        break;
    }
  }
  
  void run(){
    // main bullets
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
    
    // lasers
   for (int j = 0; j < lasers.size(); j++){
     Laser laser = lasers.get(j);
     laser.move();
     laser.display();
     //get rid of dead lasers
     if (laser.isDead)
       lasers.remove(j);
   }
   
   // EMP
   for (int k = 0; k < emps.size(); k++){
     EMP emp = emps.get(k);
     emp.display();
     emp.move();
     if(emp.isDead)  
        emps.remove(k);
   }
  }
}