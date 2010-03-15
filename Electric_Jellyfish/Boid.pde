// Our basic boid class
class Boid
{
  // location, acceleration, and velocity vectors
  PVector loc;
  PVector acc;
  PVector vel;
  
  float maxspeed;
  float maxforce; 
  float wandertheta = 0.0f;
  float move_mag = 0.5f;
  float drag = 0.95f;
  
  // colour
  color col;
  float radius;
  
  //Images
  PImage img;
  PImage img2;
  
  //Jelly Resource
  int counter = 0;
  int jellyCount = 0;
  float jellyX = random(90,130); //Random Sizes
  float jellyY = random(50,60);
  
  float addX = 1;
  float addY = 1;
  
  Boid( PVector location, PImage imageRef, PImage imageRef2 )
  {
    //Receiveing from parent
    img = imageRef;
    img2 = imageRef2;
    
    loc = location;
    acc = new PVector( 0, 0 );
    vel = new PVector( random(-3, 3), random(-3, 3) );

    maxspeed = random( 2.0f, 3.5f );
    maxforce = 0.01f;
  }
  
  void run(float x, float y)
  {
    addX = x;
    addY = y;
    
    update();
    borders();
    render();
  }

  void update()
  {
    PVector sep = separation( boids );
    // scale it up to make it more dramatic
    sep.mult( 1.0 );
    // add separation vector to acceleration
    acc.add( sep );
    
    // add our acceleration vector to our velocity
    vel.add( acc );
    // take into consideration some drag
    vel.mult(drag);
    // make sure our velocity is capped at maxspeed
    vel.limit( maxspeed );
    // add to our location to move us
    loc.add( vel );

    // zero out acceleration    
    acc.mult( 0 );
  }
  
  PVector separation( ArrayList boids )
  {
    // Separation behaviour calculates the average direction vector that we need to move
    // in to move away from all of our neighbours.
    
    // we want to be 25 pixels apart from our neighbors
    float desiredSeparation = 100.0f;
    
    // direction to steer in to keep away from other boids
    PVector steerVec = new PVector( 0, 0 );
    
    // number of neighbours we're close to
    int count = 0;
    
    // loop through all the boids 
    for ( int i=0; i<boids.size(); i++ )
    {
      // for each one, calculate our distance
      Boid neighbor = (Boid) boids.get(i);
      float d = PVector.dist( loc, neighbor.loc );
      
      // if we're more than 0px away and less than our desired separation (25px)
      if ( d > 0 && d < desiredSeparation )
      {
        // find vector between us and the neighbor
        // since we're subtracting neighbor position from loc, the vector will point AWAY from the neighbor boid
        PVector diff = PVector.sub( loc, neighbor.loc );
        // normalize it so that it's a unit vector of 1
        diff.normalize();
        // divide it by the distance (will be larger the closer you are to the neighbour, smaller the further you are)
        // reason for this is that we need to steer sharply away if we're close to an object, but can steer gradually around it
        // if we're far away
        diff.div(d);
        // add it to our steering vector
        steerVec.add(diff);     
        // increase the count so we can keep track of how many neighbors we're moving away from
        ++count;
      }   
    }
     
    if ( count > 0 )
    {
      // calculate the average direction we should move towards to move away from all of the neighbor boids
       steerVec.div( (float)count );
    }
    
    // if we have to steer (magnitude is greater than zero)
    if ( steerVec.mag() > 0 )
    {
      // make the vector the length of maxspeed by normalizing it (making it 1 unit), then multiplying it by maxspeed
      steerVec.normalize();
      steerVec.mult( maxspeed );
      
      // find vector in between velocity and steer (like we did for steer() function)
      steerVec.sub( vel );
      // limit it by the maximum amount we can steer
      steerVec.limit( maxforce );
    }
     
    return steerVec;
  }

  void seek( PVector target )
  {
    // get the steering vector that will adjust us towards the target
    // false is passed in to not slowdown
    PVector steerVec = steer( target, true );    
    // add steering vector 
    acc.add( steerVec );
    
  }
  
  void arrive( PVector target )
  {
    // get the steering vector that will adjust us towards the target
    // true is passed in to slowdown
    PVector steerVec = steer( target, true );
    
    // add steering vector s
    acc.add( steerVec );
  }

 
  PVector steer( PVector target, Boolean slowdown)
  {
    // note: see steering_behavior.pdf for a breakdown of the following
    
    // vector that we'll add to our acceleration to steer towards target
    PVector steering;
    
    // calculate our desired velocity vector (would bring us to target)
    PVector desired = PVector.sub( target, loc );
    
    // how far are we from target (magnitude of the desired vector)
    float d = desired.mag();
    
    // is our distance greater than zero?
    if ( d > 0 )
    {
      // normalize the desired vector to get a vector of length (magnitude) 1 that points in the proper direction
      desired.normalize(); 

      // if we're close to our target (within 100px) and we're to slowdown
      if ( slowdown && d < 200.0f )
      {
        // slow us down based on the distance
        desired.mult( maxspeed * (d/20.0f) );
      }
      else
      {
        // make the desired vector the length of our maxspeed
        desired.mult( maxspeed );
      }

      // calculate steering vector
      steering = PVector.sub( desired, vel );
      // limit it our maximum steering force so that we don't turn to face our target 100% all at once
      steering.limit( maxforce );       
    }
    else
    {
      // distance is zero - we're at the target, no steering necessary
      steering = new PVector( 0, 0 ); 
    }
   
    // return the steering vector
    return steering;
  }
    
  void borders()
  {
    //Adjusting borders by a reasonable size...
    if (loc.x < -radius -70) loc.x = width+radius+70;
    if (loc.y < -radius -70) loc.y = height+radius+70;
    if (loc.x > width+radius +70) loc.x = -radius-70;
    if (loc.y > height+radius +70) loc.y = -radius-70;
  }
  

  void render()
  {
    //Boid redrawing
    pushMatrix();
      fill( col );
      noStroke();
      
      translate( loc.x, loc.y );
      float theta = vel.heading2D() + radians(90);
      rotate(theta);
      
      
     //Jelly image code
     imageMode( CENTER );//To fix the Positioning
     if (is_moving()){     
       if (jellyCount < 30)
       {
         jellyX -=1;  
         jellyY +=1.5;
       }else if (jellyCount < 60){
         jellyX +=1;  
         jellyY -=1.5;
       }else{
         jellyCount=-1;
       }
       jellyCount++;
     }/*else{
         //jellyCount=0;
         
         // slowly bring the values back to a normal range
         
         if (jellyX < 90){
           jellyX+=1.5;
         }else if (jellyX > 130){
           jellyX-=1.5;
         }
         
         if (jellyY < 50){
           jellyY +=1;
         }else if (jellyY > 60){
           jellyY -=1;
         }
         
      }*/
     
   
    image( img, 0, 0, (jellyX*addX), (jellyY*addY)); 
    image( img2, 0, 55, (jellyX*addX), 75); 
    popMatrix();
  }
  
  boolean is_moving(){
    return vel.mag() > move_mag;
  }
  void shove(){
    vel.normalize();
    vel.mult( random(maxspeed/2, maxspeed));
  }
}
