XML xml;
int size = 1681;
float[] numbers = new float[size];
float[] diff = new float[size];
float[] hour = new float[size];
float[] min = new float[size];
float[] day = new float[size];
float[] month = new float[size];
String[] date = new String[size];
float[] totalError = new float[7];
//float minimum = min(numbers);
float maximum = max(diff);
float minimum = min(diff);
int time = 0;
int pacer = 0;
//int dec = 0;
boolean plot = true;
boolean circuit = false;
int release = 0;

void setup() {
  //xml = loadXML("/Users/charleswhitten/Desktop/cwhitte1_fit2.xml");
  xml = loadXML("cwhitte1_fit2.xml");
  XML child = xml.getChild("observations");
  XML[] data = child.getChildren("wl");
  
  for(int i = 0; i < data.length; i++) {
    float v = data[i].getFloat("v");
    float s = data[i].getFloat("s");
    String line = data[i].getString("t");
    //println(line);
    numbers[i] = v;
    diff[i] = s;
    String[] tokens = line.split(" ");
    date[i] = tokens[0];
    String[] timeDetails = tokens[0].split("-");
    day[i] = float(timeDetails[2]);
    month[i] = float(timeDetails[1]);
    String[] time = tokens[1].split(":");
    hour[i] = float(time[0]);
    min[i] = float(time[1]);
    if(diff[i] > maximum) {
      maximum = diff[i];
    }
    //println(month[i]);
  }
  
  size(1000,600);
  background(255);
}

void draw() {
  background(0);
  fill(255);
  //rect(0,0,100,100);
  //plotA();
  if(mousePressed) {
    if(!circuit) {
      plot = !plot;
      circuit = !circuit;
    }
  }
  
  if(circuit) {
    release ++;
  }
  
  if(release > 15) {
    release = 0;
    circuit = false;
  }
  
  if(plot) {
    plotA();
  } else {
    plotC();
  }
  
  text("Click two transition between plots!", 10, 10);
  //plotD();
  //stroke(55);
//  line(0,height/2,width,height/2);
}

void plotA() {
  background(0);
 // stroke(255);
 // fill(255);
 
  //fill(0);
  //text(pos, mouseX, height - map(numbers[mouseMap],0,maximum,0,height));
  stroke(color(0,0,255),100);
  fill(255);
  strokeWeight(3);
  line(mouseX,0,mouseX,height);
  int index = (numbers.length * mouseX)/1000;
  if(mouseX < (3*width)/4) {
    text("Date: " + date[index],mouseX + 5,20);
    text("Time: " + int(hour[index]) + ":" + int(min[index]), mouseX + 5, 35);
    text("Water Level: " + numbers[index],mouseX + 5, 50);
  } else {
    text("Date: " + date[index],mouseX - 115,20);
    text("Time: " + int(hour[index]) + ":" + int(min[index]), mouseX -115, 35);
    text("Water Level: " + numbers[index],mouseX -115, 50);
  }
  
 
  strokeWeight(1);
  for(int i = 0; i < numbers.length -1; i++) {
    stroke(lerpColor(color(0,128,0),color(255,0,0),diff[i]/.03));
    fill(lerpColor(color(0,128,0),color(255,0,0),diff[i]/.03));
    ellipse((i/1681f)*width, height*.75 - (numbers[i] * 200), 3, 3);
    //strokeWeight(4);
    //line((i/1681f)*width, height*.75 - (numbers[i] * 200), ((i+1)/1681f)*width, height*.75 - (numbers[i+1] * 200));
    
  }
  
 // circuit = false;
  
}

void plotB() {
 //for(int a = 0
 fill(255);
  int mouseMap = floor(map(mouseX,0,width,0,numbers.length));
  String pos = "(" + mouseMap + ", " + numbers[mouseMap] + ")";
  text(pos, mouseX, height - map(numbers[mouseMap],0,maximum,0,height));
  //stroke(255,255,128,128);
  
  stroke(255);
  for(int i=0; i<numbers.length; i++) {
    //line(i*3,height,i*3,height-numbers[i]); 
    float x = map(i,0,numbers.length,0,width);
    float h = map(numbers[i],0,maximum,0,height);
    float c = map(numbers[i],0,maximum/2,0,255);
    colorMode(HSB);
    stroke(255,c,c);
    if(mouseMap == i) {
      stroke(255);
    }
    line(x,height,x,height-h);
  }
}

void plotC() {
  background(0);
  //float[] totalError = new float[7];
  String[] fullDate = new String[7];
  float dayX = day[0];
  int a = 0;
//  int b = 0;
//  int time = 0;
  boolean pressed = true;
  int[] transitionIndex = new int[8];
  
  transitionIndex[0] = 0;
  stroke(0);
  fill(255);
  text("Time: " + int(hour[time]) + ":" + int(min[time]), 20,20);
  
  //for(int a=0; a < totalError.length; a++) {
   while(a < 7) {
    for(int i=0; i < numbers.length; i++) {
      if(dayX == day[i]) { // && (timeMax < 100)) {
       // totalError[a] += diff[i];
        //timeMax++;
      } else {
        fullDate[a] = date[i-1];
        dayX = day[i];
        transitionIndex[a + 1] = i;
        //println("TI: " + transitionIndex[a]);
        a++;
      }
    }
  }
  
  /*if(mousePressed) {
    pressed = true;
  }*/
  
  if(pressed) {
    //while(time < 100) {
      totalError[0] += diff[transitionIndex[0] + time];
      totalError[1] += diff[transitionIndex[1] + time];
      totalError[2] += diff[transitionIndex[2] + time];
      totalError[3] += diff[transitionIndex[3] + time];
      totalError[4] += diff[transitionIndex[4] + time];
      totalError[5] += diff[transitionIndex[5] + time];
      totalError[6] += diff[transitionIndex[6] + time];
      if(time < 240 && (pacer<=10)) { 
        pacer++;
        println("pacer: " + pacer);
      } else if(time < 240 && (pacer > 10)) {
        time++;
        pacer = 0;
        //circuit = false;
      }
      else { 
        time = 0;
        pressed = false;
        totalError[0] = 0;
        totalError[1] = 0;
        totalError[2] = 0;
        totalError[3] = 0;
        totalError[4] = 0;
        totalError[5] = 0;
        totalError[6] = 0;
      }
    }
      //time++;
   // }
  
  /*  for(int l=0; l < 7; l++) {
      for(int m=0; m<time; m++) {
         totalError[l] += diff[transitionIndex[l] + m];
         println("Total Error: " + l + " " + totalError[l]);
      }
    }
  } */
  
  /*
  println("------------------------------------------------------");
  println("Total Error for " + fullDate[0] + ":" + totalError[0]);
  println("Total Error for " + fullDate[1] + ":" + totalError[1]);
  println("Total Error for " + fullDate[2] + ":" + totalError[2]);
  println("Total Error for " + fullDate[3] + ":" + totalError[3]);
  println("Total Error for " + fullDate[4] + ":" + totalError[4]);
  println("Total Error for " + fullDate[5] + ":" + totalError[5]);
  println("Total Error for " + fullDate[6] + ":" + totalError[6]);
  println("Min :" + min(totalError));
  println("Max :" + max(totalError));
  */
  //println("Total Error for 7: " + totalError[4]);
  
  float spacing = (width-100)/7;
  
  for(int g=0;g<7;g++) {
    float sizeE = totalError[g] * 5;
    float y = 0;
    if(g%2 == 0) { y = height/4; }
    else { y = (height/4) * 3; }
    float scale = ((totalError[g] - min(totalError)) / (max(totalError)-min(totalError)));
    //println("Scale: " + scale);
    fill(lerpColor(color(0,128,0),color(255,0,0),scale));
    ellipse(100 + g*spacing, y, sizeE, sizeE);
    fill(255);
    stroke(10);
    text("Date: " + fullDate[g],100 + g*spacing - 30, y-40);
    text("Total Error: " + totalError[g] + " meters", 60 + g*spacing - 30, y - 60);
    //text
    //println("SIZE E: " + sizeE);
  }
  
  //time++;
  //println("Time: " + time);
  
 // circuit = false;
  
}