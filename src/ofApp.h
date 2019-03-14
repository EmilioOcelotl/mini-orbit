// Referencia 1 
#pragma once

#include "ofMain.h"
#include "ofxOMXPlayer.h"
#include "ofxOsc.h"

#define LIM 3

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();		
		void keyPressed(int key);

		//ofxOMXPlayer omxPlayer;

		ofxOMXPlayer omxPlayer;
		ofxOMXPlayer omxPlayer2;
		ofxOMXPlayer omxPlayer3;
		ofxOscReceiver reciever;
		ofxOscSender sender;
		string clientTyping;
		ofTrueTypeFont font;
		string text;
		ofRectangle rect;
		int videoON[LIM]; 
		//string videoPath;
		string videoPath[LIM];
		int posX[LIM];
		int posY[LIM];
	        float scale[LIM];
		int posZ[LIM];
		float opacity;

		ofEasyCam cam;

		// Referencia 2	
		
		string wrapString(string text, int width) {				      
		  string typeWrapped = "";
		  string tempString = "";
		  vector <string> words = ofSplitString(text, " ");
		  for(int i=0; i<words.size(); i++) {
		    string wrd = words[i];
		    cout << wrd << endl;
		    tempString += wrd + " ";
		    int stringwidth = font.stringWidth(tempString);
		    if(stringwidth >= width) {
		      tempString = "";
		      typeWrapped += "\n";
		    } 
		    typeWrapped += wrd + " ";
		  }  
		  return typeWrapped;  
		}	
};
