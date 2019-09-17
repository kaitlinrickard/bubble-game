float bubbleW = 30, bubbleY, bubbleX;
float offsetXY = 20, offsetW = 5;
float gunX = 370/2, gunY = 800-offsetXY, gunAngle = 90;
float vx, vy;
float playerX = 370/2, playerY = 800-offsetXY;
boolean shot = false, game = false, lost = false, win = false;
int columns = 10, rows = 20;     // Number of tile columns and rows
Bubble player;
Bubble [][] bubbles = new Bubble [columns][rows];      // 2D array of bubbles
PImage purple, green, red, yellow, hole, loading, lose, winner; // images
ArrayList<PVector> stars = new ArrayList<PVector>(); // array of stars in the background
ArrayList<Bubble> checked = new ArrayList<Bubble>(); // initialise array
ArrayList<Bubble> matched = new ArrayList<Bubble>(); // initialise array

void setup() {
  size(370, 800); //size of display
  imageMode(CENTER); // change image mode
  purple= loadImage("purple-planet.png"); // load images
  green= loadImage("green-planet.png");
  red= loadImage("red-planet.png");
  yellow= loadImage("yellow-planet.png");
  hole= loadImage("black-hole.png");
  loading= loadImage("loading.png");
  lose= loadImage("lose.png");
  winner= loadImage("win.png");
  stars = new ArrayList<PVector>(); // reset star array list
  for (int i=0; i<500; i++) {   // create random stars and add to array
    stars.add(new PVector((int)random(0, width), (int)random(0, height)));
  }
  bubbles = new Bubble [columns][rows]; // reset bubble array
  for (int row=0; row<8; row++) { // create 8 row of bubbles, with random colours
    for (int col=0; col<columns; col++) {
      bubbles[col][row] = new Bubble((int)random(1, 5.3));
    }
  }
  player = new Bubble((int)random(1, 5)); // create new random colored bubble to be player
}

void draw() {
  if (game==false) {
    image(loading, width/2, height/2, width, height); // load game menu
  } else if (lost==true) {
    image(lose, width/2, height/2, width, height); // load losing screen
  } else if (win==true) {
    image(winner, width/2, height/2, width, height); // load winning screen
  } else {
    background(0); // black background
    stroke(255); // white stroke
    strokeWeight(2);
    for (PVector s : stars) {
      point(s.x, s.y); // draw stars
    }  
    stroke(255, 0, 0); // red
    line(0, 18*(bubbleW+offsetW) +offsetXY + (bubbleW+offsetW)/2, width, 18*(bubbleW+offsetW) +offsetXY + (bubbleW+offsetW)/2); // draw out of bounds line
    stroke(153, 255, 153); // green
    strokeWeight(4);
    line(gunX, gunY, (float)(gunX + 1.5*bubbleW * Math.cos(degToRad(gunAngle))), (float)(gunY - 1.5*bubbleW  * Math.sin(degToRad(gunAngle)))); // draw direction arrow
    for (int row=0; row<rows; row++) {
      for (int col=0; col<columns; col++) {
        bubbleX = col * (bubbleW+offsetW) +offsetXY; // find x coordinate
        if (row % 2 == 0) {
          bubbleX += bubbleW/2; // X offset for odd rows
        }
        bubbleY = row * (bubbleW+offsetW) +offsetXY; // find y coordinate
        if (bubbles[col][row]!=null) {
          bubbles[col][row].place(bubbleX, bubbleY, bubbleW); // draw bubble at the coordinate
          bubbles[col][row].setX(bubbleX); //set x point
          bubbles[col][row].setY(bubbleY); // set y point
        }
      }
    }
    player.place(playerX, playerY, bubbleW); // draw player's bubble
    if (shot==true) {
      playerX += vx; // change x point by velocity
      playerY += vy; // change y point by velocity
      if ( playerX>=width-bubbleW/2 || playerX<=bubbleW/2 ) { // if it hits the right wall or left wall, change the x direction
        vx = -vx ;
      }
      for (int row=0; row<rows; row++) {
        for (int col=0; col<columns; col++) {
          if (bubbles[col][row]!=null) {
            Bubble b = bubbles[col][row];
            if (bubbleIntersection(playerX, playerY, (bubbleW)/2, b.getX(), b.getY(), (bubbleW)/2)) { // check if player collides with a bubble
              String edge = null;
              if (b.getColor()==5) { // if it hits a black hole
                lost=true;
              } else {
                if (playerY-bubbleW/2 >= b.getY()+bubbleW/2) {
                  edge = "bottom";
                } else if (playerY-bubbleW/2 < b.getY()+bubbleW/2 && playerX-bubbleW/2 >= b.getX()+bubbleW/2) { // if it intersects with the right edge
                  edge = "right";
                } else if (playerY-bubbleW/2 < b.getY()+bubbleW/2 && playerX+bubbleW/2 <= b.getX()-bubbleW/2) { // if it intersects with the left edge
                  edge = "left";
                } else {
                  edge = "bottom";
                }
                snapBubble(playerX, playerY, player, edge); // call snap bubble
                return;
              }
            }
          }
        }
      }
      if ( playerY>=height ) { // if it hits the bottom wall, set bubble to that position
        shot=false;
        playerX = 370/2; 
        playerY = 800-offsetXY;
        player = new Bubble((int)random(1, 5));
        player.place(playerX, playerY, bubbleW);
      }
      if (playerY<=0 ) { // if it hits the top wall, set bubble to that position 
        bubbles[(int) ((playerX-offsetXY)/ (bubbleW+offsetW))][0]= player;
        shot=false;
        playerX = 370/2; 
        playerY = 800-offsetXY;
        player = new Bubble((int)random(1, 5));
        player.place(playerX, playerY, bubbleW);
      }
    }
  }
}

void mouseMoved() {
  float mouseangle = radToDeg((float)(Math.atan2((gunY) - mouseY, mouseX - (gunX)))); // Get the mouse angle
  if (mouseangle < 0) {
    mouseangle = 180 + (180 + mouseangle);   // Convert range to 0, 360 degrees
  }
  if (mouseangle > 170 && mouseangle < 270) {     // Left hand side
    mouseangle = 170; // so that it cant go backwards
  } else if (mouseangle < 10 || mouseangle >= 270) { //right hand side
    mouseangle = 10; // so that it cant go backwards
  }
  // Set the player angle
  gunAngle = mouseangle;
}

void mouseClicked() {
  if (lost==true) { // if the losing screen is displayed
    game=false; // change to menu screen
    lost=false; // reset so they havent lost yet
    shot=false;
    playerX = 370/2; //reset player
    playerY = 800-offsetXY;
    player = new Bubble((int)random(1, 5));
    player.place(playerX, playerY, bubbleW);
  } else if (win==true) { // if winning screen is displayed
    game=false; // change to menu screen
    win=false; // reset so they havent won yet
    shot=false;
    playerX = 370/2; //reset player
    playerY = 800-offsetXY;
    player = new Bubble((int)random(1, 5));
    player.place(playerX, playerY, bubbleW);
  } else if (game==false) {
    setup(); //reset to new configuration
    game=true; // change game play
  } else if (shot!=true) { // if its in the game and not already shooting a bubble
    vx= 5* (float) Math.cos(degToRad(gunAngle)); // set velocity for x
    vy= 5* (float)-(Math.sin(degToRad(gunAngle))); // set velocity for y
    shot = true; // set shot to true
  }
}

boolean bubbleIntersection(float x1, float y1, float r1, float x2, float y2, float r2) {
  float distSq = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2); // Calculate the distance between the centers and use pythagoras
  float radSumSq = (r1 + r2) * (r1 + r2);
  if (distSq <= radSumSq) { // if they do intersect
    return true;
  }
  return false;
}

void snapBubble(float x, float y, Bubble b, String edge) {
  int gridRow = (int) ((y-offsetXY)/ (bubbleW+offsetW)); // find the grid coordinates they hit
  int gridCol = (int) ((x-offsetXY)/ (bubbleW+offsetW));
  int r = 0;
  int c = 0;
  if (edge.equals("bottom") && gridRow+1 == 19) { // if they go out of bounds
    lost=true;
  }
  if (edge.equals("bottom")) {
    r=1;
  }
  if (edge.equals("left")) {
    c=-1;
  }
  if (edge.equals("right")) {
    c=1;
  }
  bubbles[gridCol+c][gridRow+r]= b; // add the bubble to the array at the position next to where they hit
  shot=false;
  matched = new ArrayList<Bubble>(); // reset array lists
  checked = new ArrayList<Bubble>();
  matched.add(bubbles[gridCol+c][gridRow+r]); // add it to matches array
  checkMatches(gridCol+c, gridRow+r); //check if surrounding bubbles match
  if (matched.size()>=4) { // if there are 4 bubbles that match
    for (Bubble bub : matched) {
      for (int row=0; row<rows; row++) {
        for (int col=0; col<columns; col++) {
          if (bubbles[col][row]!=null && bub==bubbles[col][row]) { //find the coordinates for the bubble
            bubbles[col][row]=null; //delete bubble from array
          }
        }
      }
    }
  }
  for (int row=0; row<rows; row++) {
    for (int col=0; col<columns; col++) {
      if (neighbours(col, row)==0) { //if they have no neighbours
        bubbles[col][row]=null; //delete them
      }
    }
  }
  int left=0;
  for (int row=0; row<rows; row++) {
    for (int col=0; col<columns; col++) {
      if (bubbles[col][row]!=null && bubbles[col][row].getColor()!=5) { //check how many bubbles are left
        left++;
      }
    }
  }
  if (left==0) { //win if no bubbles are left
    win=true;
  }
  playerX = 370/2; //reset player
  playerY = 800-offsetXY;
  player = new Bubble((int)random(1, 5));
  player.place(playerX, playerY, bubbleW);
}

float radToDeg(float angle) {
  return (float)(angle * (180 / PI));
}
float degToRad(float angle) {
  return (float)(angle * (PI / 180));
}

void checkMatches(int col, int row) {
  if (checked.contains(bubbles[col][row])) { // make sure you havet already che cked this bubble
    return;
  }
  checked.add(bubbles[col][row]); // add to checked
  if (bubbles[col][row]!=null) { // if there is a bubble in that place
    int c = bubbles[col][row].getColor();
    //check if surrounding bubbles match and then recursively check the matching ones:
    if (col>0 && bubbles[col-1][row]!=null && bubbles[col-1][row].getColor()==c) {
      if (!matched.contains(bubbles[col-1][row])) {
        matched.add(bubbles[col-1][row]);
      }
      checkMatches(col-1, row);
    }
    if (row>0 && bubbles[col][row-1]!=null && bubbles[col][row-1].getColor()==c) {
      if (!matched.contains(bubbles[col][row-1])) {
        matched.add(bubbles[col][row-1]);
      }
      checkMatches(col, row-1);
    }
    if (row<9 && bubbles[col][row+1]!=null && bubbles[col][row+1].getColor()==c) {
      if (!matched.contains(bubbles[col][row+1])) {
        matched.add(bubbles[col][row+1]);
      }
      checkMatches(col, row+1);
    }
    if (col<9 && bubbles[col+1][row]!=null && bubbles[col+1][row].getColor()==c) {
      if (!matched.contains(bubbles[col+1][row])) {
        matched.add(bubbles[col+1][row]);
      }
      checkMatches(col+1, row);
    }
    if (row % 2 == 1) {
      if (col>0 && row>0 && bubbles[col-1][row-1]!=null && bubbles[col-1][row-1].getColor()==c) {
        if (!matched.contains(bubbles[col-1][row-1])) {
          matched.add(bubbles[col-1][row-1]);
        }
        checkMatches(col-1, row-1);
      }
      if (col>0 && row<9 && bubbles[col-1][row+1]!=null && bubbles[col-1][row+1].getColor()==c) {
        if (!matched.contains(bubbles[col-1][row+1])) {
          matched.add(bubbles[col-1][row+1]);
        }
        checkMatches(col-1, row+1);
      }
    } else {
      if (col<9 && row>0 && bubbles[col+1][row-1]!=null && bubbles[col+1][row-1].getColor()==c) {
        if (!matched.contains(bubbles[col+1][row-1])) {
          matched.add(bubbles[col+1][row-1]);
        }
        checkMatches(col+1, row-1);
      }
      if (col<9 && row<9 && bubbles[col+1][row+1]!=null && bubbles[col+1][row+1].getColor()==c) {
        if (!matched.contains(bubbles[col+1][row+1])) {
          matched.add(bubbles[col+1][row+1]);
        }
        checkMatches(col+1, row+1);
      }
    }
  }
}

int neighbours(int col, int row) {
  if (row==0) {
    return 1; //if they are on the top row they are connected to top of screen
  };
  int count=0;
  if (row>0 && bubbles[col][row-1]!=null) {
    count++;
  }
  if (row % 2 == 1) {
    if (col>0 && row>0 && bubbles[col-1][row-1]!=null) {
      count++;
    }
  } else {
    if (col<9 && row>0 && bubbles[col+1][row-1]!=null) {
      count++;
    }
  }
  return count; //return number of neighbours above
}
