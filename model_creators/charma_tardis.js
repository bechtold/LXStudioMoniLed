var ip = "192.168.1.2";

function create_side_panel(universe) {
  var side_panel = [];
  for (var i=0; i<5; i++) {
    var rev = !!(i%2);
    var universe_shift = Math.floor( (i*60) / 170 );
    var offset_shifted = (i*60) % 170;

    var strip = {
      "name"    : "side_panel_strip_"+i,
      "leds"    : 60,
      "artnet"	: { "ip":ip, "universe": universe+universe_shift, "offset": offset_shifted, reverse: rev},
      "start"	  : { "x": 0, "y": 4000, "z": i*300},
      "end"     : { "x": 0, "y": 2000, "z": i*300}
    }
    side_panel.push(strip);
  }
  return side_panel;
}

function side_panels_right(universes_per_output, universe_offset) {
  var side_panels_right = [];
  for (var i = 0; i < 5; i++) {
    var panel = {
      "name": "Side Panel Right " + i,
      "x": 4500,
      "y": 0,
      "z": i * 1500,
      "group": "right_panels",
      "strips": create_side_panel(universe_offset+i*3)
    };

    side_panels_right.push(panel);
  }
  return side_panels_right;
}

function side_panels_left(universes_per_output, universe_offset) {
  var side_panels_left = [];
  for (var i = 0; i < 5; i++) {
    var panel = {
      "name": "Side Panel Left " + i,
      "x": -4500,
      "y": 0,
      "z": i * 1500,
      "group": "left_panels",
      "strips": create_side_panel(universe_offset+(i*3))
    };

    side_panels_left.push(panel);
  }
  return side_panels_left;
}

function create_back_panel(universe) {
  var back_panel = [];
  for (var i=0; i<5; i++) {
    var rev = !!(i%2);
    var universe_shift = Math.floor( (i*90) / 170 );
    var offset_shifted = (i*90) % 170;

    var strip = {
      "name"    : "back_panel_strip_"+i,
      "leds"    : 90,
      "artnet"	: { "ip":ip, "universe": universe+universe_shift, "offset": offset_shifted, reverse: rev},
      "start"	  : { "x": 150+i*300, "y": 4000, "z": 0},
      "end"     : { "x": 150+i*300, "y": 1000, "z": 0}
    }
    back_panel.push(strip);
  }
  return back_panel;
}

function back_panels(universes_per_output, universe_offset) {
  var back_panels = [];
  for (var i = 0; i < 6; i++) {
    var panel = {
      "name": "Back Panel " + i,
      "x": -4500 + i * 1500,
      "y": 0,
      "z": 7500,
      "group": "back_panels",
      "strips": create_back_panel(universe_offset+i*universes_per_output)
    };

    back_panels.push(panel);
  }
  return back_panels;
}

function create_pillar(universe, universes_per_output, universe_offset){
  var pillar = [];
  for (var i=0; i<12; i++) {

    var x = 0, z = 0;
    if ( i < 3 ) {
      x = 300 - (50 + i * 100);
      z = 0;
    }
    if( i >= 3 && i < 6 ) {
      x = 0;
      z = 50 + (i%3) * 100;
    }
    if( i >= 6 && i < 9 ) {
      x = 50 + (i%3) * 100;
      z = 300;
    }
    if( i >= 9 && i < 12 ) {
      x = 300;
      z = 300 - (50 + (i%3) * 100);
    }

    var rev = !!(i%2);

    var universe_shift = Math.floor( (i*30) / 170 );
    var offset_shifted = (i*30) % 170;
    // console.log("jo");
    // console.log(i*30);
    // console.log(universes_per_output*170);
    // console.log(universe_shift);
    // console.log(offset_shift);

    var strip = {
      "name"    : "pillar_strip_"+i,
      "leds"    : 30,
      "artnet"	: { "ip":ip, "universe": universe + universe_shift, "offset": offset_shifted, reverse: rev},
      // "artnet"	: { "ip":ip, "universe": universe, "offset": i*30, reverse: rev},
      "start"	  : { "x": x, "y": 4000, "z": z},
      "end"     : { "x": x, "y": 3000, "z": z}
    }
    pillar.push(strip);
  }
  return pillar;
}

function pillars(universes_per_output, universe_offset) {
  var pillars = [];
  for (var i = 0; i < 12; i++) {
    var x = 0, z = 0;
    if ( i < 3 ) {
      x = -1500 + i * 1500;
      z = 1000;
    }
    if( i >= 3 && i < 6 ) {
      x = -1500 + (i%3) * 1500;
      z = 2000;
    }
    if( i >= 6 && i < 9 ) {
      x = -1500 + (i%3) * 1500;
      z = 3000;
    }
    if( i >= 9 && i < 12 ) {
      x = -1500 + (i%3) * 1500;
      z = 4000;
    }

    var p = {
      "name": "Pillar " + i,
      "x": x,
      "y": 0,
      "z": z,
      "group": "pillars",
      "strips": create_pillar(universe_offset + i*universes_per_output, universes_per_output, universe_offset) // 3 universes per output
    };

    pillars.push(p);
  }
  return pillars;
}
// var ring_top = [];
// for(i=0; i<12;i++){ // i=0, i<12
//   var rev = !(i%2)
//   var strip =         {
//             "name"    : "ring_top_"+i,
//   					"leds"    : 90,
//   					"artnet"	: { "ip":ip, "universe": i*2, "offset": 0, reverse: rev},
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
  "name": "tardis",
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
// tardis.elements = tardis.elements.concat(side_panels_right(3, 0));
// tardis.elements = tardis.elements.concat(side_panels_left(3, 0));
tardis.elements = tardis.elements.concat(back_panels(3, 0));
// tardis.elements = tardis.elements.concat(pillars(3, 0));

var json = JSON.stringify(tardis, null, ' ');

var fs = require('fs');
fs.writeFile('./charma_tardis.json', json, 'utf8', function(){

});
