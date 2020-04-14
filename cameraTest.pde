import gab.opencv.*;  //ライブラリをインポート
import processing.video.*;
import java.awt.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput in;
AudioPlayer player;

Capture video;
OpenCV opencv;
PImage canny, scharr, sobel;
 
 int frameCount = 0;
 int color_T;
 int x;
 boolean redflag = false, maxflag = false;
 
void setup() {
  fullScreen();
  minim = new Minim(this);
  player = minim.loadFile("tirin1.mp3");
  in = minim.getLineIn(Minim.STEREO, 512);
  video = new Capture(this, displayWidth, displayHeight);
  opencv = new OpenCV(this, displayWidth, displayHeight);
 
  video.start();  //キャプチャを開始
  
}
 
void draw() {
  opencv.loadImage(video);  //ビデオ画像をメモリに展開
  //println(in.mix.level()*10000);
  //println(map(in.mix.level()*10000, 0, 50, 0, 100));
  
  //cannyエッジフィルターを使用
  //findCannyEdges(int low, int hgih)
  //high以上のエッジ強度はエッジにする。low以下はエッジにしない
  opencv.findCannyEdges(30, 31);
    //opencv.findCannyEdges(50, 71);
  canny = opencv.getSnapshot();
  
  image(canny, 0, 0 );  //表示
  if(map(in.mix.level()*10000, 0, 70, 0, 100) > 95){
    //flagをtrueに
    maxflag = true;
    redflag = false;
    if(color_T < 50) color_T = 50;
    x = 10;
    //player.play();
    //player.rewind();
    // 音の広がりを表示する関数
  }else{
    //255にいくとflagがtrueに
    if(color_T > 0 && redflag == true){
      color_T -= 5;
    }else if(color_T >= 50 && redflag == false){
      if(color_T >= 255){
        color_T = 255;
        redflag = true;
      }else{
      color_T += 20;
      }
    }else{
      color_T = 0;
      maxflag = false;
      redflag = false;
    }
   
  }
  println(color_T);
  fill(0, 255-color_T);
  rect(0, 0, displayWidth, displayHeight);
  x = showWave(x);
  if(x > 1080){
    x = 0;
  }
  
 
}
 
void captureEvent(Capture c) {
  c.read();
}

void stop(){
  in.close();
  minim.stop();
  player.close();
  super.stop();
}

int showWave(int x){
    if(x >= 10){
    x+=200;
    strokeWeight(5);
    stroke(255,255, 255, 100);
    noFill();
    ellipse(displayWidth/2, displayHeight, x*2, x);
    //noFill();
    //stroke(255,255, 255, 100);
    //ellipse(displayWidth/2, displayHeight, (255-x)*2-x/4, x-x/4);
    //noFill();
    //stroke(255,255, 255, 100);
    //ellipse(displayWidth/2, displayHeight, x*2-x/3, x-x/3);
    strokeWeight(1);
    }
    return x;
}
