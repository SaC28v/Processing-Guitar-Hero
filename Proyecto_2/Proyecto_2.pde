import ddf.minim.*;
import ddf.minim.analysis.*;

//--------OBJETOS-------//
Juego juego;
Boton[] botones;
ArrayList<Nota> notas;
EstadoJuego estadoActual;
 
//---------------------//
int botonesY;
int puntaje = 0;
float velocidad = 5;
int sonidoActual = -1;
int notasGeneradas = 0;
int[] CuerdasX = {100, 200, 300, 400};
int[] Duraciones = {156000, 156000, 57500, 150500, 181000, 156000, 63000, 107000};

//-------IMAGENES------//
PImage Play;
PImage FMenu;
PImage Titulo;
PImage Victoria;
PImage Tracklist;
PImage Canciones;
HashMap<String, PImage> Fondos; 

//-------AUDIOS--------//
Minim minim;
BeatDetect beat;
AudioPlayer CMenu;
AudioPlayer Derrota;
AudioPlayer[] pistas;
String[] Pistas = {"ASGORE", "Battle Against a True Hero", "Bonetrousle",
                     "Fallen Down", "Hopes and Dreams", "MEGALOVANIA", 
                     "Metal Crusher","Spider Dance"};
                     
                    
//-------------------------------------------------------------------------------------------------------------//
void setup() {
  size(500,700);
  background(0);
  rectMode(CENTER);
  imageMode(CENTER);

  //------------------CARGA DE IMAGENES------------------//
  FMenu = loadImage("Menu.jpg");
  Canciones = loadImage("Canciones.jpg");
  Titulo = loadImage("Titulo.png");
    Titulo.resize(400, 40);
  Play = loadImage("Play.png");
    Play.resize(150, 50);
  Tracklist = loadImage("Tracklist.png");
    Tracklist.resize(225,40);
  Victoria = loadImage("Victoria.jpg");
    
  Fondos = new HashMap<String, PImage>();
    Fondos.put("ASGORE", loadImage("ASGORE.jpg"));
    Fondos.put("Battle Against a True Hero", loadImage("Battle Against a True Hero.jpg"));
    Fondos.put("Bonetrousle", loadImage("Bonetrousle.jpg"));
    Fondos.put("Fallen Down", loadImage("Fallen Down.jpg"));
    Fondos.put("Hopes and Dreams", loadImage("Hopes and Dreams.jpg"));
    Fondos.put("MEGALOVANIA", loadImage("MEGALOVANIA.jpg"));
    Fondos.put("Metal Crusher", loadImage("Metal Crusher.jpg"));
    Fondos.put("Spider Dance", loadImage("Spider Dance.jpg"));    
    for(PImage img : Fondos.values()){
      img.resize(width, height);
  }

  //-----------------CARGA DE AUDIOS--------------------//  
  minim = new Minim(this);
  CMenu = minim.loadFile("Menu.mp3");
  Derrota = minim.loadFile("Derrota.mp3");
  
  pistas = new AudioPlayer[8];
  for(int i = 0; i < pistas.length; i++) {
    pistas[i] = minim.loadFile(Pistas[i] + ".mp3");
  }
  beat = new BeatDetect();

 
  //------------INICIALIZACION DE OBJETOS--------------//
  botonesY = height * 4 / 5;
  botones = new Boton[4];
  botones[0] = new Boton(CuerdasX[0], botonesY, 60, 60, 'D');
  botones[1] = new Boton(CuerdasX[1], botonesY, 60, 60, 'F');
  botones[2] = new Boton(CuerdasX[2], botonesY, 60, 60, 'J');
  botones[3] = new Boton(CuerdasX[3], botonesY, 60, 60, 'K');
  
  juego = new Juego();
  notas = new ArrayList<Nota>();
  estadoActual = new EstadoJuego(); 
}

//-------------------------------------------------------------------------------------------------------------//
void draw() {
  if(estadoActual.enMenu){
    notasGeneradas = 0;
    notas.clear();
    juego.mostrarMenu();
    juego.verificarClicMenu();
  } 
  
  else if(estadoActual.seleccionandoCancion){
    juego.seleccionarCancion();  
    juego.verificarClicCancion();
  } 
  
  else if(estadoActual.InGame == true){
    if(sonidoActual != -1){
      
      String nombrePista = Pistas[sonidoActual];      
      if(Fondos.containsKey(nombrePista)){
        PImage fondo = Fondos.get(nombrePista);
        proporcionarImagen(fondo, width / 2, height / 2, width, height);
      }
              
      juego.jugar(); //Clase principal
      
      if(estadoActual.InGame && juego.cancionTerminada()){
        juego.mostrarVictoria();        
      }        
    }
  }
  
  else{
    notasGeneradas = 0;
    estadoActual.cambiarAMenu();
    
  }
}


//-------------------------------------------------------------------------------------------------------------//
void proporcionarImagen(PImage img, float x, float y, int anchoObjetivo, int altoObjetivo){
  float proporcionAncho = anchoObjetivo / (float) img.width;
  float proporcionAltura = altoObjetivo / (float) img.height;
  float escala = min(proporcionAncho, proporcionAltura);
  int anchoImagen = (int)(img.width * escala);
  int alturaImagen = (int)(img.height * escala);

  tint(255, 150); 
  image(img, x, y, anchoImagen, alturaImagen);
  noTint();
}
 
//-------------------------------------------------------------------------------------------------------------//
void mousePressed(){
  if (estadoActual.enMenu) {
    estadoActual.verificarClicMenu();
  } 
  
  else if (estadoActual.seleccionandoCancion){
    estadoActual.verificarClicCancion();
  }
}

void keyPressed(){
  juego.keyPressed();
}

void keyReleased(){
  juego.keyReleased();
}
