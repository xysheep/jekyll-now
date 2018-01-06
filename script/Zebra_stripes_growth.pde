float[][] v,u,vnew,unew;
int sizeX=100,sizeY=100;
int screenW=400;
int screenH=400;
int drawMode=1; //1 means draw u, 0 means draw 1;
int paraMode=1; //1 means constant parameters; 0 spatially-varying
int ractMode=1; //1 means reaction-diffusion; 0 means diffusion;
int runMode=1; //1 run; 0 stop
int gridW,gridH;
float ru=0.082;
float rv=0.041;
float k=0.0625,f=0.035;
float Lv,Lu,uv2;
float dt=1;
void setup(){
  background(255);
  gridW=screenW/sizeX;
  gridH=screenH/sizeY;
  size(screenW,screenH);
  u=new float[sizeX][sizeY];
  v=new float[sizeX][sizeY];
  unew=new float[sizeX][sizeY];
  vnew=new float[sizeX][sizeY];
  noStroke();
  inituv();
}


void draw(){
  float min=0,max=0;
  background(255);
  for (int i=0;i<sizeX;i++){
    for (int j=0;j<sizeY;j++){
      if (drawMode==1){
        if (u[i][j]<min){min=u[i][j];}else if(u[i][j]>max){max=u[i][j];}
      }else{
        if (v[i][j]<min){min=v[i][j];}else if(v[i][j]>max){max=v[i][j];}
      }
    }
  }
  for (int i=0;i<sizeX;i++){
    for (int j=0;j<sizeY;j++){
      if (drawMode==1){
        fill(255*(u[i][j]-min)/(max-min));
      }else{
        fill(255*(v[i][j]-min)/(max-min));
      }
      rect(i*gridW,j*gridH,(i+1)*gridW,(j+1)*gridH);
    }
  }
  for (int i=0;i<50;i++){RaDu();}
}
void RaDu(){
  for (int i=0;i<sizeX;i++){
    for(int j=0;j<sizeY;j++){
      Lu=u[(i+1+sizeX)%sizeX][j]+u[(i-1+sizeX)%sizeX][j]+u[i][(j+1+sizeY)%sizeY]+u[i][(j-1+sizeY)%sizeY]-4*u[i][j];
      Lv=v[(i+1+sizeX)%sizeX][j]+v[(i-1+sizeX)%sizeX][j]+v[i][(j+1+sizeY)%sizeY]+v[i][(j-1+sizeY)%sizeY]-4*v[i][j]; 
      if (paraMode==0){
        k=0.03+0.04*i/sizeX;
        f=0.08-0.08*j/sizeY;
      }
      if (ractMode==1){
        uv2=u[i][j]*v[i][j]*v[i][j];
        unew[i][j]=u[i][j]+dt*(f*(1-u[i][j])-uv2+ru*Lu);
        vnew[i][j]=v[i][j]+dt*(-(f+k)*v[i][j]+uv2+rv*Lv);
      }else{
        unew[i][j]=u[i][j]+dt*(ru*Lu);
        vnew[i][j]=v[i][j]+dt*(rv*Lv);
      }
    }
  }
  v=vnew;
  u=unew;
}

void keyPressed(){
  if (key==' '){
    if (runMode==1){
      runMode=0;
      noLoop();
    }else{
      runMode=1;
      loop();
    }
  }else if(key=='u'||key=='U'){
    drawMode=1;
  }else if(key=='v'||key=='V'){
    drawMode=0;
  }else if(key=='i'||key=='I'){
    inituv();
  }else if(key=='1'){
    k=0.0625;
    f=0.035;
  }else if(key=='2'){
    k=0.06;
    f=0.035;
  }else if(key=='3'){
    k=0.0475;
    f=0.0118;
  }else if(key=='4'){
    k=0.0472;
    f=0.018;
  }else if(key=='p'||key=='P'){
    if (paraMode==0){
      paraMode=1;
      k=0.0625;
      k=0.035;
    }else{
      paraMode=0;
    }
  }else if(key=='d'||key=='D'){
    ractMode=abs(ractMode-1)*(ractMode+1);
  }
}

void inituv(){
  for (int i=0;i<sizeX;i++){
    for(int j=0;j<sizeY;j++){
      u[i][j]=1;
      v[i][j]=0;
    }
  }
  for (int i=sizeX/2-5;i<sizeX/2+5;i++){
    for(int j=sizeY/2-5;j<sizeY/2+5;j++){
      u[i][j]=0.5+random(0.05);
      v[i][j]=0.25+random(0.025);
    }
  }
  for (int i=0;i<10;i++){
    for(int j=0;j<10;j++){
      u[i][j]=0.5+random(0.05);
      v[i][j]=0.25+random(0.025);
    }
  }
}
void mousePressed(){
  int x=int(mouseX*sizeX/screenW);
  int y=int(mouseY*sizeY/screenW);
  println("Concentration of u is "+u[x][y]+".Concentration of v is "+v[x][y]);
  if (paraMode==0){
    float pk=0.03+0.04*x/sizeX;
    float pf=0.08-0.08*y/sizeY;
    println("k is "+pk+".f is "+pf);
  }
}
