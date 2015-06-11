//serial port
Serial port; // The serial port object
int[] val = new int[30];
int readCount = 0 , portNumber = 0;
boolean finish = false ;
boolean portOpen = false;
int BTbreak = 0;
String[] listPort = new String[5];
//decode BT
int mode,pitch = 0,yaw = 0,sensorTimeout = 0;
int direction, pidValue;
//send BT
int[] sendBT = new int[30];
//read BT
int[] PID_P = new int[3];
int[] PID_I = new int[3];
int[] PID_D = new int[3];

void mySerialInitial(int portNum,int baudRate){
  //println(port.list()); // Use this to print connected serial devices
  port = new Serial(this, Serial.list()[portNum], baudRate); 
  port.bufferUntil('\n'); 
  resetTime();
  portOpen = true;
}

void mySerialOpen(int portNum){
  port = new Serial(this, Serial.list()[portNum], 9600); 
  port.bufferUntil('\n'); 
  portOpen = true;
  serialButton = true;
  resetTime();
}

int serialLength = 0;
void mySerialRead(){
 while(port.available()>0){
  val[readCount] = port.read();//faster than read string
  readCount++;
  finish = false;
  serialLength = val[1];
  
  if(serialLength>20)  serialLength = 0;//set bound , avoid array explode
  
  if(val[0]!=90){ //wrong start
    readCount = 0;
    for(int i = 0 ; i < 15; i ++) val[i] = 0;
  }  
  
  if(val[0] == 90 && val[serialLength+2]==165){
     if(serialLength == 7){
       for(int i = 1 ; i < serialLength+2 ; i ++)     print( val[i] + " " );
       println(); 
     }
     
     finish = true; 
     readCount = 0;  
     port.clear();
  }

  if(readCount>=20){
   readCount = 0;
   for(int i = 0 ; i < 15; i ++) val[i] = 0;
  }
 }//end while
 
 //decode BT from arduino
 if(finish == true){
   finish = false;
   if(serialLength == 7){
     mode          = val[2];
     pitch         = val[4];
     if(val[3]==1) pitch = -pitch;
     yaw           = val[6];
     if(val[5]==1) yaw = -yaw;
     direction      = val[7];     
     pidValue      = val[8];
     if(val[7]==1)  pidValue= -pidValue;
   }
   /*
   print(mode + " " + pitch + " " +yaw+ " ");
   println();
   //*/
   for(int i = 0 ; i < 15; i ++) val[i] = 0;
   readCount = 0;
 }  
}


static final int PROCESSING_CONNECT = 0 , READ_PID = 1 , SEND_PID = 2 , READY = 3 ;

void mySerialWrite(int i){
  switch(i){
    case PROCESSING_CONNECT:
   
      break;
    case READ_PID:
      port.write(254);
      port.write(1);
      port.write(255);
      port.write(253);     
      break;
    case SEND_PID:
      port.write(254);
      port.write(9);/*
      port.write(tempP[0]);
      port.write(tempI[0]);
      port.write(tempD[0]);
      port.write(tempP[1]);
      port.write(tempI[1]);
      port.write(tempD[1]);
      port.write(tempP[2]);
      port.write(tempI[2]);
      port.write(tempD[2]);*/
      port.write(253);     
      textSize(16);     
      fill(238,118,0);  text(" wait for Arduino ",600,526);
      break;
    case READY:
      break; 
    default: break;
  }
}
