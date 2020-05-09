const int analogPin = A0;
int counter = 0;
int h_v = 8;
int l_v = 12;
const float pi = 3.14159267;
float ff = 0.0;
int p13 = 13;
int inc = 1;

void setup() {
  //Setup serial connection
  Serial.begin(9600); 
  pinMode(h_v, OUTPUT);
  pinMode(l_v, OUTPUT);
  pinMode(p13, OUTPUT);
}
 
void loop() {
  //generateSineWave();
  generateSquareWave();

  digitalWrite(h_v, HIGH);
  digitalWrite(l_v, LOW);
  float val = analogRead(analogPin);
  Serial.write((int) val);
  //Serial.println(val);
}


void serialDoubleWrite(double d) {
  byte * b = (byte *) &d;
  //Serial.print("d:");
  Serial.write(b,4);
  
}

void generateSquareWave(){
  if(counter > 800){
    
    digitalWrite(p13, LOW);
    if(counter > 1600){
      counter = 0;
    }
  }else{
    digitalWrite(p13, HIGH);
  }

  counter++;
}

void generateSineWave(){
   Serial.write((int)sin(ff) * 100);
   ff += 0.1;
}


