int value = 0;
int change = 5;
float colorChange = 1;
float xPos = 224;
float yPos = 184-110;
float theta = 3*PI/2;
float anguloInicial = 0;
int color1 = 175;
int color2 = 111;
float xPos2 = 224;
float yPos2 = 184+110;
int circleid1 = 0;
int circleid2 = 1;
float centroX = 0;
float centroY = 0;
float radio = 0;
boolean c1 = false;
boolean c2 = false;
int [][] randomColors = new int[12][];

void setup() {
  size(640, 640);
  //noStroke();
  //noFill();
  hint(ENABLE_STROKE_PURE);
  for (int i=0; i<12; i++) {
    randomColors[i] = new int[] {int(random(0, 256)), int(random(0, 256)), int(random(0, 256))};
  }

}

void draw() {
  background(10);
  blendMode(ADD);
  for (int i = 0; i < 360; i = i+30) {
    fill(randomColors[i/30][0], randomColors[i/30][1], randomColors[i/30][2]);
    if (circleid1*30 == i && c1==false) {
      fill(57, color1, color2);
      xPos = 200*cos(i*(PI/180))+300;
      yPos = 200*sin(i*(PI/180))+300;
      circle(xPos, yPos, 30);

      //anguloInicial = i*(PI/180);
      c1 = true;
    }
    else if (circleid1*30 == i && c1==true) {
      fill(57, color1, color2);
      circle(xPos, yPos, 30);
    }
    else if (circleid2*30 == i && c2==false) {
      fill(57, color1, color2);
      xPos2 = 200*cos(i*(PI/180))+300;
      yPos2 = 200*sin(i*(PI/180))+300;
      circle(xPos2, yPos2, 30);
      
      c2 = true;
    }
    else if (circleid2*30 == i && c2==true) {
      fill(57, color1, color2);
      circle(xPos2, yPos2, 30);
    }
    else {
      circle(200*cos(i*(PI/180))+300, 200*sin(i*(PI/180))+300, 30);
    }
  }
  centroX = abs(xPos+xPos2)/2;
  centroY = abs(yPos+yPos2)/2;
  radio = dist(xPos, yPos, xPos2, yPos2)/2;

  noFill();
  
  //filter( DILATE );
  stroke(12, 13, 240, value);
  circle(centroX, centroY, radio*2);
  changeOpacity();
  
  noStroke();
  fill(57, color1, color2);
  //circle(xPos, yPos, 30);
  //circle(xPos2, yPos2, 30);
  changePos();
}

void changeOpacity() {
  value = value + change;
  if (value > 255 || value < 0) {
    change *= -1;
  }
  delay(5);
}

void changePos() {
  xPos = centroX - radio * cos(theta);
  yPos = centroY + radio * sin(theta);
  xPos2 = centroX + radio * cos(theta);
  yPos2 = centroY - radio * sin(theta);
  if (theta >= PI/2) {
    theta -= 2*PI/180;
    color1 -= colorChange;
    color2 += colorChange;
  }
  else {
    //delay(500);
    colorChange *= -1;
    theta = 3*PI/2;
  }
  delay(5);
}

void mouseClicked() {
  circleid1 = int(random(0, 12));
  circleid2 = int(random(0, 12));
  while (circleid1 == circleid2) {
    circleid1 = int(random(0, 12));
    circleid2 = int(random(0, 12));
  }
  c1 = false;
  c2 = false;
  redraw();
}
