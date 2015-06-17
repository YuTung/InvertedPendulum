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
  size(800,510,OPENGL);
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
  pitch = yaw = 0;
}

void plotBackground(){  
  background(255,255,224);  //245,255,250
 // number
  int number = 9;
  for(int i = 0 ; i < 19 ; i ++){
   textSize(9);  fill(0);  text((number-i)*10,2,315+i*10); 
   textSize(9);  fill(255,97,0);  text((number-i)*20,782,315+i*10); 
  }
  
  //mode   
   textSize(20);  fill(255,97,0); 
   text(trim("mode: "),170,25);
   
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
  textSize(20);  fill(0,0,255);   text(trim("pitch:"),170,170);  
  textSize(20);  fill(255,97,0);  text(trim(", yaw:"),330,170);
    
  //vertical line for time
  stroke(0);
  for(int i = 0 ; i < 13 ; i ++){
    line(750-60*i, 400, 750-60*i, 390); 
  }

 //plot pitch,yaw 
   if( mouseX>=168 && mouseX<=218 && mouseY>=151 && mouseY<=174 ){ 
      noFill();  stroke(0);   rect(168,151,50,23);
   }else{
     if(plotPitch){
        noFill();  stroke(0,0,255);   rect(168,151,50,23);
      }
   }
   if( mouseX>=340 && mouseX<=385 && mouseY>=151 && mouseY<=174 ){
       noFill();  stroke(0);  rect(340,151,45,23);
   }else{
      if(plotYaw){
        noFill();  stroke(255,97,0);  rect(340,151,45,23);
      }
   }   
    
 
 //textBox
  textSize(13);  fill(0);  text("MESSAGE",172,80);
  noFill();  stroke(0);  rect(170,68,310,80);
  noFill();  stroke(0);  rect(170,68,75,15); 
 
 //opengl
    noFill();  stroke(0);   rect(500,5,290,290); 
}
void plotButton(){
 //exitButton
  if(mouseX >= 10 && mouseX <= 140 && mouseY >= 80 && mouseY <= 100){
    textSize(16);  fill(238,118,0);  text(" goodbye ",250,82);
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
   textSize(30);  fill(0,0,0);  text(trim("BALANCE"), 190 ,50); 
  }else if(mode == 2){
   textSize(30);  fill(0,0,0);  text(trim("XXX"), 190 ,50);
  }
  
 //sensor
  textSize(20);  fill(0,0,0);  text( pitch+"°" , 260 ,170);   
  textSize(20);  fill(0,0,0);  text( yaw   +"°" , 430 ,170);
}

void plotOpengl(){
  lights();  
  pushMatrix();
  
  translate(650, 150,0);
 
  rotateY(radians(0-yaw));
  rotate(radians(pitch));
  
  translate(0, 0,30);
  fill(0,0,255);     stroke(0);  
  translate(0, 50,0); drawCylinder(360, 25, 9); translate(0, -50,0); 
  fill(126,192,238); stroke(80);   box(8,100,8);
  
  translate(0, -25,-25);
  fill(126,192,238); stroke(80);   box(150,8,55);
  
  translate(0, 25,-35);
  fill(0,0,255);     stroke(0);  
  translate(0, 50,9); drawCylinder(360, 25, 9); translate(0, -50,0);
  fill(126,192,238); stroke(80);   box(8,100,8);
   
  popMatrix();
}

void drawCylinder(int sides, float r, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight );    
    }
    endShape(CLOSE);
    
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight );    
    }
    endShape(CLOSE);
    
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
        vertex( x, y, -halfHeight);    
    }
    endShape(CLOSE); 
    
} 

void plotActualtime(){
  min = minute(); sec = second() ;hr  = hour();
  textSize(20);  fill(0);  text(year+"/"+month+"/"+day,30,20);
  textSize(20);  fill(0);  
  if(hr<10) text("0"+hr+":",29,45);
   else     text(hr+":",29,45);
   
  if(min<10)text("0"+min+":",60,45);
   else     text(min+":",60,45);
  if(sec<10)text("0"+sec,90,45);
   else     text(sec,90,45);
  stroke(0); line(15,52,135,52); line(15,50,135,50);
  
  //runTime  
  int currentTime = sec + min*60;
  int runTime = currentTime - lastTime;
  if(mouseX >=25 && mouseX <= 83 && mouseY >=53 && mouseY <= 75){
    fill(250);  noStroke();  rect(25,53,58,25);
  }
  textSize(15);  fill(0);  text("runTime: "+runTime+" s",27,70);
  
}

void plotError(){
   //text box
 if(!portOpen){   
   textSize(25);  fill(0,0,0);  text(trim("STANDBY"), 190 ,50); 
   textSize(13);  fill(255,0,0);  text("ERROR: serial not connected. Please select port.",172,100);
 }
}
