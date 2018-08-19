var ip = "192.168.1.2";

var side_panel = [];
for (i=0; i<5; i++) {
  var rev = !(i%2);
  var strip = {
    "name"    : "side_panel_strip_"+i,
    "leds"    : 60,
    // "artnet"	: { "ip":ip, "universe": i, "address": 0, reverse: rev},
    "start"	  : { "x": 0, "y": 4000, "z": i*300},
    "end"     : { "x": 0, "y": 2000, "z": i*300}
  }
  side_panel.push(strip);
}

var side_panels_right = [];
for (var i = 0; i < 5; i++) {
  var panel = {
    "name": "Side Panel Right " + i,
    "x": 4500,
    "y": 0,
    "z": i * 1500,
    "group": "right panels",
    "strips": side_panel
  };

  side_panels_right.push(panel);
}

var side_panels_left = [];
for (var i = 0; i < 5; i++) {
  var panel = {
    "name": "Side Panel Left" + i,
    "x": -4500,
    "y": 0,
    "z": i * 1500,
    "group": "left panels",
    "strips": side_panel
  };

  side_panels_right.push(panel);
}

var back_panel = [];
for (i=0; i<5; i++) {
  var rev = !(i%2);
  var strip = {
    "name"    : "back_panel_strip_"+i,
    "leds"    : 90,
    // "artnet"	: { "ip":ip, "universe": i, "address": 0, reverse: rev},
    "start"	  : { "x": i*300, "y": 4000, "z": 0},
    "end"     : { "x": i*300, "y": 1000, "z": 0}
  }
  back_panel.push(strip);
}

var back_panels = [];
for (var i = 0; i < 6; i++) {
  var panel = {
    "name": "Back Panel " + i,
    "x": -4500 + i * 1500,
    "y": 0,
    "z": 7500,
    "group": "back panels",
    "strips": back_panel
  };

  back_panels.push(panel);
}
// var ring_top = [];
// for(i=0; i<12;i++){ // i=0, i<12
//   var rev = !(i%2)
//   var strip =         {
//             "name"    : "ring_top_"+i,
//   					"leds"    : 90,
//   					"artnet"	: { "ip":ip, "universe": i*2, "address": 0, reverse: rev},
//   					"start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
//   					"end"     : { "x": vertices_top[(i+1)%vertices_top.length][0], "y":3000,    "z": vertices_top[(i+1)%vertices_top.length][1] }
//   				}
//   ring_top.push(strip);
// }

// var ring_bottom = [];
// for(i=0; i<12;i++){
//   var strip = 				{
//             "name"    : "ring_bottom_"+i,
//   					"leds"    : 90,
//   					"artnet"	: { "ip":ip, "universe": 0, "offset": 0},
//   					"start"	  : { "x": vertices_bottom[i][0],	  "y": 0, "z":vertices_bottom[i][1]},
//   					"end"     : { "x": vertices_bottom[(i+1)%vertices_bottom.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_bottom.length][1] }
//   				}
//   ring_bottom.push(strip);
// }

// var triangles = [];
// for(i=0; i<12;i++){ // i=1; i<12
//   var rev = !(i%2);
//
//   if(rev) {
//     var strip = 				{
//               "name"    : "triangle_"+i,
//     					"leds"    : 90,
//     					"artnet"	: { "ip":ip, "universe": i*2, "offset": 90, "reverse": false},
//     					"start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
//     					"end"     : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] }
//     				};
//     triangles.push(strip);
//     var strip = 				{
//               "name"    : "triangle_"+i+"_2",
//     					"leds"    : 90,
//     					"artnet"	: { "ip":ip, "universe": i*2 + 1, "offset": 10, "reverse": false},
//     					"start"   : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] },
//               "end"	    : { "x": vertices_top[(i+1)%vertices_top.length][0],	  "y": 3000, "z":vertices_top[(i+1)%vertices_top.length][1]}
//     				}
//     triangles.push(strip);
//   }else {
//
//     var strip = 				{
//               "name"    : "triangle_"+i,
//     					"leds"    : 90,
//     					"artnet"	: { "ip":ip, "universe": i*2 + 1, "offset": 10, "reverse": true},
//               "start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
//               "end"     : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] }
//     				};
//     triangles.push(strip);
//
//     // Bug with reverse overflow!
//     var strip = 				{
//               "name"    : "triangle_"+i+"_2",
//     					"leds"    : 90,
//     					"artnet"	: { "ip":ip, "universe": i*2, "offset": 90, "reverse": true},
//     					"start"   : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] },
//               "end"	    : { "x": vertices_top[(i+1)%vertices_top.length][0],	  "y": 3000, "z":vertices_top[(i+1)%vertices_top.length][1]}
//     				}
//     triangles.push(strip);
//
//   }
// }
//
// var tower = [];
// for(i=0; i<6;i++){
//   var universe_offset = 52;
//   var strip = 				{
//             "name"    : "line_"+i,
//   					"leds"    : 90,
//   					"artnet"	: { "ip":ip, "universe": universe_offset + i*2, "offset": 0, "reverse": false},
//             "start"     : { "x": tower_bottom[i][0], "y": 0,    "z": tower_bottom[i][1] },
//   					"end"	  : { "x": tower_top[i][0],	  "y": 3000, "z":tower_top[i][1]}
//   				};
//   tower.push(strip);
//   var strip = 				{
//             "name"    : "line_"+i+"_2",
//   					"leds"    : 90,
//   					"artnet"	: { "ip":ip, "universe": universe_offset + i*2, "offset": 90, "reverse": false},
//   					"start"	  : { "x": tower_top_1[i][0],	  "y": 3000, "z":tower_top_1[i][1]},
//   					"end"     : { "x": tower_bottom_1[i][0], "y": 0,    "z": tower_bottom_1[i][1] }
//   				}
//   tower.push(strip);
// }

var tardis = {
	"elements": [
		// {
		// 	"name": "Ring Bottom",
		// 	"x":0,
		// 	"y":0,
		// 	"strips": ring_bottom
		// },
		// {
		// 	"name": "Ring Top",
		// 	"x":0,
		// 	"y":0,
		// 	"strips": ring_top
		// },
    // {
		// 	"name": "Triangles",
		// 	"x":0,
		// 	"y":0,
		// 	"strips": triangles
    // },



    // {
		// 	"name": "Side Panel",
		// 	"x": 4500,
		// 	"y": 0,
    //   "z": 0,
    //   "group": "right panels",
		// 	"strips": side_panel
    // },
    // {
		// 	"name": "Side Panel 2",
		// 	"x": 4500,
		// 	"y": 0,
    //   "z": 1500,
    //   "group": "right panels",
		// 	"strips": side_panel
    // }


  ]
}
tardis.elements = tardis.elements.concat(side_panels_right);
tardis.elements = tardis.elements.concat(side_panels_left);
tardis.elements = tardis.elements.concat(back_panels);

var json = JSON.stringify(tardis, null, ' ');

var fs = require('fs');
fs.writeFile('./charma_tardis.json', json, 'utf8', function(){

});
