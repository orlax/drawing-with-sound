/**
  * This sketch demonstrates how to use the BeatDetect object in FREQ_ENERGY mode.<br />
  * You can use <code>isKick</code>, <code>isSnare</code>, </code>isHat</code>, <code>isRange</code>, 
  * and <code>isOnset(int)</code> to track whatever kind of beats you are looking to track, they will report 
  * true or false based on the state of the analysis. To "tick" the analysis you must call <code>detect</code> 
  * with successive buffers of audio. You can do this inside of <code>draw</code>, but you are likely to miss some 
  * audio buffers if you do this. The sketch implements an <code>AudioListener</code> called <code>BeatListener</code> 
  * so that it can call <code>detect</code> on every buffer of audio processed by the system without repeating a buffer 
  * or missing one.
  * <p>
  * This sketch plays an entire song so it may be a little slow to load.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

float translationX,translationV,circleW;

float kickSize, snareSize, hatSize;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup()
{
  size(512, 620, P3D);
  
  minim = new Minim(this);
  
  song = minim.loadFile("song.mp3", 1024);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(50);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  
  translationX = 2;
  translationV = 0.7;
  circleW = 120;
}

void draw()
{
  fill(28,255,155,28);
  rect(0,0,width,height);
  
 
  
  fill(71,229,114);
  ellipse(width/2,height/2+180,circleW,12);
  circleW += translationV*3;
  

  fill(28,255,155);
  rect(0,height/4,width,300);
  rectMode(CORNER);

pushMatrix();

  translate(0,translationX);
  translationX += translationV;
  if(translationX > 10){translationV = -0.3;}
  if(translationX < -10){translationV = 0.7;}

  if ( beat.isKick() ) kickSize = 22;
  if ( beat.isSnare() ) snareSize = 22;
  if ( beat.isHat() ) hatSize = 22;

translate(width/2,height/2);
noStroke();
fill(255,190,28);
float radius=120;
int numPoints=30;
float angle=TWO_PI/(float)numPoints;
for(int i=0;i<numPoints;i++)
{
 int s = -i;
 if( i < numPoints/3){  ellipse(radius*sin(angle*i),radius*cos(angle*i),kickSize+s,kickSize+s); }
 else if( i < numPoints/3*2){  ellipse(radius*sin(angle*i),radius*cos(angle*i),snareSize+s/2,snareSize+s/2); }
 else {  ellipse(radius*sin(angle*i),radius*cos(angle*i),hatSize+s/3,hatSize+s/3); }
} 
popMatrix();
  kickSize = constrain(kickSize * 0.95, 5, 25);
  snareSize = constrain(snareSize * 0.95, 5, 25);
  hatSize = constrain(hatSize * 0.95, 5, 25);
  
}
