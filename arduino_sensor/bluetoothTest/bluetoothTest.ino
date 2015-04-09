int cnt = 0;
int readJoystick_X = 0,readJoystick_Y = 0;

void setup() {
  Serial.begin(19200);
  Serial1.begin(9600);
}

void loop() {
  readJoystick_X = analogRead(0)/4;
  readJoystick_Y = analogRead(1)/4;
  Serial.print(readJoystick_X);
  Serial.print("\t");
  Serial.println(readJoystick_Y);
  readJoystick_X=readJoystick_X-127;
  readJoystick_Y=readJoystick_Y-127;
  
  Serial1.write(254);//start
  Serial1.write(9);//length
  Serial1.write(1);//mode
  Serial1.write(0);//pitch+-
  Serial1.write(cnt);//pitch
  
  if(readJoystick_X>=0)  Serial1.write(0);//roll+-}
  else{
    Serial1.write(1);//roll+-
    readJoystick_X=-readJoystick_X;
  }
  Serial1.write(readJoystick_X);//roll
  
  if(readJoystick_Y>=0)  Serial1.write(0);//yaw+-}
  else{
    Serial1.write(1);//yaw+-
    readJoystick_Y=-readJoystick_Y;
  }
  Serial1.write(readJoystick_Y);//yaw
  Serial1.write(0);//motor[0]
  Serial1.write(0);//motor[1]
  Serial1.write(253);//end
  
  cnt++;
  cnt = cnt%80;
  //delay(1000);
}
