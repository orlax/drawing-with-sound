import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in; 
FFT fft;

int midX,midY,min;
float size;
PImage buho,back;

float rotation = 0;

int init,target,lastTarget,current;

void setup(){
  size(700,700);
  
  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(),in.sampleRate());
  
  buho = loadImage("buho.png");
  back = loadImage("flickr.jpg");
  
  midX = width/2;
  midY = height/2;
  min = 120;
  
  init = 50;
  current =init;
  target = current;
}
void draw(){
  imageMode(CORNER);
  image(back,0,0,width,height);
  rectMode(CENTER);
  
   
  int limit =60;
  int boxWidth = width/limit;
  int var = fft.specSize()/limit;
  
  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( in.mix );
  fft.linAverages(limit);
  
  noFill();
  strokeWeight(2);
  stroke(255);
  
  pushMatrix();
  translate(width/2,height/2);
  for(int i = 0; i<limit;i++){
   //ellipse(midX,midY,min + fft.getBand(var*i)*2,min + fft.getBand(var*i)*2);
   // print(fft.getBand(var*i)*2 +" --- ");
   
   float radian = radians(rotation);
   int limiti = 70;
   rotate(radian);
   float limitia = limiti+fft.getBand(var*i)*2;
   if(limitia < -40){limitia = -40;}
   
   //float limitia = fft.getBand(var*i)*3;
   //if(limitia > 80){limitia = 80;}
   
   //rectMode(CENTER);
   //rect(0,limiti,1,limitia);
   
   line(0,limiti,0,limitia);
   //rotation += fft.getBand(var*i)*25;
   rotation += 0.002;
   //rotation += 360/limit;
  }
  popMatrix();
  //rotation -= 0.01;
   
  noStroke();
  fill(255);
  ellipse(midX,midY,min,min);
  imageMode(CENTER);
  image(buho,midX,midY+5,min-30,min-40);
  
  
 
}
