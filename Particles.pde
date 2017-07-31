class Particle{
  
  color[] colors = {230, 210, 190, 170, 150, 130};
  
  float x;
  float y;
  float xvel;
  float yvel;
  
  float acceleration;
  float lifespan;
  
  color clr;
  int size;
  
  Particle(float tx, float ty, int tsize){
    x = tx;
    y = ty;
    acceleration = 0.1;
    xvel = random(-2, 2);
    yvel = random(-2, 0);
    
    clr = colors[int(random(colors.length))];
    size = tsize;
    lifespan = 255.0;
  }
  
  void run(){
    update();
    display();
  }
  
  void update(){
    yvel += acceleration;
    
    // move
    x += xvel;
    y += yvel;
    lifespan -= 1.0;
  }
  
  void display(){
    noStroke();
    fill(clr, lifespan);  // gradually become transparent
    ellipse(x, y, size, size);
  }
  
  boolean isDead(){
    if (lifespan < 0.0){
      return true;
    }else{
      return false;
    }
  }
}

//*************************************************************

class ParticleManager{
  
  ArrayList<Particle> particles;
  PVector origin;
  int size;
  
  ParticleManager(float x, float y, int tsize){
    origin = new PVector(x, y);
    size = tsize;
    particles = new ArrayList<Particle>();
  }
  
  void addParticle(){
    particles.add(new Particle(origin.x, origin.y, size));
  }
  
  void run(){
    addParticle();
    
    for (int i = particles.size() - 1; i >= 0; i--){
      Particle p = particles.get(i);
      p.run();
      if(p.isDead()){
        particles.remove(i);
      }
    }
  }
}