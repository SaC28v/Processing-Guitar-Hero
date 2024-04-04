import ddf.minim.*;
import ddf.minim.analysis.*;
 
class Juego{ 
  public int puntaje;
  public boolean audio;
  public int beatCounter;  
  public int tiempoInicial; //Para verificar victoria
  public int duracionCancion;
  //public int gaps; 
        
  public void mostrarMenu(){  
    if (!audio) {
      CMenu.loop();
      audio = true;       
    }   
    background(0);
    proporcionarImagen(FMenu, width/2, height/2, width, 900);
    image(Titulo, width/2, 50);
    image(Play,width/2,650);
  }
  
  public void verificarClicMenu() {
    float xInicio = width / 2 - Play.width / 2;
    float xFin = width / 2 + Play.width / 2;
    float yInicio = 630 - Play.height / 2;
    float yFin = 630 + Play.height / 2;

    if(mousePressed && mouseX > xInicio && mouseX < xFin && mouseY > yInicio && mouseY < yFin && !estadoActual.enMenuClick) {
      estadoActual.cambiarASeleccionCancion();
      estadoActual.enMenuClick = true;   
    }
  }
  
  public void seleccionarCancion() {   
    background(0);
    proporcionarImagen(Canciones, width/2, height/2, width, 780);    
    image(Tracklist, width/2, height/6);
    
    float yInicio = height/3;
    float yFin = yInicio;
    textAlign(CENTER, CENTER);     
    for(int i = 0; i < pistas.length; i++) {
      stroke(#FFEB08);
      fill(0);
      rect(width/2, yInicio + i * 60, 210, 40);       
      fill(#FFEB08);
      textSize(18);      
      String n = Pistas[i];
      text(n, width/2, (yInicio + yFin) / 2 + i * 60);
    }
  }
    
  public void verificarClicCancion() {
    boolean clicEnCancion = false;

    for(int i = 0; i < pistas.length; i++){  
      float xInicio = width / 2 - 105;
      float xFin = width / 2 + 105;
      float yInicio = height / 3 + i * 60 - 20;
      float yFin = yInicio + 40;

      if(mousePressed && mouseX > xInicio && mouseX < xFin && mouseY > yInicio && mouseY < yFin && !estadoActual.enMenuClick){
        //Detener la reproducción del audio actual si está en reproducción
        if(sonidoActual != -1 && pistas[sonidoActual].isPlaying()){         
          pistas[sonidoActual].pause();  
          pistas[sonidoActual].rewind();
        }

        //Reproducir la nueva canción seleccionada y escaneo de tiempo
        sonidoActual = i;     
        pistas[sonidoActual].play();        
        duracionCancion = Duraciones[sonidoActual]; //Coincidencia de duracion con cancion especifica
        //sfjdks = gaps[sonidoActual];
        clicEnCancion = true;
        puntaje = 100;
   
        //Empezar a contar la duracion de la cancion
        tiempoInicial = millis();
        println(duracionCancion);
                             
        //Cambiar al estado de juego
        reiniciarJuego();       
        estadoActual.cambiarAInGame();
        estadoActual.enMenuClick = true;
      } 
    }

      if(CMenu != null && CMenu.isPlaying() && clicEnCancion) {
        CMenu.pause();
        CMenu.rewind();
      }

      if(!mousePressed) {
        estadoActual.enMenuClick = false;
      }
  }

  public void jugar(){    
    beat.detect(pistas[sonidoActual].mix);
    int columna = int(random(1, 5));

    if(beat.isOnset()){
      beatCounter++;
      if (beat.isOnset() && beatCounter> 10/*gaps*/){
        Nota nuevaNota = new Nota(CuerdasX[columna - 1], 0, columna);
        nuevaNota.resetear();
        nuevaNota.mostrar(); //Override
        notas.add(nuevaNota);         
        beatCounter=0;        
      }  
    }
                  
    strokeWeight(3);
    stroke(255);
    for(int i = 0; i < CuerdasX.length; i++) {
      line(CuerdasX[i], 0, CuerdasX[i], height);
    }
      
    for(Nota nota : notas){
      nota.actualizar();
      nota.mostrar(); //Override
          
      if(nota.getY() > height + 15){
        nota.resetear();
        puntaje -= 20;
      }
    }

    for(Boton boton : botones) {
      boton.mostrar(); //Override
    }

    //Verificar colisiones
    for(Nota nota : notas) {
      for(Boton boton : botones) {
        if(boton.activado && boton.colisiona(nota)) {
          nota.resetear();
          puntaje += 30;
        }
      }
    }
    
    //Botón de Puntaje
    stroke(#FFEB08);
    fill(0);
    rect(80,30,150,40);
    fill(#FFEB08);
    textSize(20);
    textAlign(LEFT, TOP);
    text("SCORE: " + puntaje, 20, 22);
    
  
    //-----------------------------------VERIFICAR DERROTA---------------------------------//
    if(puntaje < 0) {
      estadoActual.derrota = true;
      if(sonidoActual != -1 && pistas[sonidoActual].isPlaying()) {
        pistas[sonidoActual].pause();
        pistas[sonidoActual].rewind();
        Derrota.loop();
      }
      
      velocidad = 0;
      tiempoInicial = 0;
      stroke(#FFEB08);
      fill(0);
      rect(width/2, height/2 -22, 320, 140);       
      fill(#FFEB08);
      textSize(22);
      textAlign(CENTER, CENTER);      
      text("¡No te rindas!", width / 2, height / 2 - 70);
      text("Estás lleno de Determinación", width / 2, height/2 - 45);
      textSize(20);
      text("¿CONTINUAR?", width / 2, height / 2 - 10);
      text("Si (S)", 200, height / 2 + 20);
      text("No (N)", 300 , height / 2 + 20); 
    }
                   
  }
  
    //-----------------------------------VERIFICAR VICTORIA---------------------------------//
  public void mostrarVictoria(){
    estadoActual.victoria = true;
    tiempoInicial = 0;
    velocidad = 0;     
      image(Victoria, width/2, height/2, width, 780);
      stroke(#FFEB08);
      fill(0);
      rect(width/2, height/2 -22, 320, 140);       
      fill(#FFEB08);
      textSize(22);
      textAlign(CENTER, CENTER);    
      text("¡VICTORIA!", width / 2, height / 2 - 70);
      text("Te llenas de Determinación", width / 2, height/2 - 45);
      textSize(20);
      text("¿REINTENTAR?", width / 2, height / 2 - 10);
      text("Si (S)", 200, height / 2 + 20);
      text("No (N)", 300 , height / 2 + 20);      
  }
    
  public boolean cancionTerminada(){
    int tiempoTranscurrido = millis() - tiempoInicial;
    return tiempoTranscurrido >= duracionCancion; //duracionCancion
  }
 
  public void actualizarBoton(char t, boolean presionado){
    for(Boton boton : botones){
      if(boton.Tecla(t)){
        boton.activar(presionado);
      }
    }
  }
  
  public void reiniciarJuego(){
    puntaje = 100; //Reiniciar puntaje
    velocidad = 5; //Reiniciar velocidad de las notas

    if(sonidoActual != -1 && pistas[sonidoActual].isPlaying()){
      pistas[sonidoActual].pause();
      pistas[sonidoActual].rewind();
    }
    
    if(sonidoActual != -1){
      pistas[sonidoActual].play();
    }
    
    for(Nota nota : notas){
      nota.resetear();
    }
    
    if(CMenu.isPlaying()){
      CMenu.pause();
    }    
    
    estadoActual.cambiarAInGame();
  }
  
  public void regresarAlMenu(){
    puntaje = 100;

    if(sonidoActual != -1 && pistas[sonidoActual].isPlaying()){
      pistas[sonidoActual].pause();
      pistas[sonidoActual].rewind();
    }
        
    for(Nota nota : notas){
      nota.resetear();  
    }
    
    if(CMenu.isPlaying()){
      CMenu.pause();
    }    
    
    CMenu.loop();
    estadoActual.cambiarAMenu();
  }
  
//------------------------------------------------------------------------------------------//
      
  public void keyPressed(){
    actualizarBoton(key, true);
  
    if(estadoActual.InGame && estadoActual.derrota || estadoActual.InGame && estadoActual.victoria){
      if (key == 's' || key == 'S') {
        tiempoInicial = millis();
        juego.reiniciarJuego();
        Derrota.pause();
        Derrota.rewind();
      } 
      
      else if (key == 'n' || key == 'N'){  
        juego.regresarAlMenu();
        Derrota.pause();
        Derrota.rewind();
      }
    }  
  }

  public void keyReleased(){
    actualizarBoton(key, false);
  }  
}
