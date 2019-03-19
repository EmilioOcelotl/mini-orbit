#include "ofApp.h"

//--------------------------------------------------------------
// Referencia 1
void ofApp::setup(){

  ofEnableAntiAliasing();
  ofEnableSmoothing();
  ofSetCircleResolution(50);
  ofBackground(0, 0, 0);
  //ofSetVerticalSync(true);
  ofSetWindowTitle("mini-orbit");
  ofSetFrameRate(30);
  cam.setDistance(300);
  //ofHideCursor();
  font.load("fonts/DejaVuSansMono.ttf", 20);
  sender.setup("127.0.0.1", 57120);
  reciever.setup(5612);
    ofxOMXPlayerSettings settings;
    settings.useHDMIForAudio =false;	//default true
    settings.enableTexture = true;		//default true
    settings.enableLooping = true;		//default true
    settings.enableAudio = false;		//default true, save resources by disabling
    omxPlayer.setup(settings);
    omxPlayer2.setup(settings);
    omxPlayer3.setup(settings);
    opacity = 200;
   for(int i = 0; i < LIM; i++){
      videoON[i] = 0;
      posX[i] = 0;
      posY[i] = 0;
      posZ[i] = 0;
      scale[i] = 1;
    }
}

//--------------------------------------------------------------
// Referencia 2
void ofApp::update(){

    while (reciever.hasWaitingMessages()){ 

        ofxOscMessage m;
        reciever.getNextMessage(&m);
	if (m.getAddress() == "\vload"  &&  m.getNumArgs() == 2){
	  if(m.getArgAsInt(0) == 1){
	    videoON[0]=1;
	    videoPath[0] = ofToDataPath("video/"+m.getArgAsString(1), true);
	    omxPlayer.loadMovie(videoPath[0]);
	  }
	  if(m.getArgAsInt(0) == 2){
	    videoON[1] = 1;
	    videoPath[1] = ofToDataPath("video/" + m.getArgAsString(1), true);
	    omxPlayer2.loadMovie(videoPath[1]);
	  }
	  if(m.getArgAsInt(0) == 3){
	    videoON[2] = 1;
	    videoPath[2] = ofToDataPath("video/" + m.getArgAsString(1), true);
	    omxPlayer3.loadMovie(videoPath[2]);
	  }
	}

	if (m.getAddress() == "\vfree"  &&  m.getNumArgs() == 1){  
	  if(m.getArgAsInt(0) == 1){
	    omxPlayer.close();
	    videoON[0] = 0;
	    posX[0] = 0;
	    posY[0] = 0;
	    scale[0] = 0;
	  }	  
	  if(m.getArgAsInt(0) == 2){
	    omxPlayer2.close();
	    videoON[1] = 0;
	    posX[1] = 0;
	    posY[1] = 0;
	    scale[1] = 0;
	  }  
	  if(m.getArgAsInt(0) == 3){
	    omxPlayer2.close();
	    videoON[2] = 0;
	    posX[2] = 0;
	    posY[2] = 0;
	    scale[2] = 0;
	  }
	}
	
	if (m.getAddress() == "\vpos"  &&  m.getNumArgs() == 4){
	  posX[m.getArgAsInt(0)-1] = m.getArgAsInt(1);
	  posY[m.getArgAsInt(0)-1] = m.getArgAsInt(2);
	  posZ[m.getArgAsInt(0)-1] = m.getArgAsInt(3);
	}

	if (m.getAddress() == "\vscale"  &&  m.getNumArgs() == 2){
	  scale[m.getArgAsInt(0)-1] = m.getArgAsFloat(0);
	}
	
	if (m.getAddress() == "\opacity"  &&  m.getNumArgs() == 1){
	  opacity = m.getArgAsFloat(0);
	}
    }
}

//--------------------------------------------------------------
// Referencia 3
void ofApp::draw(){
  
  ofEnableArbTex();
  ofEnableDepthTest();
  ofSetRectMode(OF_RECTMODE_CENTER);
  cam.begin();
  ofPushMatrix();
  ofSetColor(255, 255, 255, opacity);
  if(videoON[0] == 1){
    ofTranslate(0, 0, posZ[0]);
    omxPlayer.draw((omxPlayer.getWidth()*(scale[0]*0.25)) + posX[0], (-omxPlayer.getHeight()*(scale[0]*0.25)) + posY[0], omxPlayer.getWidth() * (scale[0] * 1.5), omxPlayer.getHeight() * (scale[0] * 1));
    ofTranslate(0, 0, 0);
  }
  if(videoON[1] == 1){
    ofTranslate(0, 0, posZ[1]+1);
    omxPlayer2.draw((omxPlayer2.getWidth()*(scale[1]*0.25)) + posX[1], (-omxPlayer2.getHeight()*(scale[1]*0.25)) + posY[1], omxPlayer2.getWidth() * (scale[1] * 1.5), omxPlayer2.getHeight() * (scale[1] * 1));
    ofTranslate(0, 0, 0);
  }
  if(videoON[2] == 1){
    ofTranslate(0, 0, posZ[2]+2);
    omxPlayer3.draw((omxPlayer3.getWidth()*(scale[2]*0.25)) + posX[2], (-omxPlayer3.getHeight()*(scale[2]*0.25)) + posY[2], omxPlayer3.getWidth() * (scale[2] * 1.5), omxPlayer3.getHeight() * (scale[2] * 1));
    ofTranslate(0, 0);
  }
  ofPopMatrix();
  cam.end();	
	
  ofSetColor(255, 255, 255, 255);
  ofDisableDepthTest();
  text = wrapString(clientTyping, 700);
  rect = font.getStringBoundingBox(text, 0, 0);
  font.drawString(text, (ofGetWidth()*0.5)-(rect.width*0.5), ((ofGetHeight()* 0.5)-(rect.height*0.5)));

}

//--------------------------------------------------------------
// Referencia 4
void ofApp::keyPressed(int key){

  if(key != OF_KEY_RETURN){
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

    if(textAnalisis[0] == "altamisa"){
      	ofxOscMessage m;
	m.setAddress("/bot1");
	m.addIntArg(1);
	sender.sendMessage(m, false);
    }
    
    if(textAnalisis[0] == "vscale"){
      scale[ofToInt(textAnalisis[1])-1] = ofToFloat(textAnalisis[2]);
    }
        
    if(textAnalisis[0] == "entrada"){
      ofxOscMessage m;
      m.setAddress("/entrada");
      m.addFloatArg(ofToFloat(textAnalisis[1]));
      sender.sendMessage(m, false);
    }

    
    clientTyping = "";

  }
  
}


