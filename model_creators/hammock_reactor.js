var CSV = require('csv-string');

var ip = "192.168.1.2";

/*export interface polygonConfig {
  n: number; // number of vertices = number of sides
  r: number; // radius (circumscribed circle)

  // could be optional attributes, but need default values TODO: find out how to create default values
  a: number; // counterclockwise rotation angle in radians
  cx: number; // center x (offset)
  cy: number; // center y (offset)
  // round: number; // number of decimal places to keep (0-20)
}*/

/*
 * inspiration: http://math.stackexchange.com/questions/1123175
 * and: https://stackoverflow.com/questions/3436453/calculate-coordinates-of-a-regular-polygons-vertices
 * and: https://gist.github.com/jonthesquirrel/e2807811d58a6627ded4
 * usage: calcPolygon({n: 3, r: 50, a: 0, cx: 0, cy: 0, round: 0})
*/
function calcPolygon(input) {
  let polygon = [];
  for (let i = 1; i <= input.n; i++) {
    polygon.push(
      // ((input.r * Math.cos(input.a + 2 * i * Math.PI / input.n)) + input.cx).toFixed(input.round),
      // ((input.r * Math.sin(input.a + 2 * i * Math.PI / input.n)) + input.cy).toFixed(input.round)
      [
        ((input.r * Math.cos(input.a + 2 * i * Math.PI / input.n)) + input.cx),
        ((input.r * Math.sin(input.a + 2 * i * Math.PI / input.n)) + input.cy)
      ]
    )
  }
  return polygon;
}

// create vertices with https://www.mathopenref.com/coordpolycalc.html

// with String
//const vertices_top = CSV.parse('11591,-3106\n8485,-8485\n3106,-11591\n-3106,-11591\n-8485,-8485\n-11591,-3106\n-11591,3106\n-8485,8485\n-3106,11591\n3106,11591\n8485,8485\n11591,3106');
//const vertices_bottom = CSV.parse('2588,-9659\n-2588,-9659\n-7071,-7071\n-9659,-2588\n-9659,2588\n-7071,7071\n-2588,9659\n2588,9659\n7071,7071\n9659,2588\n9659,-2588\n7071,-7071');
// console.log(vertices_top);
// console.log(vertices_bottom);
let vertices_top = calcPolygon({
  n: 12,
  r: 12000,
  a: 0,
  cx: 0,
  cy: 0
});
let vertices_bottom = calcPolygon({
  n: 12,
  r: 11000,
  a: -0.3,
  cx: 0,
  cy: 0
});

let tower_top = calcPolygon({
  n: 6,
  r: 3500,
  a: 0,
  cx: 0,
  cy: 0
});
let tower_bottom = calcPolygon({
  n: 6,
  r: 4000,
  a: 0,
  cx: 0,
  cy: 0
});

let tower_top_1 = calcPolygon({
  n: 6,
  r: 3500,
  a: 0.1,
  cx: 0,
  cy: 0
});
let tower_bottom_1 = calcPolygon({
  n: 6,
  r: 4000,
  a: 0.1,
  cx: 0,
  cy: 0
});

var ring_top = [];
for(i=0; i<12;i++){
  var strip = 				{
            "name"    : "ring_top_"+i,
  					"leds"    : 90,
  					"artnet"	: { "ip":ip, "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
  					"end"     : { "x": vertices_top[(i+1)%vertices_top.length][0], "y":3000,    "z": vertices_top[(i+1)%vertices_top.length][1] }
  				}
  ring_top.push(strip);
}

// var ring_bottom = [];
// for(i=0; i<12;i++){
//   var strip = 				{
//             "name"    : "ring_bottom_"+i,
//   					"leds"    : 90,
//   					"artnet"	: { "ip":ip, "universe": 0, "address": 0},
//   					"start"	  : { "x": vertices_bottom[i][0],	  "y": 0, "z":vertices_bottom[i][1]},
//   					"end"     : { "x": vertices_bottom[(i+1)%vertices_bottom.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_bottom.length][1] }
//   				}
//   ring_bottom.push(strip);
// }

var triangles = [];
for(i=0; i<12;i++){
  var strip = 				{
            "name"    : "triangle_"+i,
  					"leds"    : 90,
  					"artnet"	: { "ip":ip, "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
  					"end"     : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] }
  				};
  triangles.push(strip);
  var strip = 				{
            "name"    : "triangle_"+i+"_2",
  					"leds"    : 90,
  					"artnet"	: { "ip":ip, "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_top[(i+1)%vertices_top.length][0],	  "y": 3000, "z":vertices_top[(i+1)%vertices_top.length][1]},
  					"end"     : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] }
  				}
  triangles.push(strip);
}

var tower = [];
for(i=0; i<6;i++){
  var strip = 				{
            "name"    : "line_"+i,
  					"leds"    : 90,
  					"artnet"	: { "ip":ip, "universe": 0, "address": 0},
  					"start"	  : { "x": tower_top[i][0],	  "y": 3000, "z":tower_top[i][1]},
  					"end"     : { "x": tower_bottom[i][0], "y": 0,    "z": tower_bottom[i][1] }
  				};
  tower.push(strip);
  var strip = 				{
            "name"    : "line_"+i+"_2",
  					"leds"    : 90,
  					"artnet"	: { "ip":ip, "universe": 0, "address": 0},
  					"start"	  : { "x": tower_top_1[i][0],	  "y": 3000, "z":tower_top_1[i][1]},
  					"end"     : { "x": tower_bottom_1[i][0], "y": 0,    "z": tower_bottom_1[i][1] }
  				}
  tower.push(strip);
}

var reactor = {
	"elements": [
		// {
		// 	"name": "Ring Bottom",
		// 	"x":0,
		// 	"y":0,
		// 	"strips": ring_bottom
		// },
		{
			"name": "Ring Top",
			"x":0,
			"y":0,
			"strips": ring_top
		},
    {
			"name": "Triangles",
			"x":0,
			"y":0,
			"strips": triangles
    },
		{
			"name": "Tower top to bottom",
			"x":0,
			"y":0,
			"strips": tower
    }

  ]
}

var json = JSON.stringify(reactor);

var fs = require('fs');
fs.writeFile('./hammock_reactor.json', json, 'utf8', function(){

});
