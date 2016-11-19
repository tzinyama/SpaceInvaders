class Enemy{
  
  float x, xstart;
  float y, ystart;
  float size;
  float spd;
  int xdir;
  int ydir;
  float offset; //max distance enemy can move from starting position
  boolean isDead;
  
  Enemy(float tx, float ty, int xdir, int ydir){
    x = tx;
    y = ty;
    xstart = tx;
    ystart = ty;
    this.xdir = xdir;
    this.ydir = ydir;
    size = 40;
    offset = size * 1.5;
    spd = 1;
    isDead = false;
  }
  
  void display(){
    noStroke();
    fill(#3BDA00); //green
    ellipseMode(CENTER);
    ellipse(x, y,50, 50);
    triangle(x, y, x - size/2, y, x - size/2, y - size);
    triangle(x, y, x + size/2, y, x + size/2, y - size);
    fill(#F10026);  //purple
    ellipse(x, y, 0.7 * size, size/3);
    ellipse(x, y - size/4, 0.5 * size, size);
    
    //TEST CODE HERE
    //stroke(#FFFF00);
    //noFill();
    //strokeWeight(3);
    //rectMode(CENTER);
    //rect(xstart, ystart, 2 * offset,  2 * offset);
    
  }
  
  void move(){
   x += spd * xdir;
   y += spd * ydir;
    
   //check bounderies
   if(x < xstart - (offset - size/2)){  //so it doesn't overlap with others
     x = xstart - (offset - size/2);
     xdir *= -1;
   }else if( x > xstart + (offset - size/2)){
     x = xstart + (offset - size/2);
     xdir *= -1;
   }
    
   if(y < ystart - (offset - size)){
     y = ystart - (offset - size);
     ydir *= -1;
   }else if(y > ystart  + (offset - size/2)){
     y = ystart + (offset - size/2);
     ydir *= -1;
   }
  }
  
  //Collide with ship bullest
  void collide (ArrayList<Bullet> shipBullets){
    for( int i = 0; i < shipBullets.size(); i++){
      Bullet b = shipBullets.get(i);
      float distance = dist(x, y, b.x, b.y);
      if (distance < size/2){
        score++;
        laserUpgrade++;
        empUpgrade++;  //Number of kills before player gets new laser & emp
        b.isDead = true;
        isDead = true;
      }
    }
  }
  
  //Collide with ship lasers
  void collideLaser(ArrayList<Laser> shipLasers){
    for(int i = 0; i < shipLasers.size(); i++){
      Laser lsr = shipLasers.get(i);
      if( abs(x - lsr.x) < size/2){
        score++;
        isDead = true;
      }
    }
  }
  
  //Collide with ship EMPS
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