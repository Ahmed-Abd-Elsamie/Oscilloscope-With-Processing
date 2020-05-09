import processing.serial.*;
import controlP5.*;
ControlP5 cp5;

Serial port;
int values[];
int val;
float zoom;
int shift = 0;
int dev = 25;
int panelWidth = 500;
int panelHight = 500;
float vd = 1.0f;
float vdi = 1.0f;
PFont font;

void setup(){

  size(700, 500);
  cp5 = new ControlP5(this);
  values = new int[panelWidth];
  port = new Serial(this, Serial.list()[0],9600);
  zoom = 1.0f;
  smooth();
  font = createFont("calibri", 30);
  
  drawControls();
  
}

int getSerialValue(){
  int value = -1;
  while(port.available() >= 3){
    /*if(port.read() == 0xff){
      value = (port.read() << 8 | port.read());
    }
    */
    value = port.read();
    println(value);
  }
  return value;
}


void drawCenterLine(){
  stroke(0,255,0);
  //int c = - (panelWidth/2)/dev;
  for(int i = 0; i < panelHight; i+=dev){
    line(0, i, panelWidth, i);
    line(i, 0, i, panelHight);
    //text(c, (panelWidth/2), i);
    //c++;
    
  }
  stroke(255,0,0);
  line(0, panelHight/2, panelWidth, panelHight/2);
  line(panelWidth/2, 0, panelWidth/2, panelHight);
  
}

void pushToArray(int v){
  for(int i = 0; i < values.length-1; i++){
    values[i] = values[i+1];
  }
  values[values.length-1] = v;
}

int getYAxisValue(int v){
  //int Y = shift + v - panelHight/2;
  int Y = (int)(((int)(panelHight - v / 1023.0f * (panelHight - 1)) + shift - panelHight/2) * vd);
  //println(v);
  return Y;
}

void drawGraph(){
  stroke(255);
  int dw = (int)(panelWidth / zoom);
  int z = values.length - dw;
  int x0 = 0;
  int y0 = getYAxisValue(values[z]);
  
  for(int i = 1; i < dw; i++){
    z++;
    int x1 = (int)(i * (panelWidth-1) / (dw-1));
    int y1 = getYAxisValue(values[z]);
    line(x0, y0, x1, y1);
    x0 = x1;
    y0 = y1;
  }
  
  
}

void keyReleased(){
    switch (key) {
    case '+':
      zoom *= 2.0f;
      println(zoom);
      if ( (int) (panelWidth / zoom) <= 1 )
        zoom /= 2.0f;
      break;
    case '-':
      zoom /= 2.0f;
      if (zoom < 1.0f)
        zoom *= 2.0f;
      break;
    case '1':
      shift += 5;
      break;
    case '0':
      shift -= 5;
      break;
      
      case '2':
      dev += 5;
      break;
      
      case '3':
      dev -= 5;
      break;
  }
}

void drawControls(){
  
  cp5.addButton("zoomIn").setPosition(600, 50);
  cp5.addButton("zoomOut").setPosition(510, 50);
  
  cp5.addButton("shiftUp").setPosition(600, 80);
  cp5.addButton("shiftDown").setPosition(510, 80);
  
  cp5.addButton("devisionInc").setPosition(600, 110);
  cp5.addButton("devisionDec").setPosition(510, 110);
  
  
  cp5.addButton("VDI").setPosition(600, 140);
  cp5.addButton("VDD").setPosition(600, 170);
  
}
void VDI(){
  vd += 0.1;
  vdi -= 0.1;
}
void VDD(){
  vd -= 0.1;
  vdi += 0.1;
}

void zoomIn(){
  zoom *= 2.0f;
      println(zoom);
      if ( (int) (panelWidth / zoom) <= 1 )
        zoom /= 2.0f;
}

void zoomOut(){
  zoom /= 2.0f;
      if (zoom < 1.0f)
        zoom *= 2.0f;
}

void shiftUp(){
  shift -= 5;
}

void shiftDown(){
  shift += 5;
}

void devisionInc(){
  dev += 5;
}

void devisionDec(){
  if(dev <= 5){
    dev = 5;
  }else{
    dev -= 5;
  }
}


void draw(){
  background(0);
  drawCenterLine();
  
  val = getSerialValue();
  if(val != 1){
    pushToArray(val);
  }
  drawGraph();
  fill(0,0,255);
  //text("V / D " + vdi, 580 , 250);
}
