// A simple Particle class
class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  PImage particleImage;
  float volume;
  
  // Another constructor (the one we are using here)
  Particle(PVector l, PImage imageRef) {
    acc = new PVector(0,-0.03,0);
    vel = new PVector(random(-1,1),random(-2,0),0);
    loc = l.get();
    //r = 10.0;
    r = random(5,20);//Low, High
    timer = 100.0;//Lifetime
    particleImage = imageRef;
  }

  void run(float x) {
    volume = pow(x,2);
    update();
    render();
  }

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(random(0.85,1.15));
    timer -= 1.0;
  }

  // Method to display
  void render() {
    imageMode(CENTER);
    tint(255, 255, 255,timer); //Tinting the image to transparent
    image( particleImage, loc.x,loc.y,r*volume,r*volume); 
    noTint();
    //Not displaying the vector obviously
    /*
    ellipseMode(CENTER);
    stroke(255,timer);
    fill(90,timer);//0-100
    ellipse(loc.x,loc.y,r,r);
    //displayVector(vel,loc.x,loc.y,10);
    */
  }
  
  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
   void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  } 

}

