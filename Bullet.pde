class Bullet{
  
  float x;
  float y;
  int spd;  //speed
  int size;
  int dir; // 1 = up, -1 = down
  boolean isDead;
  
  Bullet(float tx, float ty, int tsize, int dir){
    x = tx;
    y = ty;
    this.dir = dir;
    size = tsize;
    spd = 8;
    isDead = false;
  }
  
  void display(){
    noStroke();
    fill(#FF0000, 200);
    ellipseMode(CENTER);
    ellipse(x, y, size - 3, size);
  }
  
  void move(){
    y -= spd * dir;
    
    //Bullet is off the screen
    if (y < -100)
      isDead = true;
    else if( y > height + 100)
      isDead = true;
  }
  
  //Enemy handles collision
  
}