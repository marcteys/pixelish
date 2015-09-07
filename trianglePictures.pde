// http://lorempixel.com/400/200/
PImage bgImage;

ArrayList<PVector> pj = new ArrayList<PVector>();

int gridSize = 15;
int picturesToLoad = 4;
ArrayList<PImage> webImages = new ArrayList<PImage>();
boolean displayDetails = true;


void setup() {
  surface.setResizable(true);

  /*
  pj.add(new PVector(100, 150));
   pj.add(new PVector(170, 210));
   pj.add(new PVector(260, 220));
   pj.add(new PVector(230, 100));
   pj.add(new PVector(140, 150));
   pj.add(new PVector(120, 90));*/
  bgImage = loadImage("test.png");
  surface.setSize(bgImage.width, bgImage.height);

  for (int i = 0; i < picturesToLoad; i++) {
    String url = "http://lorempixel.com/" + width + "/"+height+"/";
    // Load image from a web server
    webImages.add(loadImage(url, "jpg"));
  }
}


void draw() {
  //  translate(width*0.25,height*0.25);
  background(255);
  image(bgImage, 0, 0);
  noStroke();
  fill(255, 255, 255, 100);

  for (int i =0; i <= width/gridSize; i++) {
    for (int j =0; j <= height/gridSize; j++) {
      if ((i%2 == 0 && j%2 == 0 ) || (i%2 == 1 && j%2 == 1) ) {
        PVector rpos = new PVector(i*gridSize + gridSize /2, j*gridSize + gridSize /2); // get the middle of the circles
        if (inPolyCheck(rpos, pj)==1) {
          rect(i*gridSize, j*gridSize, gridSize, gridSize);
          int randImage = round(random(0, webImages.size()-1));
          randImage = round(( i * j ) % webImages.size());

          PImage newSquareImage = webImages.get(randImage).get(i*gridSize, j*gridSize, gridSize, gridSize); 
          image(newSquareImage, i*gridSize, j*gridSize);
        }
      }
    }
  }

  // visual stuff 
  if (displayDetails) {

    fill(255);
    stroke(0);
    PVector m = new PVector(mouseX, mouseY);
    for (int i = 0; i < pj.size(); i++) {
      ellipse(pj.get(i).x, pj.get(i).y, 10, 10);
      if (i<pj.size()-1)line(pj.get(i).x, pj.get(i).y, pj.get(i+1).x, pj.get(i+1).y);
    }
    if (inPolyCheck(m, pj) ==1) ellipse(m.x, m.y, 15, 15);
  }
}

void mouseClicked() {
  PVector m = new PVector(mouseX, mouseY);
  pj.add(m);
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
  }
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
  //  if (a < 0.001) println(degrees(a));

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