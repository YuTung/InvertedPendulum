void buttonReset(){
  fill(255,0,0);  noStroke();  rect(10,180,100,30);
  if(portOpen == true){
    port.stop();
  }
  initialVariables();  
  setup();    
}
void resetTime(){
  lastTime = second()+minute()*60;
}

int mouseList = 0;
void mousePressed(){
 //plot pitch roll yaw
 if( mouseX>=8 && mouseX<=58 && mouseY>=503 && mouseY<=526 ){//pitch
   plotPitch =! plotPitch;
 }
 if( mouseX>=108 && mouseX<=148 && mouseY>=503 && mouseY<=526 ){
   plotRoll =! plotRoll;
 }
 if( mouseX>=210 && mouseX<=255 && mouseY>=503 && mouseY<=526 ){
   plotYaw =! plotYaw;
 } 
 
 // reset runTime
 if(mouseX >=5 && mouseX <= 70 && mouseY >=53 && mouseY <= 88){
   resetTime();
 }

 //stop or run plot sensor
  if(mouseX >= 730 && mouseX <= 770 && mouseY >=475 && mouseY <= 495 ){
     stopORrunPlot =! stopORrunPlot;
  }
}
