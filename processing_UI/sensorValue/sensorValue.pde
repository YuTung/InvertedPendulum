//color  http://cloford.com/resources/colours/500col.htm
//0: pitch , 1: roll , 2: yaw

import processing.serial.*;
import java.awt.Frame; 
import processing.opengl.*;
import controlP5.*;

ControlP5 cp5;

PFont fonty;

//time
int lastTime;

boolean serialButton = false;

void setup() {
 plotInitial();  
 //mySerialInitial(5,9600);
  // 5 if wireless , 7 if wired
 resetTime();
 serialButton = false;
 portOpen = false;
 
 cp5 = new ControlP5(this);
 cp5Init();
}

void draw() {//tip: update every run
 // plot basic ground , fixed
 plotBackground();
 plotButton();
 
 //get serial bluetooth 
 if(portOpen){
   mySerialRead();
 }
 
 //plot data
 if(serialButton){
     plotSensorData();
     plotText(); 
 }
 
 //plot pitch roll image
  plotOpengl(); 
 
 //others
 plotError();
 plotActualtime();
   
}
