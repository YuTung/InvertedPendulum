
void printDebug(){
  Serial.print(SENSOR.pitch);  Serial.print("\t");
  Serial.print(CMD.pitch);  Serial.print("\t");
  Serial.print(PIDresult.pitch);  Serial.print("\t");
  /*
  Serial.print(SENSOR.yaw);  Serial.print("\t");
  Serial.print(CMD.yaw);  Serial.print("\t");
  Serial.print(PIDresult.yaw);  Serial.print("\t");
  */
  
  Serial.println(); 
}




