class Polygon {
  
 ArrayList<PVector> points = new ArrayList<PVector>();
 
  Polygon ( ArrayList<PVector> newPoints) { 
      for (int i = 0; i < newPoints.size(); i++) {
         points.add(newPoints.get(i));
      }
  }
  
  void update() {
     fill(255);
    stroke(0);
    for (int i = 0; i < points.size(); i++) {
      ellipse(points.get(i).x, points.get(i).y, 10, 10);
      if (i<points.size()-1) line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
    }
  }
}