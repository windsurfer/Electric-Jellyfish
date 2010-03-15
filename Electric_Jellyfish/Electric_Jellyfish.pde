//Electric Jellyfish - an audio visualizer by Shaughn Perrozzino
//Simple Particle System by Daniel Shiffman- from Processing.org was the basis of the particle class
//Minin library http://code.compartmental.net/2007/03/27/minim-an-audio-library-for-processing/

import processing.opengl.*; 
import ddf.minim.*;
import ddf.minim.analysis.*;

//Audio
Minim minim;
AudioPlayer song;
AudioMetaData meta;//metadata container
String fileName;
String songName;
String artistName;
String albumName;
int trackNum;
float volume;
int songNum =1;
int numSongs =5;

//Beat detection
BeatDetect beat;
BeatListener bl; 

//Parrticle System
ParticleSystem bubbles;
ParticleSystem ps;

//Main
PImage backgroundA; 
int blendAlpha;

//Boids
int numBoids = 20;
ArrayList boids;
PFont verdanaFont;
PVector posVect;
boolean clicked;
PImage jellyTop;//Images for animation
PImage jellyBottom;//Images for animation
PImage bubbleParticle;//Particle!
PImage particle;

 void setup()
 {
  //size(640, 480, OPENGL);
  //size(screen.width, screen.height, OPENGL);
  size(screen.width-100, screen.height-100, OPENGL);//For testing purposes keeps it nicely sized
  frameRate(30);//Keep it reasonable
  
  colorMode(RGB, 255, 255, 255, 100);//RGB255wAlpha
  bubbleParticle =  loadImage("data/bubble.png");
  bubbles = new ParticleSystem(1, new PVector(width/2,height/2,0), bubbleParticle);  
  particle =  loadImage("data/particle.png");
  ps = new ParticleSystem(1, new PVector(width/2,height/2,0), particle);
  
  backgroundA = loadImage("data/gradientA.jpg");
  blendAlpha = 64;//For blending the background.
  
  //Fills/Drawing
  fill(0);
  noStroke();
  //smooth();//Makes stuff pretty//slows stuff down!
  
  //Boids Boids Boids  
  jellyTop = loadImage("data/jellyTop.png");
  jellyBottom = loadImage("data/jellyBottom.png");
  clicked = false;    
  boids = new ArrayList();
  
  for ( int i=0; i<numBoids; i++ )
  {
    addBoid();
  }
  
  //Beats
  minim = new Minim(this);
  addSong(songNum);  
  
  //Text Display
  textFont(createFont("Helvetica", 24));
}

void addSong( int songNum )
{ 
  song = minim.loadFile("song_"+songNum+".mp3");
  song.play();
  meta = song.getMetaData();
  fileName = meta.fileName();
  songName = meta.title(); 
  artistName = meta.author();
  albumName = meta.album(); 
  //trackNum = meta.track();  //Gets an error on songnumer/totalsongs in some ID3 tags// may fix later on
  println(fileName);
  
  beat = new BeatDetect( song.bufferSize(), song.sampleRate() ); 
  beat.setSensitivity(50);//100millis
  bl = new BeatListener( beat, song ); 
}

void keyReleased()
{
  //For switching songs
  if ( key == 'z' )
  {
    song.close();
    songNum = songNum - 1;

  if(songNum < 1)//Number of songs...
  {
    songNum = numSongs;//Loops around
    addSong( songNum );
  }else{
    addSong( songNum );
  }
  }
 
  if ( key == 'x' )
  {
    song.close();
    songNum = songNum + 1;
  if(songNum > numSongs)//Number of songs...
  {
    songNum = 1;
    addSong( songNum );
  }else{
    addSong( songNum );
  }
  }
}


void draw()
{ 
     //Audio
    volume = song.mix.level();//Grab volume
    println( volume );
    volume/=1.5;//Arbitrary number yay!
    volume+=1;//Makes it 1.X
     
    imageMode( CORNER );
    image(backgroundA, 0,0, screen.width,screen.height);
    fill(0,0,0, blendAlpha); //Half alpha, black square blending  
    //mouseValue = int( map(mouseY, 0, screen.height, 0, 255));   
    //fill(0,0,0, mouseValue); 
    rect(0,0, screen.width,screen.height);
    enableAdditiveBlending(true);
 
     //Text Display
     fill(255, 255, 255, 32); //Reset Fill
     text(songName + " - " + artistName + " - " + albumName, 10,(height-10));
     
     ps.run(pow(volume,4));//Can add volume in here if want     
     if ( beat.isSnare()){
       float rand = random(width);
       float rand2 = random(height);
       float rand3= random(10,20);
       for (int i=0; i < rand3; i++){
         ps.addParticle(rand,rand2);
       }
     }  
     
    //Bubbles
    bubbles.run(volume);//Can add volume in here if want     
    bubbles.addParticle(random(width),random(height)+100); 

  if ( beat.isKick()){
         println(" beat.isKick()");
           for ( int i=0; i<boids.size(); i++ )
           {
             Boid currBoid = (Boid) boids.get(i);
             //currBoid.run(volume, volume);//Volume is quite dramatic... 
             //Technically runs another Boid under the first, making them blend nicely. :D
             currBoid.run(1,1);//Add a boid at current location, size 1,1.
             //currBoid.shove();
           }
  }
  
  if ( beat.isHat()){
      println(" beat.isSnare()");
       //fill(255,255,255, 10);
       //rect(0,0, screen.width,screen.height);   //OMG FLICKER
       for ( int i=0; i<boids.size(); i++ )
           {
             Boid currBoid = (Boid) boids.get(i);
             currBoid.shove();
             bubbles.addParticle(currBoid.loc.x,currBoid.loc.y);
           }
   }

   //Boids Draw after background...
    posVect = new PVector(random(screen.width), random(screen.height));
    
     for ( int i=0; i<boids.size(); i++ )
     {
         Boid currBoid = (Boid) boids.get(i);
         currBoid.run(volume, volume); // Volume is multiplied by Boid X,Y
     }
}

void addBoid()
{
   float xPos = random( width );
   float yPos = random( height );
   boids.add( new Boid( new PVector( xPos, yPos ), jellyTop, jellyBottom ) );
}

void stop()
{
  // always close Minim audio classes when you are finished with them
  song.close();
  minim.stop();
  super.stop();
}
