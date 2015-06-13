void initialVariables(){
  for(int i = 0 ; i < 30 ; i ++)  val[i] = 0;
  readCount = 0 ; portNumber = 0;
  finish = false ;
  portOpen = false;
  BTbreak = 0;
  //for(int i = 0 ; i < 10 ; i ++)  list[i] = " ";
  
  //decode BT
  mode = 0; pitch = 0; yaw = 0;
  
  //send BT
  for(int i = 0 ; i < 30 ; i ++)  sendBT[i] = 0;
  
  //read BT
  for(int i = 0 ; i < 3 ; i ++) {
    PID_P[i] = 0;
    PID_I[i]  = 0;
    PID_D[i]  = 0;
  }
  
  //plot
  for(int i = 0 ; i < 750 ; i ++){
    quad_pitch[i] = 0;
    quad_yaw[i] = 0;
  }
  stopORrunPlot = false;
  saveFrameCnt = 0;
  
  //time
  lastTime = 0;;
  
  //button
  serialButton = false;  

}
