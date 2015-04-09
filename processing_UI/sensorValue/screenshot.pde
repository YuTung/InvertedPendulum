import java.awt.Robot;
import java.awt.*;
import java.awt.image.*;

PImage screenShot;
int saveFrameCnt = 0;

void takeScreenShot()
{
    Rectangle screenRect = new Rectangle( frame.getLocation().x,frame.getLocation().y ,800 + 2*frame.getInsets().left,600 + frame.getInsets().top + frame.getInsets().bottom );

    try {
        BufferedImage screenBuffer = new Robot().createScreenCapture( screenRect );

        screenShot = new PImage( screenBuffer.getWidth(), screenBuffer.getHeight(), PConstants.ARGB );
        
        screenBuffer.getRGB( 0, 0, screenShot.width, screenShot.height, screenShot.pixels, 0, screenShot.width );
        screenShot.updatePixels();

    } catch ( AWTException e ) {
        e.printStackTrace();
    }
    
    
    ///
    saveFrameCnt++;
    screenShot.save("C:/Users/user/Desktop/sensorValue"+month+day+"-"+saveFrameCnt+".png");
    /*
    if(month<10&&day>10){
      screenShot.save("/Users/dora/Desktop/0"+month+day+"."+hr+"."+min+"-"+saveFrameCnt+".png");
    }else if(month<10&&day<=10){
      screenShot.save("/Users/dora/Desktop/"+month+"0"+day+"."+hr+"."+min+"-"+saveFrameCnt+".png");
    }else{
      screenShot.save("/Users/dora/Desktop/"+month+day+"."+hr+":"+"."+min+"-"+saveFrameCnt+".png");
    } 
   */   
}



