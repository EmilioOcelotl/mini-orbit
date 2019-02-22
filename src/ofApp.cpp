#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

  ofEnableAntiAliasing();
  ofEnableSmoothing();
  ofSetCircleResolution(50);
  ofBackground(0, 0, 0);
  //ofSetVerticalSync(true);
  ofSetWindowTitle("mini-orbit");
  ofSetFrameRate(30);
  //ofHideCursor();
  font.load("fonts/DejaVuSansMono.ttf", 20);
  
  //videoPath = ofToDataPath("video/0230.m4v", true);
  //ofLog() << "videoPath: " << videoPath;
  //Somewhat like ofFboSettings we may have a lot of options so this is the current model
  //settings.doFlipTexture = true;		//default false
  
  //so either pass in the settings
  //omxPlayer.setup(settings);
  
  //or live with the defaults
  //omxPlayer.loadMovie(videoPath);

    ofxOMXPlayerSettings settings;
    //settings.videoPath = videoPath[i];
    settings.useHDMIForAudio =false;	//default true
    settings.enableTexture = true;		//default true
    settings.enableLooping = true;		//default true
    settings.enableAudio = false;		//default true, save resources by disabling
    omxPlayer.setup(settings);
    omxPlayer2.setup(settings);
    omxPlayer3.setup(settings);
  
   for(int i = 0; i < LIM; i++){
    //}
      videoON[i] = 0;
      posX[i] = 0;
      posY[i] = 0;
      posZ[i] = 0;
      scale[i] = 1;
   
      
    }
  
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){

  ofEnableArbTex();
  ofEnableDepthTest();

  ofSetRectMode(OF_RECTMODE_CENTER);

  cam.begin();

  ofPushMatrix();
  
  if(videoON[0] == 1){
    ofTranslate(0, 0, posZ[0]);
    omxPlayer.draw((omxPlayer.getWidth()*(scale[0]*0.25)) + posX[0], (-omxPlayer.getHeight()*(scale[0]*0.25)) + posY[0], omxPlayer.getWidth() * (scale[0] * 1), omxPlayer.getHeight() * (scale[0] * 1));
    ofTranslate(0, 0, 0);
  }

  if(videoON[1] == 1){
    ofTranslate(0, 0, posZ[1]+1);
    omxPlayer2.draw((omxPlayer2.getWidth()*(scale[1]*0.25)) + posX[1], (-omxPlayer2.getHeight()*(scale[1]*0.25)) + posY[1], omxPlayer2.getWidth() * (scale[1] * 1), omxPlayer2.getHeight() * (scale[1] * 1));
    ofTranslate(0, 0, 0);
  }

  if(videoON[2] == 1){
    ofTranslate(0, 0, posZ[2]+2);
    omxPlayer3.draw((omxPlayer3.getWidth()*(scale[2]*0.25)) + posX[2], (-omxPlayer3.getHeight()*(scale[2]*0.25)) + posY[2], omxPlayer3.getWidth() * (scale[2] * 1), omxPlayer3.getHeight() * (scale[2] * 1));
    ofTranslate(0, 0);
  }

  ofPopMatrix();

  cam.end();
  
  ofDisableDepthTest();
  text = wrapString(clientTyping, 700);
  rect = font.getStringBoundingBox(text, 0, 0);
  font.drawString(text, (ofGetWidth()*0.5)-(rect.width*0.5), ((ofGetHeight()* 0.5)-(rect.height*0.5)));

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

  // if we didn't hit return, add the key to our string
  if(key != OF_KEY_RETURN){
    // some trickery: ignore the backspace key
    if(key != OF_KEY_BACKSPACE){
      clientTyping += key;
    }
    else{
      if(clientTyping.size() > 0){
	clientTyping.erase(clientTyping.end() - 1);
      }
    }
  }

  else{

    std::vector < std::string > textAnalisis = ofSplitString(clientTyping, " ");
    textAnalisis.push_back(clientTyping);

    if(textAnalisis[0] == "vload"){

      if(ofToInt(textAnalisis[1]) == 1){
	videoON[0]=1;
	videoPath[0] = ofToDataPath("video/"+textAnalisis[2], true);
	omxPlayer.loadMovie(videoPath[0]);
      }

      if(ofToInt(textAnalisis[1]) == 2){
	videoON[1] = 1;
	videoPath[1] = ofToDataPath("video/"+textAnalisis[2], true);
	omxPlayer2.loadMovie(videoPath[1]);
      }

      if(ofToInt(textAnalisis[1]) == 3){
	videoON[2] = 1;
	videoPath[2] = ofToDataPath("video/"+textAnalisis[2], true);
	omxPlayer3.loadMovie(videoPath[2]);
      }

    }

    if(textAnalisis[0] == "vfree"){
      if(ofToInt(textAnalisis[1])==1){
	omxPlayer.close();
	videoON[0] = 0;
	posX[0] = 0;
	posY[0] = 0;
	scale[0] = 0;
      }
      if(ofToInt(textAnalisis[1])==2){
	omxPlayer2.close();
	videoON[1] = 0;
	posX[1] = 0;
	posY[1] = 0;
	scale[1] = 0;
      }
      if(ofToInt(textAnalisis[1])==3){
	omxPlayer2.close();
	videoON[2] = 0;
	posX[2] = 0;
	posY[2] = 0;
	scale[2] = 0;
      }
    }
    
    if(textAnalisis[0] == "vpos"){
      posX[ofToInt(textAnalisis[1])-1] = ofToInt(textAnalisis[2]);
      posY[ofToInt(textAnalisis[1])-1] = ofToInt(textAnalisis[3]);
      posZ[ofToInt(textAnalisis[1])-1] = ofToInt(textAnalisis[4]);
    }

    
    if(textAnalisis[0] == "vscale"){
      scale[ofToInt(textAnalisis[1])-1] = ofToFloat(textAnalisis[2]);
    }
    
    clientTyping = "";

  }
  
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
