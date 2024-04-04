 class EstadoJuego{
  public boolean enMenu;
  public boolean enMenuClick;
  public boolean seleccionandoCancion;
  public boolean cambiarAInGame;
  public boolean InGame;
  public boolean victoria;
  public boolean derrota;

  EstadoJuego(){
    enMenu = true;
    seleccionandoCancion = false;
    cambiarAInGame = false;
    enMenuClick = false;
    victoria = false;
    derrota = false;
  }
  
  public void cambiarAMenu(){
    enMenu = true;
    seleccionandoCancion = false;
    enMenuClick = false;
    victoria = false;
    derrota = false;
  }
  
  public void cambiarASeleccionCancion() {
    enMenu = false;
    seleccionandoCancion = true;
    enMenuClick = false;
  }
  
  public void cambiarAInGame() {
    enMenu = false;
    seleccionandoCancion = false;
    InGame = true;
    enMenuClick = false;     
  }
  
  public void verificarClicMenu(){
    juego.verificarClicMenu();
  }
   
  public void verificarClicCancion(){
    if(seleccionandoCancion){
      juego.verificarClicCancion();
    }
  }
}
