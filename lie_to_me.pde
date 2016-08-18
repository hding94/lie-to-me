import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
//import ddf.minim.*;
import processing.sound.*;
import netP5.*;
import oscP5.*;
Capture video;
OpenCV opencv;
Rectangle[] Trackfaces;
//sound
//Minim minim;
//AudioInput input;
//AudioRecorder recorder;
SoundFile sound0, sound1, sound2, sound3, sound4, sound5;
Amplitude analyzer;
WhiteNoise noise;
//pd
OscP5 oscP5;
NetAddress puredata;
PFont font;
int pro = -1; //use pro to record the steps of whole process
//!!!!!!!!!!!!!!!!!!!!!CHANGE THE FACANUM HERE
int faceNum = 107 ;
PImage[] faces;
PImage space;
PImage backgroundImage;
PImage backgroundReplace;
float threshold = 20;
float volume = 0.0;
int ran, loc, Loc;
int countname = 7, filename = 6;
int intospace = 0;
String soundfile = "sound/"+filename + ".wav", test = "01.mp3";
float vol;
float amp, speed;
color c;
float r, g, b, dis, ti, distance, midx, midy, random, locx;//
boolean name = false;
String myName = "Greeting! What's your name?", Name = "";
void setup() {
  //video and text
  background(0);
  font = createFont("Arial", 38);
  //size(1280, 720);
  fullScreen();
  println(width);
  println(height);
  //face tracking
  opencv = new OpenCV(this, 1280, 720);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  space = loadImage("space.png");
  video = new Capture(this, 1280, 720);
  video.start();
  //sound
  //minim = new Minim(this);
  //input = minim.getLineIn(Minim.STEREO, 2048);
  //pd
  noise = new WhiteNoise(this);
  oscP5 = new OscP5(this, 12000);
  puredata = new NetAddress("127.0.0.1", 8000); // PureData addressstroke(0);
  stroke(0);
  rectMode(CENTER);
}
void captureEvent(Capture video) {
  video.read();
}
void keyPressed() {
  if (name&&pro>-1) {
    if (key == 'y') { //press y to go to cyber space
      //print("key y pressed");
      if (intospace == 0) {
        intospace++;
        backgroundImage = createImage(video.width, video.height, RGB);
        backgroundReplace = loadImage("face/"+(faceNum-2)+".png");
        println("IMPORTANT"+(faceNum-2));
      }
    } else if (key == 'r') { //press r to record
      //print("key r pressed");
      if (pro == 0) { 
        pro ++;
        sendPD();
      }
    } else if (key == 's') { // stop the recoding
      //print("key s pressed");
      println("pro1 ==" + pro);
      if (pro == 1) {
        save("data/face/" + faceNum + ".png");
        faceNum++;
        sendPD();
        faces = new PImage[faceNum];
        for (int i = 0; i<faces.length; i++) {
          faces[i] = loadImage("data/face/"+ i +".png");
        }
        pro++;
        println("pro ==" + pro);

      }
    }
  } else if (!name&&pro == -1&&keyCode!= SHIFT) {
    if (keyCode == ENTER) {
      pro = 0;
      name = true;
      println("ENTER");
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
      Name = Name + key;
    } else if (keyCode == BACKSPACE) {
      if (Name.length() > 0) {
        Name = Name.substring(0, Name.length()-1);
      }
    } else if (keyCode == DELETE) {
      Name = "";
    }
  }
}

void mouseMoved() {
}

void mouseClicked() {
  if (intospace ==1) {
    intospace = 2;
    noise.play();
  } else if (intospace ==2) {
    pro = -1; //reset the whole process
    intospace = 0;
    //frameRate(30);
    //if(intospace!=0){
    sendPD();
    myName = "Greeting! What's your name?";
    noise.stop();
    name = false;

    Name = "";
  }
}
void draw() {
  if (!name&&pro == -1) {
    background(0);
    textAlign(CENTER);
    textFont(font, 52);
    text("This is about Internet identity", width/2, height/2-100);
    textFont(font, 40);
    text(myName, width/2, height/2);
    textFont(font, 30);
    text("please type it", width/2, height/2+50);
    textFont(font, 40);
    text(Name, width/2, height/2+120);
  } else if (pro == 0 || pro ==1) {
    textFont(font, 38);

    //face shield when speacks
    if (pro == 1) {

      //rect(60,60,60,60);
      //video.loadPixels();
      opencv.loadImage(video);
      Trackfaces = opencv.detect();
      faceshiled();
      image(video, 0, 48);
    } else if (pro == 0) {
      image(video, 0, 48);
      fill(0);
      rect(width/2, height/2+40, 480, 30);
      fill(255);
      textAlign(CENTER);
      textFont(font, 30);
      text("press 'r' to record and 's' to stop", width/2, height/2+50  );
      textFont(font, 40);
      text("Please first introduce yourself.", width/2, height/2-70);
      text("And then tell me a lie.", width/2, height/2);
    }
  } else if (pro == 2) {
    if (intospace == 0) {
      //image(faces[faceNum-1], 0, 0,width,height);
      fill(0);
      rect(width/2, height/2-15, 350, 35);
      rect(width/2, height/2-110, 650, 40);
      fill(255);
      textAlign(CENTER);
      text("Are you ready to go the cyber world?", width/2, height/2-100);
      text("Press y to get in", width/2, height/2);
    } else if (intospace == 1) {
      //manipulating sound

      lastface();
      image(video, 0, 0);
      fill(0);
      rect(width/2+100, 10, 600, 30);
      textFont(font, 30);
      fill(255);
      text("Try to move the mouse", width/2, 20);
    } else if (intospace == 2) {
      image(faces[faceNum-1], 0, 0);
      delay(50);
      ran = int(random(faceNum-1));
      image(faces[ran], 0, 0, width, height);
      delay(50);
      amp = map(mouseY, 0, height, 0.02, 0.1);
      noise.amp(amp);
      textAlign(CENTER);
      text("Who do you think you are now?", width/2, height/2+100);
    }
  }
  if (name) {
    textAlign(LEFT);
    textFont(font, 40);
    text(Name, 5, 50);
  }
}