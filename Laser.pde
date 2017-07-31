class Laser{
  
  float x;
  float ystart;
  float yend;
  int speed;
  boolean isDead;
  
  Laser(float tx, float ty){
    x = tx;
    ystart = ty;
    yend = ystart - 50;
    speed = 100;
    isDead = false;
  }
  
  void display(){
    if (!isDead){
      stroke(#FF0000);
      strokeWeight(5);
      line(x, ystart, x, yend);
    }
  }
  
  void move(){
    yend -= speed;
    //disable laser after some time
    if (yend < - 300)
      isDead = true;
  }
  
  void collide(Enemy target){
    if(abs(x - target.x) < target.size/2){
      target.isDead = true;
    } 
  }
}