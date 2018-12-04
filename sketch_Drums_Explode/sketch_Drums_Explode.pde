import processing.serial.*;

// The serial port:
Serial myPort;       

color colorRouge  = color(247,  56,  27);
color colorBleu   = color( 82, 153, 243);
color colorVert   = color(104, 207, 100);
color colorOrange = color(249, 167,   0);
color colorWhite  = color(255, 255, 255);

int Center_x = 0;
int Center_y = 0;

HashMap<String, Drum> mapDrums = new HashMap<String, Drum>();
float rotX, rotY;

ParticleSystem ps = new ParticleSystem();

void setup()
{
  size(1000, 500, P3D);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
  
  mapDrums.put("D4", new Drum(Center_x - 75, Center_y + 50, 50, colorRouge));
  mapDrums.put("D1", new Drum(Center_x, Center_y, 50, colorBleu));
  mapDrums.put("D2", new Drum(Center_x + 75, Center_y + 50, 50, colorVert));
  mapDrums.put("D3", new Drum(Center_x - 50, Center_y - 50, 30, colorOrange));
  mapDrums.put("D5", new Drum(Center_x + 50, Center_y - 50, 30, colorWhite));
}

void draw()
{
  background(32);
  strokeWeight(1);
  smooth();
  lights();
  translate(width/2, height/2);
  
  rotateX(rotX);
  rotateY(-rotY);
  
  ReadSerial();
  
  
  for(Drum entry : mapDrums.values())
  {
    //entry.setValue(round(random(1, 50)));
    entry.draw();
  }
  ps.run();
}


void ReadSerial()
{
  String Buffer = "";
  int lf = '\n';
  println("ReadSerial");
  while (myPort.available() > 0) {
    Buffer = myPort.readStringUntil(lf);
    if (Buffer != null)
    {
      Buffer = Buffer.replaceAll("\r\n", "");
      println(Buffer);
      if (Buffer.length() > 0)
      {
        if (Buffer.charAt(0) == '[' && Buffer.charAt(Buffer.length()-1) == ']')
        {
          Buffer = Buffer.substring(1, Buffer.length()-1);
          String[] Drums = Buffer.split(",");
          for(String strDrum : Drums)
          {
            String[] parts = strDrum.split(":");
            String Id = parts[0];
            int Value = Integer.parseInt(parts[1]);
            Drum temp = mapDrums.get(Id);
            temp.setValue(Value);
            mapDrums.put(Id, temp);
          }
        }
      }
    }
  }
}

void mouseDragged(){
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}


class Drum {
  float x;
  float y;
  float size;
  color col;

  int maxValue = 250;
  int value;
 
  Drum(float x, float y, float size, color col) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.col = col;
    this.value = 0;
  }
  
  void setValue(int value)
  {
    this.value = value;
    if (value != 0)
    {
      int m = round(map(value, 0, 1023, 0, size + 20)); // max 1023
      ps.addParticle(new PVector(this.x, this.y), this.col, m); 
    }
  }
  
  void draw() {
    stroke(col);
    noFill();
    ellipse(x, y, size, size);
    
    fill(col);
    PShape sphere = createShape(SPHERE, (size * value / maxValue) / 2);
    sphere.setFill(col);
    sphere.setStroke(false);
    shape(sphere, x, y);
  }
}


class ParticleSystem {
  ArrayList<Particle> particles;
  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void addParticle(PVector position, color c, int size) {
    particles.add(new Particle(position, c, size));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color col;
  int size;

  Particle(PVector l, color c, int s) {
    acceleration = new PVector(0.05, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 255.0;
    col = c;
    size = s;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(col, lifespan);
    fill(col, lifespan);
    ellipse(position.x, position.y, size, size);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}