//plot
int[] quad_pitch = new int[750];
int[] quad_yaw = new int[750];
boolean stopORrunPlot = false;
int front,rear,right,left;//show int o n slider

int day = day() , month = month(), year = year();
int min , sec  ,hr ;

boolean plotPitch = true , plotYaw = true;

void plotInitial(){ // in setup
  //plot
  size(800,600,OPENGL);
  frame.setLocation(20,0);
  frame.setTitle("InvertedPendulum");
  fonty = createFont("Arial",18);
  smooth();
  hint(ENABLE_STROKE_PURE);
  textFont(fonty,100);
  
  for(int i = 0 ; i < 600; i ++){
    quad_pitch[i] = 0;
    quad_yaw[i] = 0;
  }
  mode = 0;
  pitch = 0;
  sensorTimeout = 0;
  motor[0] = motor[1] = motor[2] = motor[3] = 90;
}

void plotBackground(){  
  background(245,255,250);  
 // number
  int number = 9;
  for(int i = 0 ; i < 19 ; i ++){
   textSize(9);  fill(0);  text((number-i)*10,2,315+i*10); 
   textSize(9);  fill(255,97,0);  text((number-i)*20,782,315+i*10); 
  }
  
  //mode   
   textSize(20);  fill(255,97,0); 
   text(trim("mode: "),300,25);
   
 // sensor used
  noFill();    stroke(0);
  rect(0,300,20,200);
  rect(800,300,-20,200);
  noFill();   stroke(0);
  rect(0,300,width,200);
  for (int i = 1 ;i<20;i++) { //grid     
    stroke(200); // gray
    line(20, 300+10*i, 780, 300+10*i);
  }
  stroke(250,0,0);//red
  line(20, 400, 780, 400);// center 
  textSize(20);  fill(0,0,255);   text(trim("pitch:"),10,520);  
  textSize(20);  fill(255,97,0);  text(trim(", yaw:"),200,520);
  textSize(13);  fill(255,20,147);text(trim("sensorError:"),625,490);
    
  //vertical line for time
  stroke(0);
  for(int i = 0 ; i < 13 ; i ++){
    line(750-60*i, 400, 750-60*i, 390); 
  }

 //plot pitch,yaw 
   if( mouseX>=8 && mouseX<=58 && mouseY>=503 && mouseY<=526 ){ 
      noFill();  stroke(0);   rect(8,503,50,23);
   }else{
     if(plotPitch){
        noFill();  stroke(0,0,255);   rect(8,503,50,23);
      }
   }
   if( mouseX>=210 && mouseX<=255 && mouseY>=503 && mouseY<=526 ){
       noFill();  stroke(0);  rect(210,503,45,23);
   }else{
      if(plotYaw){
        noFill();  stroke(255,97,0);  rect(210,503,45,23);
      }
   }   
    
 
 //textBox
  textSize(13);  fill(0);  text("MESSAGE",482,522);
  noFill();  stroke(0);  rect(480,510,310,80);
  noFill();  stroke(0);  rect(480,510,75,15); 
 
 //opengl
    noFill();  stroke(0);   rect(500,5,290,290); 
}
void plotButton(){
 //exitButton
  if(mouseX >= 10 && mouseX <= 110 && mouseY >= 80 && mouseY <= 100){
    textSize(16);  fill(238,118,0);  text(" goodbye ",600,526);
  }
  
  
 //stop or run plot sensor
  if(mouseX >= 730 && mouseX <= 770 && mouseY >=475 && mouseY <= 495 ){
   fill(0,245,255);  noStroke();    rect(730,475,40,20);
  }
  if(!stopORrunPlot) {
   fill(255,140,0);  noStroke();  rect(730,475,40,20);
   if(mouseX >= 730 && mouseX <= 770 && mouseY >=475 && mouseY <= 495 ){
     fill(205,102,0);  noStroke();  rect(730,475,40,20);   }
   textSize(13);  fill(0);  text(" STOP",730,490);
  }else{
   fill(144,238,144);  noStroke();  rect(730,475,40,20); 
   if(mouseX >= 730 && mouseX <= 770 && mouseY >=475 && mouseY <= 495 ){
     fill(0,200,0);  noStroke();  rect(730,475,40,20);   }
   textSize(13);  fill(0);  text(" RUN",730,490);
  }
}


void plotSensorData(){
 //pitch
  if(plotPitch){
    quad_pitch[quad_pitch.length-1] = pitch;
    noFill();
    stroke(0,0,255);
    beginShape();
      for(int i = 0; i<quad_pitch.length;i++)
        vertex(i,quad_pitch[i]+400);
    endShape();
  }else{
   for(int i = 0 ; i < 750 ; i ++)
    quad_pitch[i] = 0;
  }
  if(!stopORrunPlot){//false->run , true:stop
    for(int i = 1; i<quad_pitch.length;i++)
      quad_pitch[i-1] = quad_pitch[i]; 
  }
  //yaw  
  if(plotYaw){
    quad_yaw[quad_yaw.length-1] = yaw/2;//scaled    
    noFill();
    stroke(255,97,0);
    beginShape();
      for(int i = 0; i<quad_yaw.length;i++)
        vertex(i,quad_yaw[i]+400);
    endShape();
  }else{
   for(int i = 0 ; i < 750 ; i ++)
    quad_yaw[i] = 0;
  }
  if(!stopORrunPlot){//false->run , true:stop
    for(int i = 1; i<quad_yaw.length;i++)
      quad_yaw[i-1] = quad_yaw[i];  
  }
}

void plotText(){
 // mode
  if(mode == 1){
   textSize(30);  fill(0,0,0);  text(trim("BALANCE"), 320 ,50); 
  }else if(mode == 2){
   textSize(30);  fill(0,0,0);  text(trim("XXX"), 320 ,50);
  }
  
 //sensor
  textSize(20);  fill(0,0,0);  text( pitch+"°" , 70 ,520);   
  textSize(20);  fill(0,0,0);  text( yaw   +"°" , 260 ,520);
  textSize(14);  fill(255,20,147);  text( sensorTimeout , 710 ,490); 

}

void plotOpengl(){
  lights();  
  pushMatrix();
  translate(650, 150);
  
  
  rotate(radians(0-pitch));
  //rotateX(radians(0-yaw));
  
  //translate(0,20,0);
  fill(0,0,255);     stroke(0);    ellipse(0,80,50,50);  
  fill(126,192,238); stroke(80);   box(8,180,1);
  /*fill(126,192,238); stroke(80);
  box(8,200,8);
  fill(78,238,148); stroke(80);
  box(200,8,8);
  //direction
  fill(255,215,0); noStroke();
  translate(0,0,5);
  beginShape(TRIANGLES);
  vertex(0,-25);    vertex(-15,-5);  vertex(15,-5);
  endShape(CLOSE);
  beginShape(QUADS);
  vertex(-15,-5);    vertex(-15,15);  vertex(15,15);  vertex(15,-5);
  endShape(CLOSE);
  //arrow for direction
  stroke(0);
  line(0,-15,-10,-5);  line(0,-15,10,-5);
  //+- pitch,roll
  translate(0, -100);
  fill(0,0,255);  stroke(0,0,255);   ellipse(0,0,40,40);//pitch+
  stroke(255);    line(0,15,0,-15);  line(15,0,-15,0);
  translate(100, 100);
  fill(0,140,50); stroke(0,140,50);  ellipse(0,0,40,40);//roll+
  stroke(255);    line(0,15,0,-15);  line(15,0,-15,0);
  translate(-100, 100);
  fill(0,0,255);  stroke(0,0,255);   ellipse(0,0,40,40);//pitch-
  stroke(255);    line(15,0,-15,0);
  translate(-100, -100);
  fill(0,140,50); stroke(0,140,50);  ellipse(0,0,40,40);//roll-
  stroke(255);    line(15,0,-15,0);
  */
  
  popMatrix();
}

void plotActualtime(){
  min = minute(); sec = second() ;hr  = hour();
  textSize(20);  fill(0);  text(year+"/"+month+"/"+day,10,20);
  textSize(20);  fill(0);  
  if(hr<10) text("0"+hr+":",9,45);
   else     text(hr+":",9,45);
  if(min<10)text("0"+min+":",40,45);
   else     text(min+":",40,45);
  if(sec<10)text("0"+sec,70,45);
   else     text(sec,70,45);
  stroke(0); line(5,52,100,52); line(5,50,100,50);
  
  //runTime  
  int currentTime = sec + min*60;
  int runTime = currentTime - lastTime;
  if(mouseX >=5 && mouseX <= 70 && mouseY >=53 && mouseY <= 75){
    fill(220);  noStroke();  rect(5,53,65,25);
  }
  textSize(15);  fill(0);  text("runTime: "+runTime+" s",7,70);
  
}

void plotError(){
   //text box
 /* if(pitch == 0 && roll == 0 ){   BTbreak++;
   if(BTbreak > 10){     BTbreak = 0;     portOpen = false;   }
 }else portOpen = true; */
 if(!portOpen){   
   textSize(25);  fill(0,0,0);  text(trim("STANDBY"), 320 ,50); 
   textSize(13);  fill(255,0,0);  text("ERROR: serial not connected. Please select port.",482,542);
 }
}
