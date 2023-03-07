// Si hay algún par de círculos rotando actualmente

boolean cur_rotating = false;

int circleId1;
int circleId2;

// Numero de circulos a dibujar

int num_circles = 12;

// Se inicializan los colores

float [][] colors = new float[num_circles][];

int colorsIterator = 0;

// Se crea la lista donde se guardaran los circulos

ArrayList <CircleItem> items = new ArrayList <CircleItem> ();

// Numero de pasos para dar la vuelta para cada par de circulos

int steps = 10;

void setup() {
  
  size(800, 800, P2D);
  
  for (int i=0; i<num_circles; i++) {
    colors[i] = new float[] {int(random(0, 256)), int(random(0, 256)), int(random(0, 256))};
  }
  
  for(int i=0; i < 360 ; i+= int(360 / num_circles)){
        
    int xPos = int(200*cos(i*(PI/180)));
    int yPos = int(200*sin(i*(PI/180)));
    CircleItem ci = new CircleItem(xPos, yPos, colors[(colorsIterator)%colors.length]);
    colorsIterator++;
    
  }
  
  frameRate(1);

}

void draw() {
  
  background(0);
  
  translate(width/2, height/2);
  
  if (cur_rotating == false){
    
    println("Cambio");
    
    circleId1 = int(random(0, num_circles));    
    circleId2 = int(random(0, num_circles));
    
    //circleId1 = 0;
    //circleId2 = 1;
    
    while (circleId2 == circleId1){
      
      circleId2 = int(random(0, num_circles));
      
    }
    
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    circle1.setFinal(circle2.xPos, circle2.yPos, circle2.c);
    circle2.setFinal(circle1.xPos, circle1.yPos, circle1.c);
    
    println("Pasa de esto", circle1.c[0], circle1.c[1], circle1.c[2], " a esto ", circle1.cEnd[0], circle1.cEnd[1], circle1.cEnd[2]);
    println("Pasa de esto", circle2.c[0], circle2.c[1], circle2.c[2], " a esto ", circle2.cEnd[0], circle2.cEnd[1], circle2.cEnd[2]);
    
    cur_rotating = true;
    
  }
  
  if (cur_rotating == true){
    
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    circle1.actualizaColor(circleId1);
    circle2.actualizaColor(circleId2);
    
    if (circle1.cCheck == false && circle2.cCheck == false){
      
      println(circleId1, "lo logro", circle1.cEnd[0], circle1.cEnd[1], circle1.cEnd[2]);
      println(circleId2, "lo logro", circle2.cEnd[0], circle2.cEnd[1], circle2.cEnd[2]);
      
      cur_rotating = false;
      
    }
    
  }
  
  for (CircleItem item : items){
    
    item.display();
    
  }
}

class CircleItem{
  
    // Posicion actual
  public int xPos = 0;
  public int yPos = 0;
  
  // Posicion inicial
  public int xPosInit = 0;
  public int yPosInit = 0;
  
  // Posicion final
  
  public int xPosEnd = 0;
  public int yPosEnd = 0;
  
  // Saltos
  
  public int saltoX = 0;
  public int saltoY = 0;
  public float saltoR = 0;
  public float saltoG = 0;
  public float saltoB = 0;
  
  // Colores
  
  private float[] c;
  private float[] cInit;
  private float[] cEnd;
  
  // Comprobante si ya hizo la transicion a color
  
  public boolean cCheck = true;
  
  
  // Para dibujar cada circulo
  
  public CircleItem(int xPos, int yPos, float[] c){
    
    this.xPos = xPos;
    this.yPos = yPos;
    this.c = c;
    
    items.add(this);
    
  }
  
  public void display(){
        
    fill(this.c[0], this.c[1], this.c[2]);
    circle(this.xPos, this.yPos, 40);
    
  }
  
  public void setFinal(int xPos, int yPos, float[] new_c){
    
   //this.xPosEnd = xPos;
   //this.yPosEnd = yPos;
   this.cEnd = new_c.clone();
   
   this.cCheck = true;
   
   this.saltoR = (this.cEnd[0] - this.c[0]) / steps;
   this.saltoG = (this.cEnd[1] - this.c[1]) / steps;
   this.saltoB = (this.cEnd[2] - this.c[2]) / steps;   
   
  }
  
  public void actualizaColor(int id){
        
    if (this.c[0] != this.cEnd[0]){
      
      if (this.c[0] + this.saltoR > this.cEnd[0]) {
        this.c[0] = this.cEnd[0];
      }
      
      else {
        
        this.c[0] += this.saltoR;
        
      }
      
    }
    
    if (this.c[1] != this.cEnd[1]){
      
      if (this.c[1] + this.saltoG > this.cEnd[1]) {
        this.c[1] = this.cEnd[1];
      }
      
      else {
        
        this.c[1] += this.saltoG;
        
      }
      
    }
        
    if (this.c[0] == this.cEnd[0] && this.c[1] == this.cEnd[1] && this.c[2] == this.cEnd[2]){
      
      this.cCheck = false;
      
      this.saltoR = 0;
      this.saltoG = 0;
      this.saltoB = 0;
      
      //this.cEnd = this.c;
      
    }
    
  }
  
  // Calcula la pos de X y Y actuales
}
