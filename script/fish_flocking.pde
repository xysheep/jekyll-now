int screen_width=800;
int screen_height=800;
int n;
int fish_size=6;
int nbin=80;
int runmode=1;
int Mrd=1;
int Mvm=1;
int Mca=1;
int Mcn=1;
int Mtrace=0;
int Mmouse=0;
fish[] creature_list;
fish f;
bin[][] bins;
void setup(){
  background(70,30,205);
  size(800,800);
  creature_list=new fish[100];
  bins=new bin [nbin][nbin];
  noStroke();
  n=40;  
  for (int i=0;i<nbin;i++){
    for (int j=0;j<nbin;j++){
      bins[i][j]=new bin();
    }
  }
  for (int i=0;i<n;i++){
    creature_list[i]=new fish();
    bins[int(creature_list[i].x*nbin)][int(creature_list[i].y*nbin)].add(i);
  }
}
void draw(){
  if (Mtrace==0){
    background(70,30,205);
  }
  for (int i=0;i<n;i++){
    creature_list[i].random_a();
    creature_list[i].center_a();
    creature_list[i].vm_a();
    creature_list[i].avoid_a();
    creature_list[i].mouse_a();
    //creature_list[i].norm_a();
    creature_list[i].update_acc();
    creature_list[i].update_speed();
  }
  for (int i=0;i<nbin;i++){
    for (int j=0;j<nbin;j++){
      bins[i][j].empty();
    }
  }
  for (int i=0;i<n;i++){
    creature_list[i].update_location();
    bins[int(creature_list[i].x*nbin)][int(creature_list[i].y*nbin)].add(i);
  }
  for (int i=0;i<n;i++){
    creature_list[i].display();
  }
}
float distance(float x1,float y1,float x2,float y2){
    float dx,dy;
    dx=min(abs(x1-x2),1-abs(x1-x2));
    dy=min(abs(y1-y2),1-abs(y1-y2));
    return sqrt(dx*dx+dy+dy);
}
class fish{
  float x,y;
  float vx,vy,vmax,vmin;
  float ax,ay,amax;
  float rand_ax,rand_ay;
  float cen_ax,cen_ay;
  float vm_ax,vm_ay;
  float avoid_ax,avoid_ay;
  float mouse_ax,mouse_ay;
  int gridx,gridy;
  float weig,leng;
  float col1,col2,col3;
  fish(){
    vx=0;
    vy=0;
    weig=random(0,1);
    leng=random(0,1);
    col1=random(0,1);
    col2=random(0,1);
    col3=random(0,1);
    x=random(0,1);
    y=random(0,1);
    gridx=int(x*nbin);
    gridy=int(y*nbin);
    ax=0;
    ay=0;
    amax=1;
    vmax=2;
    vmin=0.5;
    rand_ax=0;
    rand_ay=0;
    cen_ax=0;
    cen_ay=0;
    vm_ax=0;
    vm_ay=0;
    avoid_ax=0;
    avoid_ay=0;
    mouse_ax=0;
    mouse_ay=0;
  }
  void random_a(){
    float rd;
    rd=random(-0.5,0.5);
    rand_ax=random(-1,1)+rd;
    rand_ay=random(-1,1)-rd;
  }
  void vm_a(){
    int neibn=0;
    float sx,sy;
    sx=0;
    sy=0;
    for(int i=-3;i<=3;i++){
      for(int j=-3;j<=3;j++){
        int ii=(gridx+i+nbin)%nbin;
        int jj=(gridy+j+nbin)%nbin;
        for(int k=0;k < bins[ii][jj].n;k++){
          int nb=bins[ii][jj].f[k];
          if(nb<n){
            neibn+=1;
            float d=distance(creature_list[nb].x,creature_list[nb].y,x,y);
            sx+= (1-d)*(creature_list[nb].vx-vx);
            sy+= (1-d)*(creature_list[nb].vy-vy);
          }    
        }
      }
    }
    if (neibn>1){
      sx=sx/(neibn-1);
      sy=sy/(neibn-1);
    }
    vm_ax=sx;
    vm_ay=sy;
  }
  void center_a(){
    int neibn=0;
    float sx,sy;
    sx=0;
    sy=0;
    for(int i=-6;i<=6;i++){
      for(int j=-6;j<=6;j++){
        int ii=(gridx+i+nbin)%nbin;
        int jj=(gridy+j+nbin)%nbin;
        for(int k=0;k < bins[ii][jj].n;k++){
          int nb=bins[ii][jj].f[k];
          if (nb<n){
            neibn+=1;
            if (abs(creature_list[nb].x-x)<0.5){
              sx+= creature_list[nb].x;
            }else if (creature_list[nb].x>x){
              sx+= creature_list[nb].x-1;
            }else{
              sx+= creature_list[nb].x+1;
            }
            if (abs(creature_list[nb].y-y)<0.5){
              sy+= creature_list[nb].y;
            }else if (creature_list[nb].y>y){
              sy+= creature_list[nb].y-1;
            }else{
              sy+= creature_list[nb].y+1;
            }
          }
        }
      }
    }
    sx=sx/neibn;
    sy=sy/neibn;
    cen_ax=sx-x;
    cen_ay=sy-y;
  }
  void avoid_a(){
    int neibn=0;
    float sx,sy;
    sx=0;
    sy=0;
    for(int i=-3;i<=3;i++){
      for(int j=-3;j<=3;j++){
        int ii=(gridx+i+nbin)%nbin;
        int jj=(gridy+j+nbin)%nbin;
        for(int k=0;k < bins[ii][jj].n;k++){
          int nb=bins[ii][jj].f[k];
          if(nb<n){
            neibn+=1;
            float d=distance(creature_list[nb].x,creature_list[nb].y,x,y);
            if (abs(creature_list[nb].x-x)<0.5){
              sx+= -(1/(d+0.1))*(creature_list[nb].x-x);
            }else if (creature_list[nb].x>x){
              sx+= -(1/(d+0.1))*(creature_list[nb].x-1-x);
            }else{
              sx+= -(1/(d+0.1))*(creature_list[nb].x+1-x);
            }
            if (abs(creature_list[nb].y-y)<0.5){
              sy+= -(1/(d+0.1))*(creature_list[nb].y-y);
            }else if (creature_list[nb].y>y){
              sy+= -(1/(d+0.1))*(creature_list[nb].y-1-y);
            }else{
              sy+= -(1/(d+0.1))*(creature_list[nb].y+1-y);
            }  
          }  
        }
      }
    }
    if (neibn>1){
      sx=sx/(neibn-1);
      sy=sy/(neibn-1);
    }
    avoid_ax=sx;
    avoid_ay=sy;
  }
  void mouse_a(){
    if (mousePressed == true){
      float mx=float(mouseX)/screen_width;
      float my=float(mouseY)/screen_height;
      if (distance(x,y,mx,my)<nbin*10){ 
        if (abs(mx-x)<0.5){
          mouse_ax=mx-x;
        }else if(mx>x){
          mouse_ax=mx-x-1;
        }else{
          mouse_ax=mx-x+1;
        }
        if (abs(my-y)<0.5){
          mouse_ay=my-y;
        }else if(my>y){
          mouse_ay=my-y-1;
        }else{
          mouse_ay=my-y+1;
        }
        if (Mmouse==1){
          mouse_ax=-mouse_ax;
          mouse_ay=-mouse_ay;
        }
      }
    }
  }
  void norm_a(){
    /*rand_ax*=1/sqrt(rand_ax*rand_ax+rand_ay*rand_ay);
    rand_ay*=1/sqrt(rand_ax*rand_ax+rand_ay*rand_ay);
    vm_ax*=1/sqrt(vm_ax*vm_ax+vm_ay*vm_ay);
    vm_ay*=1/sqrt(vm_ax*vm_ax+vm_ay*vm_ay);
    avoid_ax*=1/sqrt(avoid_ax*avoid_ax+avoid_ay*avoid_ay);
    avoid_ay*=1/sqrt(avoid_ax*avoid_ax+avoid_ay*avoid_ay);
    cen_ax*=1/sqrt(cen_ax*cen_ax+cen_ay*cen_ay);
    cen_ay*=1/sqrt(cen_ax*cen_ax+cen_ay*cen_ay);*/
  }
  void update_acc(){
    ax=0;
    ay=0;
    if (Mrd==1){
      ax+=rand_ax*2;
      ay+=rand_ay*2;
    }
    if (Mvm==1){
      ax+=vm_ax*3;
      ay+=vm_ay*3;
    }
    if (Mca==1){
      ax+=avoid_ax*9;
      ay+=avoid_ay*9;
    }
    if (Mcn==1){
      ax+=cen_ax*8;
      ay+=cen_ay*8;
    }
    if (mousePressed == true){
      ax+=mouse_ax*10;
      ay+=mouse_ay*10;
    }
    //println(rand_ax+" "+rand_ay+" "+avoid_ax + " " + avoid_ay+" "+vm_ax+" "+vm_ay+" "+cen_ax+" "+cen_ay);
    float a=sqrt(ax*ax+ay*ay);
    if (a>amax){
      ax*=amax/a;
      ay*=amax/a;
    }
  }
  void update_speed(){
    vx+=ax/40;
    vy+=ay/40;
    float v=sqrt(vx*vx+vy*vy);
    if (v>vmax){
      vx*=vmax/v;
      vy*=vmax/v;
    }
    if (v<vmin){
      vx*=vmin/v;
      vy*=vmin/v;
    }
  }
  void update_location(){
    x=x+vx/600+1;
    x=x-int(x);
    y=y+vy/600+1;
    y=y-int(y);
    gridx=int(x*nbin);
    gridy=int(y*nbin);
  }
  void display(){
    fill(100*col1+100,100*col2+100,100*col3+100);
    pushMatrix();
    translate(x*screen_width,y*screen_height);
    float angle;
    if (vx==0 && vy==0){
      angle=random(-PI,PI);
    }else{
      angle=atan2(vx,vy);
    }
    rotate(-angle+PI/2);
    triangle(-0.8*fish_size,-1*fish_size,-0.8*fish_size,1*fish_size,0,0);
    ellipse(1.5*fish_size, 0, (2.5+leng*1.4)*fish_size, (1.5+weig*0.8)*fish_size);
    popMatrix();
  }
  
}
class bin{
  int[] f;
  int n;
  bin(){
    f=new int [100];
    for(int i=0;i<100;i++){
      f[i]=-1;
    }
    n=0;
  }
  void add(int ifish){
    f[n]=ifish;
    n++;
  }
  void empty(){
    for(int i=0;i<n;i++){
      f[i]=-1;
    }
    n=0;
  }
}

void keyPressed(){
  if (key=='s'||key=='S'){
      for (int i=0;i<nbin;i++){
        for (int j=0;j<nbin;j++){
          bins[i][j].empty();
        }
      }
      for (int i=0;i<n;i++){
        creature_list[i]=new fish();
        bins[int(creature_list[i].x*nbin)][int(creature_list[i].y*nbin)].add(i);
      }
  } else if (key=='c'||key=='C'){
    background(70,30,205);
  } else if ((key=='='||key=='+')&&n<100){
    noLoop();
    creature_list[n]=new fish();
    bins[int(creature_list[n].x*nbin)][int(creature_list[n].y*nbin)].add(n);
    n+=1;
    println(n+" fish in the pool");
    loop();
  } else if (key=='-'){
    noLoop();
    n-=1;
    if (n<0){
      n=0;
    }
    println(n+" fish in the pool");
    loop();
  } else if(key==' '){
    if (runmode==1){
      runmode=0;
      noLoop();
    }else{
      runmode=1;
      loop();  
    }
  }else if(key=='1'){
    Mcn=abs(Mcn-1)*(Mcn+1);
    pmode();
  }else if(key=='2'){
    Mvm=abs(Mvm-1)*(Mvm+1);
    pmode();
  }else if(key=='3'){
    Mca=abs(Mca-1)*(Mca+1);
    pmode();
  }else if(key=='4'){
    Mrd=abs(Mrd-1)*(Mrd+1);
    pmode();
  }else if(key=='p'||key=='P'){
    Mtrace=abs(Mtrace-1)*(Mtrace+1);
  }else if(key=='a'||key=='A'){
    Mmouse=0;
    println("Mouse model: Attraction");
  }else if(key=='r'||key=='R'){
    Mmouse=1;
    println("Mouse model: Repulsion");
  }
}
void pmode(){
  String[] str=new String[2];
  str[0]="off";
  str[1]="on";
  println("Centering: "+str[Mcn]+" Collisions: "+str[Mca]+" Velocity matching: "+str[Mvm]+" Wandering: "+str[Mrd]);
}
void mousePressed(){
  String[] str=new String[2];
  str[0]="attraction";
  str[1]="repulsion";
  println("Mouse activated: "+ str[Mmouse]);
}
