//Class to manage boss for boss battle
class Boss {

  float x;
  float y;
  float len;
  float lives;
  int speed = 3;
  int xdir = 1;
  int ydir = 1;

  Boss() {
    x = 450;
    y = 200;
    len = 240;
    lives = 50;
   }

  void display() {
    //ship body
    noStroke();
    fill(#3BDA00); //green
    triangle(x - len/2, y, x + len / 2, y, x, y + len/2);
    triangle(x - 0.3 * len, y - 50, x + 0.3 * len, y -50, x, y - 10);
    ellipseMode(CENTER);
    ellipse(x, y, 0.3 * len, 0.6 * len);
    //side guns
    stroke(#3BDA00);
    strokeWeight(15);
    line(x - 0.3 * len, y, x - 0.3 * len, y + 60);
    line(x + 0.3 * len, y, x + 0.3 * len, y + 60);
    noStroke();
    fill(#F10026);  //purple
    ellipse(x, y + 50, 0.25 * len, 0.6 * len);

    //ALL TEST CODE HERE
    fill(255);
    textAlign(CENTER, CENTER);
    text(lives, x, y);
  }
  
  
  void move() {
    x += speed * xdir;
    y += speed/2 * ydir;

    //change directions
    if (x < 250) {
      x = 250;
      xdir *= -1;
    } else if ( x > 650) {
      x = 650;
      xdir *= -1;
    }

    if (y < 50) {
      y = 50;
      ydir *= -1;
    } else if (y > 250) {
      y = 250;
      ydir *= -1;
    }
  }

  //Collide with ship bullets
  void collide (ArrayList<Bullet> shipBullets) {
    for ( int i = 0; i < shipBullets.size(); i++) {
      Bullet b = shipBullets.get(i);
      float distance = dist(x, y, b.x, b.y);
      if (distance < len/2) {
        score++;
        laserUpgrade++;
        empUpgrade++;  //Number of kills before player gets new laser & emp
        b.isDead = true;
        lives --;
      }
    }
  }
  
   //Collide with ship lasers
  void collideLaser(ArrayList<Laser> shipLasers){
    for(int i = 0; i < shipLasers.size(); i++){
      Laser lsr = shipLasers.get(i);
      if( abs(x - lsr.x) < len/2){
        score++;
        lives--;
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
        lives--;
      }
    }
  }
  
}