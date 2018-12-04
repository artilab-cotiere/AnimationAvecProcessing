ParticleSystem ps = new ParticleSystem();
PShape Tree;

boolean init = true;
color colorText  = color(0, 0, 0);

void setup() {
  size(900, 850, P3D);
  Tree = loadShape("Tree4.svg");
} 

void draw(){
  background(255);
  shape(Tree,  width/2 - 800/2, height - 800, 800, 800);
  
  if (init)
  {
    fill(colorText);
    textSize(32);
    textAlign(CENTER);
    text("< Cliquer pour ajouter une fleur >", width / 2, height - height / 8);
  }

  fill(colorText);
  rect(0,0,20,20);
  rect(width-20,0,width,20);
  
  ps.run();
}

void mouseClicked() {
  init = false;
  // backup position
  if(mouseX>0 && mouseX<20 && mouseY>0 && mouseY<20)
  {
    for(int i = 0; i < ps.particles.size(); i++) //Particle myP in ps.particles)
    {
      PVector position = ps.particles.get(i).position_Origin;     
      println("ps.addParticle(new PVector(" + position.x + ", " +position.y + "));");
    }
  }
  // redraw position
  if(mouseX>width-20 && mouseX<width && mouseY>0 && mouseY<20)
  {
    ps.particles.clear();
    ps.addParticle(new PVector(318.0, 587.0));
    ps.addParticle(new PVector(291.0, 511.0));
    ps.addParticle(new PVector(390.0, 475.0));
    ps.addParticle(new PVector(332.0, 485.0));
    ps.addParticle(new PVector(212.0, 443.0));
    ps.addParticle(new PVector(58.0, 566.0));
    ps.addParticle(new PVector(68.0, 386.0));
    ps.addParticle(new PVector(76.0, 234.0));
    ps.addParticle(new PVector(109.0, 291.0));
    ps.addParticle(new PVector(160.0, 338.0));
    ps.addParticle(new PVector(211.0, 284.0));
    ps.addParticle(new PVector(270.0, 300.0));
    ps.addParticle(new PVector(385.0, 326.0));
    ps.addParticle(new PVector(415.0, 253.0));
    ps.addParticle(new PVector(441.0, 310.0));
    ps.addParticle(new PVector(418.0, 172.0));
    ps.addParticle(new PVector(286.0, 175.0));
    ps.addParticle(new PVector(330.0, 156.0));
    ps.addParticle(new PVector(222.0, 99.0));
    ps.addParticle(new PVector(169.0, 103.0));
    ps.addParticle(new PVector(290.0, 84.0));
    ps.addParticle(new PVector(435.0, 69.0));
    ps.addParticle(new PVector(572.0, 97.0));
    ps.addParticle(new PVector(559.0, 218.0));
    ps.addParticle(new PVector(600.0, 171.0));
    ps.addParticle(new PVector(692.0, 110.0));
    ps.addParticle(new PVector(765.0, 96.0));
    ps.addParticle(new PVector(727.0, 225.0));
    ps.addParticle(new PVector(673.0, 244.0));
    ps.addParticle(new PVector(822.0, 217.0));
    ps.addParticle(new PVector(710.0, 352.0));
    ps.addParticle(new PVector(660.0, 302.0));
    ps.addParticle(new PVector(592.0, 311.0));
    ps.addParticle(new PVector(583.0, 361.0));
    ps.addParticle(new PVector(522.0, 422.0));
    ps.addParticle(new PVector(498.0, 386.0));
    ps.addParticle(new PVector(635.0, 401.0));
    ps.addParticle(new PVector(758.0, 396.0));
    ps.addParticle(new PVector(783.0, 531.0));
    ps.addParticle(new PVector(711.0, 538.0));
    ps.addParticle(new PVector(652.0, 502.0));
    ps.addParticle(new PVector(593.0, 539.0));
  }
  else
  {
    ps.addParticle(new PVector(mouseX, mouseY));
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void addParticle(PVector position) {
    particles.add(new Particle(position));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
    }
  }
}

class Particle {
  PVector position;
  PVector position_Origin;
  
  PVector velocity;
  PVector acceleration;
  
  float rotation;
  
  float size;
  float maxSize;
  
  PShape SParticle;
  float rotatee = 0.0;
  
  Particle(PVector l) {
    position_Origin = l.copy();
    init(position_Origin);
  }
  
  void init(PVector pos)
  {
    position = pos.copy();
    
    acceleration = new PVector(         0.01, 0.05);
    velocity     = new PVector(random(-1, 1), random(-2, 0));
    maxSize      = random(   20, 60);
    rotation     = random(-10.0, 10.0);
    
    size = 0;
    SParticle = loadShape("flower2.svg");
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    if (isGrown())
    {
      velocity.add(acceleration);
      position.add(velocity);
      rotatee += rotation;
    }
    else
    {
      size++;
      position.add(-0.5, -0.5);
    }
    
    if (isDead())
    {
      init(position_Origin);
    }
  }

  // Method to display
  void display() {
       
    pushMatrix();
    
    if (isGrown())
    {
      translate(position.x + size/2, position.y + size/2);    
      rotate(radians(rotatee));
      translate(-position.x - size/2, -position.y - size/2);   
    }
    shape(SParticle, position.x, position.y, size, size);
    
    popMatrix();
  }

  // Is the particle still useful?
  boolean isDead() {
    return (position.y > height);
  }
  
  boolean isGrown() {
    return (size > maxSize);
  }
}