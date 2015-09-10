// http://lorempixel.com/400/200/

//CreattionPoly
ArrayList<PVector> pj = new ArrayList<PVector>();
ArrayList<Polygon> shapes = new ArrayList<Polygon>();


float minDistCollapse = 10;
boolean displayDetails = true;

//image stuf
int gridSize = 15;
int picturesToLoad = 4;
ArrayList<PImage> webImages = new ArrayList<PImage>();
PImage bgImage;

void setup() {
  size(800, 800);
  surface.setResizable(true);
  //bgImage = loadImage("test.png");
  bgImage = loadImage("3.jpg");
  surface.setSize(bgImage.width, bgImage.height);

  for (int i = 0; i < picturesToLoad; i++) {
    String url = "http://lorempixel.com/" + width + "/"+height+"/";
    url = "http://lorempixel.com/1024/768/";
    // Load image from a web server
    webImages.add(loadImage(url, "jpg"));
  }
}

void draw() {

  listenMouseEvent();
  image(bgImage, 0, 0);
  noStroke();
  displayCudes(pj);
  for (int i = 0; i < shapes.size(); i++) {
    displayCudes(shapes.get(i).points);
  }

  // visual stuff 
  if (displayDetails) {
    displayInstructions();
    fill(255);
    stroke(0);
    PVector m = new PVector(mouseX, mouseY);
    for (int i = 0; i < pj.size(); i++) {
      ellipse(pj.get(i).x, pj.get(i).y, 10, 10);
      if (i<pj.size()-1)line(pj.get(i).x, pj.get(i).y, pj.get(i+1).x, pj.get(i+1).y);
    }
    for (int i = 0; i < shapes.size(); i++) {
      shapes.get(i).update();
    }
  }
}

void displayCudes(ArrayList<PVector> points) {
  for (int i =0; i <= width/gridSize; i++) {
    for (int j =0; j <= height/gridSize; j++) {
      if ((i%2 == 0 && j%2 == 0 ) || (i%2 == 1 && j%2 == 1) ) {
        PVector rpos = new PVector(i*gridSize + gridSize /2, j*gridSize + gridSize /2); // get the middle of the circles
        if (inPolyCheck(rpos, points)==1) {
          if (displayDetails) {
            rect(i*gridSize, j*gridSize, gridSize, gridSize);
          } else {
            randomSeed(i * j);
            int randImage = round(floor(random(0, i * j)) % webImages.size());
            PImage newSquareImage = webImages.get(randImage).get(i*gridSize, j*gridSize, gridSize, gridSize); 
            image(newSquareImage, i*gridSize, j*gridSize);
          }
        }
      }
    }
  }
}

void listenMouseEvent() {
  if (mousePressed)
  {  
    if (mouseButton == LEFT)
    {   
      PVector m = new PVector(mouseX, mouseY);
      if (pj.size() != 0 && proximityPoint(m, pj.get(0))) // if it's near the first one
      {
        closeShape();
      } else
      {
        pj.add(m);
      }
    } else if (mouseButton == RIGHT) {
      PVector m = new PVector(mouseX, mouseY);
      for (int i = 0; i < shapes.size(); i++) {
        if (inPolyCheck(m, shapes.get(i).points)==1) shapes.remove(i);
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      for (int i = 0; i < picturesToLoad; i++) {
        String url = "http://lorempixel.com/" + width + "/"+height+"/";
        // Load image from a web server
        webImages.add(loadImage(url, "jpg"));
      }
    }
    if (keyCode == DOWN) displayDetails = !displayDetails;
    if (keyCode == LEFT) {
      gridSize--;
      if (gridSize <= 0 ) gridSize = 1;
    }
    if (keyCode == RIGHT) gridSize++;
  }
  if (key == ENTER ) closeShape();
}

void displayInstructions() {
  String s = "INSTRUCTIONS\n\u00A0\nMouse\nLeft click : Create a point on the shape\nRight click : Delete a shape\n\u00A0\nArrow keys\nLEFT/RIGHT : Increase/Decrease cubes size\nENTER : Close a shape\nUP : Reload randomly the images\nDOWN : Toggle helpers";
  fill(255);
  text(s, 10, 10, 500, 500);
}

void closeShape() {
  if (pj.size() == 0) return;
  println("CLose shape");
  pj.add(pj.get(0).get());
  shapes.add(new Polygon(pj));
  pj.clear();
}

int inPolyCheck(PVector v, ArrayList<PVector> p) {
  if (p.size() < 3 ) return 0;
  float a = 0;
  for (int i =0; i<p.size()-1; ++i) {
    PVector v1 = p.get(i).get();
    PVector v2 = p.get(i+1).get();
    a += vAtan2cent180(v, v1, v2);
  }
  PVector v1 = p.get(p.size()-1).get();
  PVector v2 = p.get(0).get();
  a += vAtan2cent180(v, v1, v2);
  if (abs(abs(a) - TWO_PI) < 0.01) return 1;
  else return 0;
}

float vAtan2cent180(PVector cent, PVector v2, PVector v1) {
  PVector vA = v1.get();
  PVector vB = v2.get();
  vA.sub(cent);
  vB.sub(cent);
  vB.mult(-1);
  float ang = atan2(vB.x, vB.y) - atan2(vA.x, vA.y);
  if (ang < 0) ang = TWO_PI + ang;
  ang-=PI;
  return ang;
}

boolean proximityPoint(PVector p1, PVector p2)
{
  boolean minpoint = false;
  if (p1.dist(p2) < minDistCollapse && p1.dist(p2) != 0)
  {
    minpoint = true;
  }
  return minpoint;
}