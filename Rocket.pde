class Rocket{
  
  int x;
  int y;
  int vel;
  int len;
  
  int myHeight;
  int gunOffset;
  
  int lives;
  int weapon;  // 0 = main gun, 1 = main + side , 2 = laser, 3 = emp
  String[] guns = {"Gun", "Spray Gun", "Laser", "EMP"};
  
  Rocket(){
    x = width/2;
    y = height - 60;
    vel = 8;
    len = 100;
    myHeight = 100;
    
    lives =  8;
    weapon = 0;
    gunOffset = 40;
  }
  
  void display(){
    
    stroke(#FFFF00);
    strokeWeight(8);
    strokeCap(ROUND);
    line(x - 40, y - 15, x - 40, y + 30);
    line(x + 40, y - 15, x + 40, y + 30);
    
    fill(#FFFF00);
    noStroke();
    rectMode(CENTER);
    rect(x, y, len, 30, 45);
    ellipseMode(CENTER);
    ellipse(x, y, 60, myHeight);
    
    fill(#8106A9);
    rect(x, y + 3, 85, 20, 45);
    ellipse(x, y + 10, 47, 80);
    fill(#FFFF00);
    ellipse(x, y + 12, 35, 60);
    
    for (int l = 0, lx = 12; l < lives; l++, lx += 12){
       fill(#FFFF00);
       ellipse(lx, 580, 10, 10);
       fill(#8106A9);
       ellipse(lx, 580, 7, 7);
    }
  }
  
  void move(){
    
    if (keyPressed){
      if(keyCode == UP)
        y -= vel;
      else if(keyCode == DOWN)
        y += vel;
      
      if(keyCode == LEFT)
        x -= vel;
      else if(keyCode == RIGHT)
        x +=vel;
    }
    
    if(x < len / 2)
     x = len/2;
    else if( x > width - len/2)
     x = width - len/2;
      
    if (y < height - 300)
     y = height - 300;
    else if (y > height){
     y =  height;
    }
  }
  
  void collide(ArrayList<Bullet> enemyBullets){
    for (int i =0; i < enemyBullets.size(); i++){
      Bullet b = enemyBullets.get(i);
      float distance = dist(x, y, b.x, b.y);
      if (distance < len/2){
        b.isDead = true;
        lives--;
      }
    }
  }
  
  void collideEMP(ArrayList<EMP> bossEmps){
    for (int i = 0; i < bossEmps.size(); i++){
      EMP pulse = bossEmps.get(i);
      float distance = dist(x, y, pulse.x, pulse.y);
      if (distance < (pulse.size/2)){
        lives--;
      }
    } 
  }
}