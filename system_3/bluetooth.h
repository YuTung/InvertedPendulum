#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include <Arduino.h>
#include <stdint.h>

void bluetoothToProcessing(double pitch,double yaw,double pidResult){
 Serial1.write(90);
 //length
 Serial1.write(7);
 //mode
 Serial1.write(1);//balance
 //pitch
 if(pitch>=0){
   Serial1.write(0); 
   Serial1.write((int)pitch); 
 }else{
   Serial1.write(1); 
   Serial1.write((int)-pitch); 
 }

 //yaw
  if(yaw>=0){
   Serial1.write(0); 
   Serial1.write((int)yaw); 
 }else{
   Serial1.write(1); 
   Serial1.write((int)-yaw); 
 }
 //direction & pid result
  if(pidResult>=0){
    Serial1.write(0);
    Serial1.write((int)pidResult); 
  }else{
    Serial1.write(1);
    Serial1.write((int)-pidResult); 
  }
 
 
 Serial1.write(165);
}

boolean bluetoothFromMobile(double *pitch, double *yaw){
  byte input = 0;
  boolean isBalance = true;
  
  while(Serial1.available()>0){
    input = Serial1.read();
    
    switch(input){
     case 50://left
       *yaw = *yaw - 0.5;
       if(*yaw<-180)
         *yaw = *yaw+360;
       break;
     case 60://go
       *pitch = *pitch + 0.5;
       if(*pitch>5.0) *pitch = 5.0;
       break;
     case 70://right
       *yaw = *yaw + 0.5;
       if(*yaw>180)
         *yaw = *yaw-360;
       break;
     case 80://back
       *pitch = *pitch - 0.5;
       if(*pitch<-5.0) *pitch = -5.0;
       break;
     case 90://back
       *pitch = 0.0;
       break;  
       
     case 100://motor close
       isBalance = false;
       break; 
     case 110://balance
       break;  
    }
  }//while

  return isBalance;  
}


#endif
