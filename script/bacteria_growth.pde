int xs=50;
int ys=50;
int state;//0 initiate, 1 single-step; 2 continuous
int[][] cell_grid;
int[][] cell_count;
void setup(){
  size(400,400);
  stroke(0);
  cell_grid = new int [xs][ys];//1 live, 0 die
  cell_count= new int [xs][ys];
  background(0);
  clear();
  randomize();
  state=2;
}

void draw(){
  if (state>0){
    update_states();
  }
  for(int x=0;x<xs;x++)
    for (int y=0;y<ys;y++){
      if (cell_grid[x][y]==1){
        fill(255);
        rect(8*x,y*8,8,8);
      }else{
        fill(0);
        rect(8*x,y*8,8,8);
      }
    }
  if (state==2){delay(10);}
}  
void randomize(){
  for (int x=0;x<xs;x++)
    for (int y=0;y<ys;y++){
      cell_grid[x][y]=int(random(2));
    }
  state=2;
  redraw();
}
void clear(){
  for (int x=0;x<xs;x++)
    for (int y=0;y<ys;y++){
      cell_grid[x][y]=0;
    }
  state=0;
  redraw();
}
void update_states(){
  update_count();
  for (int x=0;x<xs;x++)
    for (int y=0;y<ys;y++){
      if (cell_count[x][y]==3){
        cell_grid[x][y]=1;
      }else if (cell_count[x][y]==2 &&  cell_grid[x][y]==1){
        cell_grid[x][y]=1;
      }else{
        cell_grid[x][y]=0;
      }
    }
}
        
void update_count(){
  for (int x=0;x<xs;x++)
    for (int y=0;y<ys;y++){
      cell_count[x][y]=-cell_grid[x][y];
      for(int xn=-1;xn<=1;xn++)
        for(int yn=-1;yn<=1;yn++){
          int xx=(x+xn+xs)%xs;
          int yy=(y+yn+ys)%ys;
          cell_count[x][y]+=cell_grid[xx][yy];
        }
    }
}

void keyPressed(){
  if (key=='R'||key=='r'){
    randomize();
  }
}