DropdownList dropDownList_comPort;

void cp5Init(){
  PFont p = createFont("Times",12); 
  cp5.setControlFont(p);
  
  //choose serial
  listPort = port.list();
  dropDownList_comPort = cp5.addDropdownList("comPort",10,190,130,100).setBarHeight(20).setItemHeight(20).setColorBackground(color(0,255,255));
  dropDownList_comPort.captionLabel().toUpperCase(false);
  for(int i = 0 ; i < listPort.length ; i ++ ){
    dropDownList_comPort.addItem(listPort[i],i+1); 
  }
  
  //reset
  cp5.addButton("button_reset", 1, 10, 140, 130, 20).setColorBackground(color(0,250,0)).setCaptionLabel("resetProcessing");
  
  //exit
  cp5.addButton("button_exit", 1, 10, 80, 130, 20).setColorBackground(color(205,85,85)).setCaptionLabel("           EXIT UI");
  
  //save
  cp5.addButton("button_saveFrame", 1, 10, 110, 130, 20).setColorBackground(color(0,255,255)).setCaptionLabel("        saveFrame");
  
  
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) {     
    if(theEvent.controller().name()=="button_reset") {
      buttonReset();
    }
    if(theEvent.controller().name()=="button_exit") {
      if(serialButton == true){ 
         port.stop();
      }
      exit();
    }
    if(theEvent.controller().name()=="button_saveFrame") {
      takeScreenShot();
    }
    
    
  }else if(theEvent.isGroup()){//if controller
    if (theEvent.group().name() == "comPort") {
      if(!serialButton){
        portNumber = int(theEvent.group().value());      
        dropDownList_comPort.disableCollapse();
        //port = new Serial(this, Serial.list()[portNumber-1], 115200);
        mySerialOpen(portNumber-1);
        portOpen = true;
      }
    }
  
  }
}
