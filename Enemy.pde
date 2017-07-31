class Enemy{
  
  float x, xstart;
  float y, ystart;
  
  float size;
  float speed;
  
  int xdirection;
  int ydirection;
  
  float offset; // max distance enemy can move from starting position
  boolean isDead;
  
  Enemy(float tx, float ty, int xdir, int ydir){
    x = tx;
    y = ty;
    xstart = tx;
    ystart = ty;
    this.xdirection = xdir;
    this.ydirection = ydir;
    
    size = 40;
    offset = size * 1.5;
    speed = 1;
    
    isDead = false;
  }
  
  void display(){
    noStroke();
    fill(#3BDA00);
    ellipseMode(CENTER);
    ellipse(x, y,50, 50);
    triangle(x, y, x - size/2, y, x - size/2, y - size);
    triangle(x, y, x + size/2, y, x + size/2, y - size);
    fill(#F10026);
    ellipse(x, y, 0.7 * size, size/3);
    ellipse(x, y - size/4, 0.5 * size, size);
    
  }
  
  void move(){
   x += speed * xdirection;
   y += speed * ydirection;
    
   // check bounderies
   if(x < xstart - (offset - size/2)){  // so it doesn't overlap with others
     x = xstart - (offset - size/2);
     xdirection *= -1;
   }else if( x > xstart + (offset - size/2)){
     x = xstart + (offset - size/2);
     xdirection *= -1;
   }
    
   if(y < ystart - (offset - size)){
     y = ystart - (offset - size);
     ydirection *= -1;
   }else if(y > ystart  + (offset - size/2)){
     y = ystart + (offset - size/2);
     ydirection *= -1;
   }
  }
  
  // collide with ship bullets
  void collide (ArrayList<Bullet> shipBullets){
    for( int i = 0; i < shipBullets.size(); i++){
      Bullet b = shipBullets.get(i);
      float distance = dist(x, y, b.x, b.y);
      if (distance < size/2){
        score++;
        laserUpgrade++;
        empUpgrade++;  // number of kills before player gets new laser & emp
        b.isDead = true;
        isDead = true;
      }
    }
  }
  
  // collide with ship lasers
  void collideLaser(ArrayList<Laser> shipLasers){
    for(int i = 0; i < shipLasers.size(); i++){
      Laser lsr = shipLasers.get(i);
      if( abs(x - lsr.x) < size/2){
        score++;
        isDead = true;
      }
    }
  }
  
  // collide with ship EMPS
  void collideEMP(ArrayList<EMP> shipEmps){
    for (int i = 0; i < shipEmps.size(); i++){
      EMP pulse = shipEmps.get(i);
      float distance = dist(x, y, pulse.x, pulse.y);
      if (distance < (pulse.size/2)){
        score++;
        isDead = true;
      }
    }
  }
}