import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim; 
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

float kick,snare,hat;

int max,min;

int boxSize = 50;
float gridSize = 3;

float isoThetaX = -0.6154797;
float isoThetaY = 0.7853982;
float color1 = random(250,255);
float color2 = random(180,196);
float color3 = random(0,10);

void setup() {
    size(1280, 720, P3D);
    
    fill(255);
    lights();
    
    print(isoThetaY);
    
    max = 80;
    min = 16;
    
    minim = new Minim(this);
    song = minim.loadFile("record01.mp3");
    song.play();
    beat = new BeatDetect(song.bufferSize(),song.sampleRate());
    bl = new BeatListener(beat,song);
    kick = snare = hat = min;
    frameRate(24);
    
}

void draw() {
    //background(0);
    
    background(color1,color2,color3);
    
    color1 += random(-2,2);     color2 += random(-2,2);     color3 += random(-2,2);
    
    //directionalLight(255, 255, 255, 0, -49, 120);
    translate(width / 2, 480);
    
    rotateX(isoThetaX);
    rotateY(isoThetaY);
    
    if(beat.isKick())kick = max;
    if(beat.isSnare())snare = max;
    if(beat.isHat())hat = max;
    
    int margin = 20;
    
    for (int i = 0; i < gridSize; i++) {
        for (int j = 0; j < gridSize; j++) {
            pushMatrix();
            
            //lights();
            translate(boxSize * i -boxSize,0, boxSize * j-boxSize);
            
            
            if( i == 0 ) {
            if(j==0){ translate(0,-kick/8,0);
                      box(boxSize-margin,kick/4,boxSize-margin);}
            if(j==1){
                      translate(0,-kick/4,0);
                      box(boxSize-margin,kick/2,boxSize-margin);}
            if(j==2){
                      translate(0,-kick/2,0);
                      box(boxSize-margin,kick,boxSize-margin);}
            }
            fill(255);
            if( i == 1 ) {
            if(j==0){ translate(0,-snare/2,0);
                      box(boxSize-margin,snare,boxSize-margin);}
            if(j==1){ translate(0,-snare/4,0);
                      box(boxSize-margin,snare/2,boxSize-margin);}
            if(j==2){
                      translate(0,-snare/8,0);
                      box(boxSize-margin,snare/4,boxSize-margin);}
            
            }
            if( i == 2 ) {
            if(j==0){translate(0,-hat/8,0);box(boxSize-margin,hat/4,boxSize-margin);}
            if(j==1){translate(0,-hat/4,0);box(boxSize-margin,hat/2,boxSize-margin);}
            if(j==2){translate(0,-hat/2,0);box(boxSize-margin,hat,boxSize-margin);}
            }
            popMatrix();
        }
    }    
    kick = constrain(kick*0.90,min,max);
    hat = constrain(hat*0.90,min,max);
    snare = constrain(snare*0.90,min,max);
    
    isoThetaY += 0.01;
}

