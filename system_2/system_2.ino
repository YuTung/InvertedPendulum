#include <stdint.h>
#include "bluetooth.h"
#include "define.h"
#include "PID_v1.h"

#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

#define DEBUG  // to print or not
#define BLUETOOTH //port 30

enum modeType{  BALANCE , RELAX  }MODETYPE;
struct pitchYaw{
  double pitch , yaw ;
}CMD,SENSOR,PIDresult;
uint8_t mode;

MPU6050 mpu;
PID PIDpitch( &SENSOR.pitch, &PIDresult.pitch, &CMD.pitch, PID_PITCH_P, PID_PITCH_I, PID_PITCH_D, 0);        
            // input,output,setpoint,PID,direction 
PID PIDyaw( &SENSOR.yaw, &PIDresult.yaw, &CMD.yaw, PID_YAW_P, PID_YAW_I, PID_YAW_D, 0);        
            // input,output,setpoint,PID,direction 
            
#define LED_PIN 13 // (Arduino is 13, Teensy is 11, Teensy++ is 6)

// MPU control/status vars
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]         quaternion container
VectorInt16 aa;         // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;     // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;    // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity;    // [x, y, z]            gravity vector
float euler[3];         // [psi, theta, phi]    Euler angle container
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector

// packet structure for InvenSense teapot demo
uint8_t teapotPacket[14] = { '$', 0x02, 0,0, 0,0, 0,0, 0,0, 0x00, 0x00, '\r', '\n' };

boolean printableGY86 = false;
float output1,output2,output3;

// ================================================================
// ===               INTERRUPT DETECTION ROUTINE                ===
// ================================================================

volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
  mpuInterrupt = true;
}
// ================================================================
// ===                      INITIAL SETUP                       ===
// ================================================================
void setup() {
  Serial.begin(115200);//debug  
  
  #ifdef BLUETOOTH
    Serial1.begin(9600);//bluetooth
  #endif
  // configure LED for output
  pinMode(LED_PIN, OUTPUT);

  
  //motor pin setup
  pinMode(PIN_MOTOR_L_1, OUTPUT);
  pinMode(PIN_MOTOR_L_2, OUTPUT);
  pinMode(PIN_MOTOR_R_3, OUTPUT);
  pinMode(PIN_MOTOR_R_4, OUTPUT);
  
  digitalWrite(PIN_MOTOR_L_1, 0);
  digitalWrite(PIN_MOTOR_L_2, 0);
  digitalWrite(PIN_MOTOR_R_3, 0);
  digitalWrite(PIN_MOTOR_R_4, 0);
  
  // pin setup
  pinMode(PIN_LED,OUTPUT);
  digitalWrite(PIN_LED,LOW);
 
  PIDpitch.SetMode(AUTOMATIC);
  
 //i2c setup for sensor join I2C bus (I2Cdev library doesn't do this automatically)
  #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
      Wire.begin();
      TWBR = 24; // 400kHz I2C clock (200kHz if CPU is 8MHz)
  #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
      Fastwire::setup(400, true);
  #endif
  
  sensorGY86Setup();
  
  mode= BALANCE;
}

void loop() {
  digitalWrite(PIN_LED,!digitalRead(PIN_LED));
  
  //get sensor value GY-86
   //pitch,roll,yaw
   sensorGY86get(); 
   if(printableGY86){
     printableGY86 = false;
     //outputSensorValue(output1,output2,output3);
     SENSOR.pitch = output2 * 180/M_PI; 
     SENSOR.yaw = output1 * 180/M_PI;
  }
   
  //command mode: BALANCE,RELAX
  switch(mode){
    case BALANCE://command = 0;
     CMD.pitch = 0;
     CMD.yaw = 0;
     break;
    case RELAX: //command = 70;  then  close motor output?
    
     break;
    
  }
  //control law
  PIDpitch.Compute();

  //motor output 
  if(PIDresult.pitch >= 0)
  { //forward
    analogWrite(PIN_MOTOR_L_2, 0);
    analogWrite(PIN_MOTOR_R_4, 0);
    analogWrite(PIN_MOTOR_L_1, PIDresult.pitch);
    analogWrite(PIN_MOTOR_R_3, PIDresult.pitch);
  }
  else
  { //backward
    analogWrite(PIN_MOTOR_L_1, 0);
    analogWrite(PIN_MOTOR_R_3, 0);
    analogWrite(PIN_MOTOR_L_2, abs(PIDresult.pitch));
    analogWrite(PIN_MOTOR_R_4, abs(PIDresult.pitch));
  };

  //bluetooth output
  #ifdef BLUETOOTH
    bluetoothSend(SENSOR.pitch,SENSOR.yaw,PIDresult.pitch);
  #endif
  
  //debug print
  #ifdef DEBUG
   printDebug();  
  #endif
}

