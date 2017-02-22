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
float maximum = max(diff);
float minimum = min(diff);
int time = 0;
int pacer = 0;
boolean plot = true;
boolean circuit = false;
int release = 0;

void setup() {
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
  }
  
  size(1000,600);
  background(255);
}

void draw() {
  background(0);
  fill(255);
  textSize(12);
  textAlign(LEFT);

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
}

void plotA() {
  background(0);
  textAlign(RIGHT);
  text("Click to transition between visualizations!", width - 10, height - 5);
  text("The error at any given time is calculated from the difference between predicted and verified water levels.", width - 10, height - 20);
  text("The location of each bubble represents the water level at each measurement over the week.", width - 10, height - 35);
  text("The colors of each bubble are scaled so that the redder bubbles represent datapoints" , width - 10, height - 65);
  text("with large prediction errors and the greener bubbles represent datapoints with small prediction errors.", width - 10, height - 50);
  text("Visualization represents water levels over the course of a week in San Diego, CA.", width - 10, height - 80);

  textAlign(LEFT);
  stroke(color(0,0,255),100);
  fill(255);
  strokeWeight(3);
  line(mouseX,0,mouseX,height);
  int index = (numbers.length * mouseX)/1000;
  
  if(mouseX < (3*width)/4) {
    text("Date: " + date[index],mouseX + 5,20);
    text("Time: " + int(hour[index]) + ":" + int(min[index]), mouseX + 5, 35);
    text("Water Level: " + numbers[index] + " meters",mouseX + 5, 50);
  } else {
    text("Date: " + date[index],mouseX - 115,20);
    text("Time: " + int(hour[index]) + ":" + int(min[index]), mouseX -115, 35);
    text("Water Level: " + numbers[index] + " meters",mouseX -115, 50);
  }
  
  strokeWeight(1);
  for(int i = 0; i < numbers.length -1; i++) {
    stroke(lerpColor(color(0,128,0),color(255,0,0),diff[i]/.03));
    fill(lerpColor(color(0,128,0),color(255,0,0),diff[i]/.03));
    ellipse((i/1681f)*width, height*.75 - (numbers[i] * 200), 3, 3);  
  }
}

void plotC() {
  background(0);
  text("Click to transition between visualizations!", 20, height - 5);
  text("The error at any given time is calculated from the difference between predicted and verified water levels.", 20, height - 20);
  text("The size of each bubble represents the total error at a given time in the day.", 20, height - 35);
  text("The colors of each bubble are scaled so that the reddest bubble has the largest total error," ,20, height - 65);
  text("and the greenest bubble has the least total error at any given time.", 20, height - 50);
  text("Visualization represents total error in water level predictions over the course of each day in a week in San Diego, CA.", 20, height - 80);

  String[] fullDate = new String[7];
  float dayX = day[0];
  int a = 0;
  int[] transitionIndex = new int[8];
  
  transitionIndex[0] = 0;
  stroke(0);
  fill(255);
  textAlign(CENTER);
  textSize(40);
  text("Time: " + int(hour[time]) + ":" + int(min[time]), width/2, height/2);
  textAlign(LEFT);
  textSize(12);
  
   while(a < 7) {
    for(int i=0; i < numbers.length; i++) {
      if(dayX == day[i]) {
      } else {
        fullDate[a] = date[i-1];
        dayX = day[i];
        transitionIndex[a + 1] = i;
        //println("TI: " + transitionIndex[a]);
        a++;
      }
    }
  }

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
      //pressed = false;
      totalError[0] = 0;
      totalError[1] = 0;
      totalError[2] = 0;
      totalError[3] = 0;
      totalError[4] = 0;
      totalError[5] = 0;
      totalError[6] = 0;
    }

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
    //println("SIZE E: " + sizeE);
  }
}