int screenH=600;
int screenW=600;
int sizeX=600;
int sizeY=600;
int gridW,gridH;
int day;
int runmode=1;
float wT=1,wP=1,wS=1,wY=1;  //weight of each factor
int year=0;
float dis=1;
float maxt=0,maxs=0,maxp=0;
cells[][] map;
caml cambium;
caml cambium1;
Table table;
float[] tempreture,sunlight, precipitation;
void setup(){
  background(255);
  gridW=screenW/sizeX;
  gridH=screenH/sizeY;
  size(600,600);
  tempreture=new float[36];
  sunlight=new float[36];
  precipitation=new float[36];
  noStroke();
  map=new cells[sizeX][sizeY];
  for (int i=0;i<sizeX;i++){
    for (int j=0;j<sizeY;j++){
      map[i][j]=new cells();
    }
  }
  cambium=new caml();
  cambium1=new caml();
  initD();
  day=0;
  loop();
  textSize(32);
  table=loadTable("weather.csv","header");
  int i=0;
  for (TableRow row : table.rows()) {
    tempreture[i] = row.getFloat("tempreture");
    if (tempreture[i]>maxt){maxt=tempreture[i];}
    sunlight[i] = row.getFloat("sunlight");
    if (sunlight[i]>maxs){maxs=sunlight[i];}
    precipitation[i]= row.getFloat("precipitation");
    if (precipitation[i]>maxp){maxp=precipitation[i];}
    i++;
  }
}
void draw(){
  background(120,220,120);
  day+=1;
  if (day==36){
    day=0;
    year+=1;
  }
  growth();
  updatemap();
  cambium.n=cambium1.n;
  for (int i=0;i<cambium.n;i++){
    cambium.cam[i]=cambium1.cam[i];
  }
  cambium1.clear();
  for (int i=0; i<sizeX;i++){
    for (int j=0;j<sizeY;j++){
      if (map[i][j].type!=-1){
        float colf=(map[i][j].density)*sqrt(map[i][j].wall_thick);
        fill(256-150*colf,194-90*colf,126-60*colf);
        //rect(i*gridW,j*gridH,(i+1)*gridW,(j+1)*gridH);
        rect(i*gridW,j*gridH,gridW,gridH);
      }
    }
  }
  fill(255,0,0);
  if (day<6){
    text("Winter",sizeX*4/10,sizeY*9/10);
  }else if(day<15){
    text("Spring",sizeX*4/10,sizeY*9/10);
  }else if(day<24){
    text("Summer",sizeX*4/10,sizeY*9/10);
  }else if(day<33){
    text("Fall",sizeX*4/10,sizeY*9/10);
  }else{
    text("Winter",sizeX*4/10,sizeY*9/10);
  }
  text("Year:"+year,sizeX*2/10,sizeY*9/10);
  text("Day:"+(day*10+30)%90,sizeX*6/10,sizeY*9/10);
  fill(255,255,0);
  text("South",sizeX*4.5/10,sizeY*8/10);
  if(dis==0.5){
    fill(50);
    text("DISASTER",sizeX*4/10,sizeY*2/10);
  }
  if (cambium.n>2*3.14*sizeX/4){
      reset();
  }
  delay(100);
}
void initD(){
  for (int i=sizeX/2-12;i<sizeX/2+12;i++){
    for (int j=sizeY/2-12;j<sizeX/2+12;j++){
      if (dist(i,j,sizeX/2,sizeY/2)<10){
        map[i][j].type=2;
        map[i][j].density=0.5+random(0.5);
        map[i][j].wall_thick=0.5+random(0.5);
      }else if(dist(i,j,sizeX/2,sizeY/2)>=10 &&dist(i,j,sizeX/2,sizeY/2)<=11 ){
        map[i][j].type=1;
        map[i][j].density=.5;
        map[i][j].wall_thick=.5;
        map[i][j].mature=0;
        map[i][j].dist=dist(i,j,sizeX/2,sizeY/2);
        cambium.add(i,j);
      }
    }
  }
}

class cells{
  int type;//2 pich, 1 cambium, 0 heartwood, -1 nothing
  float density;//0-1
  float wall_thick;//0-1
  float mature;//0-1
  float dist;
  float rate;
  float cellsize;
  float cell;
  cells(){
    type=-1;
    density=0;
    wall_thick=0;
    mature=0;
    dist=0;
    rate=0;
    cell=0;
  }
}
class caml{
  pos[] cam;
  int n;
  caml(){
    n=0;
    cam=new pos[sizeX*5+sizeY*5];
  }
  void add(int i, int j){
    cam[n]=new pos(i,j);
    n++;
  }
  void clear(){
    n=0;
  }
}
class pos{
  int x,y;
  pos(int i, int j){
    x=i;
    y=j;
  }
}
void growth(){
  for (int i=0;i<cambium.n;i++){
    int px=cambium.cam[i].x;
    int py=cambium.cam[i].y;
    map[px][py].rate=0.2+growthrate(px,py)*dis;
    map[px][py].cellsize=0.1+growthcell(px,py)*dis;
    map[px][py].cell+=map[px][py].rate;
    map[px][py].mature+=map[px][py].rate*map[px][py].cellsize;
  }
}
void updatemap(){
  for (int i=0;i<cambium.n;i++){
    int px=cambium.cam[i].x;
    int py=cambium.cam[i].y;
    if (map[px][py].mature>=1){
      map[px][py].type=0;
      map[px][py].density=map[px][py].cell/4;
      map[px][py].wall_thick=wall_thick(px,py);
      for (int j=-1;j<2;j++){
        for (int k=-1;k<2;k++){
          int pxx=j+cambium.cam[i].x;
          int pyy=k+cambium.cam[i].y;
          if (map[pxx][pyy].type==-1&&dist(pxx,pyy,sizeX/2,sizeY/2)<=map[px][py].dist+1){
              map[pxx][pyy].type=1;
              map[pxx][pyy].density=.5;
              map[pxx][pyy].wall_thick=.5;
              map[px][py].cell=0;
              map[pxx][pyy].dist=map[px][py].dist+1;
              cambium1.add(pxx,pyy);
          }
        }
      }
    }else{
      cambium1.add(px,py);
    }
  }
}
float growthrate(int x,int y){
  float r=1;
  float t=tempreture[day]/maxt;
  float s=sunlight[day]/maxs*sun(x,y);
  float p=precipitation[day]/maxp;
  float fy=1.2-(year/100-0.3)*(year/100-0.3);
  float ft=1-2.5*(t-0.65)*(t-0.65);
  float fp=1-0.5*(p-1)*(p-1);
  float fs=1+4.5*(s/2-0.5)*(s/2-0.5)*(s/2-0.5);
  r=exp(wT*log(ft)+wP*log(fp)+wS*log(fs)+wY*log(fy));
  r=random(r/2)+r/2;
  return r;
}
float sun(int x,int y){
  return 1+0.4*(y-sizeY/2)/dist(x,y,sizeX/2,sizeY/2);
}
float growthcell(int x,int y){
  float r=1;
  float t=tempreture[day]/maxt;
  float s=sunlight[day]/maxs*sun(x,y);
  float p=precipitation[day]/maxp;
  float ft=1-(t-0.5)*(t-0.5);
  float fp=1-0.5*(p-1)*(p-1);
  float fs=1+4.5*(s/2-0.5)*(s/2-0.5)*(s/2-0.5);
  r=exp(wT*log(ft)+wP*log(fp)+wS*log(fs));
  r=random(r/2)+r/2;
  return r;
}
float wall_thick(int x,int y){
  float r=1;
  float s=sunlight[day]/maxs*sun(x,y);
  r=0.8+0.3*s*s;
  return 1;
}
void keyPressed(){
  if(key==' '){
    if (runmode==0){
      loop();
      runmode=1;
    }else{
      noLoop();
      runmode=0;
    }
  }else if (key=='d'){
    if (dis==0.5){
      dis=1;
    }else{
      dis=0.5;
    }
  }else if(key=='i'){
    day=0;
    year=0;
    for (int i=0;i<sizeX;i++){
      for (int j=0;j<sizeY;j++){
        map[i][j].type=-1;
        map[i][j].density=0;
        map[i][j].wall_thick=0;
        map[i][j].mature=0;
        map[i][j].dist=0;
        map[i][j].rate=0;
        map[i][j].cell=0;
      }
    }
    cambium.n=0;
    cambium1.n=0;
    initD();
  }
} 
void reset(){
      day=0;
    year=0;
    for (int i=0;i<sizeX;i++){
      for (int j=0;j<sizeY;j++){
        map[i][j].type=-1;
        map[i][j].density=0;
        map[i][j].wall_thick=0;
        map[i][j].mature=0;
        map[i][j].dist=0;
        map[i][j].rate=0;
        map[i][j].cell=0;
      }
    }
    cambium.n=0;
    cambium1.n=0;
    initD();
}