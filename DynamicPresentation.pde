/**
 * DynamicPresentation
 * by Nicolás Castro, Gustavo Galvis
 * 
 * Adapted from Dizzy and KeyFrameInterpolator examples
 * by Jean Pierre Charalambos.
 *
 * This example further demonstrates how 2D key frames may be used to perform a
 * Prezi-like presentation. As an additional feature, the interpolation stops at
 * every keyFrame in the path.
 *
 * To continue execution, one must simply press the key associated with that interpolation
 * path (namely 1, 2 or 3). It's also possible to run the paths in a non-sequential manner.
 *
 * Original description in the Dizzy example:
 *
 * The displayed eye path is defined by some interactive-frames which can
 * be moved with the mouse, making the path editable.
 *
 * The eye interpolating path is played with the shortcut '1'.
 *
 * Press CONTROL + '1' to add (more) key frames to the eye path.
 *
 * Press ALT + '1' to delete the eye path.
 *
 * Note that the eye actually holds 3 paths, bound to the [1..3] keys.
 * Pressing CONTROL + [1..3] adds key frames to the specific path.
 * Pressing ALT + [1..3] deletes the specific path. Press 'r' to display
 * all the key frame eye paths (if any). The displayed paths are editable.
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;
import remixlab.dandelion.geom.*;
import java.util.*;

Scene scene;
PImage img;
Info toggleInfo;
ArrayList<Info> info;
PFont font;
InteractiveFrame message1;
InteractiveFrame message2;
InteractiveFrame image;
float h;
int fSize = 16;
boolean[] stopAtKeyFrame = new boolean[3];
int[] currentFrame = new int[3];

public void setup() {
  size(640, 360, P2D);

  img = loadImage("presentation.png");
  scene = new Scene(this);
  scene.setGridVisualHint(false);
  scene.setAxesVisualHint(false);

  image = new InteractiveFrame(scene);

  image.setPosition(-314.30075f, -165.1348f);
  image.setOrientation(new Rot(-0.0136114275f));
  image.setMagnitude(0.07877492f);

  // create a camera path and add some key frames:
  // key frames can be added at runtime with keys [j..n]
  scene.loadConfig();
  font = loadFont("FreeSans-24.vlw");
  toggleInfo = new Info(new PVector(10, 7), font);
  info = new ArrayList<Info>();
  for (int i=0; i<3; ++i)
    info.add(new Info(new PVector(10, toggleInfo.height*(i+1) + 7*(i+2)), font, String.valueOf(i+1)));
  
  // initialize boolean and int arrays
  for (int i = 0; i < 3; i++) {
    stopAtKeyFrame[i] = true;
    currentFrame[i] = 1;
  }
}

public void draw() {
  background(0);
  fill(204, 102, 0);

  pushMatrix();
  image.applyTransformation();// optimum
  image(img, 0, 0);
  popMatrix();

  for (int j = 0; j < 3; j++) {
    if (scene.eye().keyFrameInterpolator(j+1) != null) {
      if (scene.eye().keyFrameInterpolator(j+1).interpolationTime() >= scene.eye().keyFrameInterpolator(j+1).keyFrameTime(currentFrame[j]-1) && stopAtKeyFrame[j] == true) {
        System.out.println("Time: " + scene.eye().keyFrameInterpolator(j+1).interpolationTime());
        scene.eye().keyFrameInterpolator(j+1).stopInterpolation();
        stopAtKeyFrame[j] = false;
      }
    }
    else currentFrame[j] = 1;
  }
  
  info();
}

void info() {
  toggleInfo.setText("Camera paths edition "
                     + ( scene.pathsVisualHint() ? "ON" : "OFF" )
                     + " (press 'r' to toggle it)");
  toggleInfo.display();
  for (int i = 0; i < info.size(); i++)
    // Check if CameraPathPlayer is still valid
    if (scene.eye().keyFrameInterpolator(i+1) != null) {
      info.get(i).setText("Path " + String.valueOf(i+1) + "( press " + String.valueOf(i+1) + " to" +
                           (scene.eye().keyFrameInterpolator(i+1).numberOfKeyFrames() > 1 ?
                           scene.eye().keyFrameInterpolator(i+1).interpolationStarted() ?
                           " stop it)" : " play it)"
                           : " restore init position)"));
      info.get(i).display();
    }
}

public void keyPressed() {
  if ((key == '1')) {
    if (scene.eye().keyFrameInterpolator(1) != null && stopAtKeyFrame[0] == false) {
      stopAtKeyFrame[0] = true;
      if (currentFrame[0] <= scene.eye().keyFrameInterpolator(1).numberOfKeyFrames()-1) 
        currentFrame[0]++;
      else
        currentFrame[0] = 1;
    }
  }
  if ((key == '2')) {
    if (scene.eye().keyFrameInterpolator(2) != null && stopAtKeyFrame[1] == false) {
      stopAtKeyFrame[1] = true;
      if (currentFrame[1] <= scene.eye().keyFrameInterpolator(2).numberOfKeyFrames()-1) 
        currentFrame[1]++;
      else
        currentFrame[1] = 1;
    }
  }
  if ((key == '3')) {
    System.out.println("Current Frame Pre: " + currentFrame[2]);
    if (scene.eye().keyFrameInterpolator(3) != null && stopAtKeyFrame[2] == false) {
      System.out.println("kfi 3 vivo");
      stopAtKeyFrame[2] = true;
      if (currentFrame[2] <= scene.eye().keyFrameInterpolator(3).numberOfKeyFrames()-1) 
        currentFrame[2]++;
      else
        currentFrame[2] = 1;
      System.out.println("Current Frame Post: " + currentFrame[2]);
    }
  }
}