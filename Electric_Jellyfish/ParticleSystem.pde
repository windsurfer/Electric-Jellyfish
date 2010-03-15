
class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are born
  PImage particleImage; //Image of the particle  
  float volume;
  
  ParticleSystem(int num, PVector v, PImage imageRef) {
    //Image for particles
    particleImage = imageRef;
    
    //Location
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin,particleImage));    // Add "num" amount of particles to the arraylist
    }
  }

  void run(float s) {
    volume = s;
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run(volume);//Pass it along...
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {
    Particle part = new Particle(origin,particleImage);
    part.vel.mult(7);
    particles.add(part);
  }
  
    void addParticle(float x, float y) {
    particles.add(new Particle(new PVector(x,y),particleImage));
  }
  //For removing?
  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}

