class EnemyManager{
  
  ArrayList<Enemy> enemies;
  ArrayList<Bullet> bullets;
  int maxBullets;
  
  EnemyManager(){
    enemies = new ArrayList<Enemy>();
    bullets = new ArrayList<Bullet>();
    maxBullets = 2;
  }
  
  void addEnemy(float tx, float ty, int xdirection, int ydirection){
     enemies.add(new Enemy(tx, ty, xdirection, ydirection));
  }
  
  void shoot(float tx, float ty, int size){
    if (bullets.size() < maxBullets){
      bullets.add( new Bullet(tx, ty, size, -1));
    }
    
  }
  
  void run(){
    // arm a random enemy ship to shoot from
    int armed1 = int(random(enemies.size()));
    int armed2 = int(random(enemies.size()));
    
    for (int i = 0; i < enemies.size(); i++){
      Enemy eny = enemies.get(i);
      
      if(i == armed1){
        shoot(eny.x, eny.y, 10); //shoot a bullet
      }else if (i == armed2){
        shoot(eny.x, eny.y, 10);
      }
      
      eny.move();
      
      // collide with different types of bullets
      eny.collide(weaponManager.mainBullets);
      eny.collide(weaponManager.sideBullets);
      eny.collideLaser(weaponManager.lasers);
      eny.collideEMP(weaponManager.emps);
      eny.display();
        
      // remove dead enemies
      if(eny.isDead)
        enemies.remove(i);
    }
    
    // manage enemy bullets
    for (int i = 0; i < bullets.size(); i++){
      Bullet b = bullets.get(i);
      b.move();
      b.display();
      //remove dead bullets
      if(b.isDead)
        bullets.remove(i);
    }
  }
}