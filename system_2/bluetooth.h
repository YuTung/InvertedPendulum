#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include <Arduino.h>
#include <stdint.h>

void bluetoothSend(double pitch,double yaw,double pidResult){
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



#endif