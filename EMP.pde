class EMP{  // electro-magnetic pulse
  
  float x;
  float y;
  
  float size;
  int speed;
  float scale; // scale emps becuase the boss produces larger emp than rocket
  
  boolean isDead;
  
  EMP(float tx, float ty, float tscale){
    x = tx;
    y = ty;
    
    scale = tscale;
    size = 50 * scale;
    speed = 5;
  }
  
  void display(){
    
    if(!isDead){
      noFill();
      strokeWeight(5);
      ellipseMode(CENTER);
      stroke(#65A6D1);
      ellipse(x, y, size, size);
      stroke(#3E97D1);
      ellipse(x, y, 0.95 * size, 0.95 * size);
      stroke(#0A67A3);
      ellipse(x, y, 0.9 * size, 0.9 * size);
      stroke(#0A67A3);
      ellipse(x, y, 0.85 * size, 0.85 * size);  
    }
  }
  
  void move(){
    size += speed;
    //max range of emp
    if (size > 500 * scale)  //
      isDead = true;
  }
  
  void collide(Enemy target){
    float distance =  dist(x, y, target.x, target.y);
    if(distance < target.size/2){
      target.isDead = true;
    }
  }
}