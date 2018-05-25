import ch.bildspur.artnet.*; //<>//
import ch.bildspur.artnet.packets.*;
import ch.bildspur.artnet.events.*;

/** 
 * By using LX Studio, you agree to the terms of the LX Studio Software
 * License and Distribution Agreement, available at: http://lx.studio/license
 *
 * Please note that the LX license is not open-source. The license
 * allows for free, non-commercial use.
 *
 * HERON ARTS MAKES NO WARRANTY, EXPRESS, IMPLIED, STATUTORY, OR
 * OTHERWISE, AND SPECIFICALLY DISCLAIMS ANY WARRANTY OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
 * PURPOSE, WITH RESPECT TO THE SOFTWARE.
 */

// ---------------------------------------------------------------------------
//
// Welcome to LX Studio! Getting started is easy...
// 
// (1) Quickly scan this file
// (2) Look at "Model" to define your model
// (3) Move on to "Patterns" to write your animations
// 
// ---------------------------------------------------------------------------

// Reference to top-level LX instance
heronarts.lx.studio.LXStudio lx;

void setup() {
  
  // Processing setup, constructs the window and the LX instance
  size(800, 720, P3D);
  
  
  //JSONObject stripData = this.loadJSONObject("mjut_atopie.json");
  //JSONObject stripData = this.loadJSONObject("two_strips_reverse_test.json");
  //JSONObject stripData = this.loadJSONObject("strips_overflow.json");
  //JSONObject stripData = this.loadJSONObject("strips_overflow_1.json");
  JSONObject stripData = this.loadJSONObject("strips_overflow_2.json");
  //JSONObject stripData = this.loadJSONObject("test.json");
  //JSONObject stripData = this.loadJSONObject("test.json");
  //JSONObject stripData = this.loadJSONObject("JSONStrip.json");
  //JSONObject stripData = this.loadJSONObject("JSONElement.json");
  //JSONObject stripData = this.loadJSONObject("JSONModel.json");
  //JSONObject stripData = this.loadJSONObject("two_strip_matrix.json");
  //JSONObject stripData = this.loadJSONObject("hammock_reactor.json");

  lx = new heronarts.lx.studio.LXStudio(this, buildModel(stripData), MULTITHREADED);
  lx.ui.setResizable(RESIZABLE);
  
  
}

void initialize(heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  
  try {
    LXDatagramOutput output = new LXDatagramOutput(lx);
    for(String ip : ArtnetConfig.storage.keySet()){
      for(int universe : ArtnetConfig.storage.get(ip).keySet()){
        ArtNetDatagram datagram = new ArtNetDatagram(ArtnetConfig.storage.get(ip).get(universe).indices, universe);
        datagram.setAddress(ip);
        datagram.setByteOrder(LXDatagram.ByteOrder.GRB);
        output.addDatagram(datagram);    
        System.out.println("############### " + universe + " #################");
        //printArray(ArtnetConfig.storage.get(ip).get(universe).indices);
      }
    }
    lx.addOutput(output);
  } catch (Exception x) {
    x.printStackTrace();
  }
  
}

void onUIReady(heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  // Add custom UI components here
}

void draw() {
  // All is handled by LX Studio
}

// Configuration flags
final static boolean MULTITHREADED = true;
final static boolean RESIZABLE = true;

// Helpful global constants
final static float INCHES = 1;
final static float IN = INCHES;
final static float FEET = 12 * INCHES;
final static float FT = FEET;
final static float CM = 2.54 * IN;
final static float MM = CM * .1;
final static float M = CM * 00;
