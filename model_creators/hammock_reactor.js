var CSV = require('csv-string');


// create vertices with https://www.mathopenref.com/coordpolycalc.html

// with String
const vertices_top = CSV.parse('11591,-31068485,-8485\n3106,-11591\n-3106,-11591\n-8485,-8485\n-11591,-3106\n-11591,3106\n-8485,8485\n-3106,11591\n3106,11591\n8485,8485\n11591,3106');
const vertices_bottom = CSV.parse('2588,-9659\n-2588,-9659\n-7071,-7071\n-9659,-2588\n-9659,2588\n-7071,7071\n-2588,9659\n2588,9659\n7071,7071\n9659,2588\n9659,-2588\n7071,-7071');
// console.log(vertices_top);
// console.log(vertices_bottom);

var ring_top = [];
for(i=0; i<12;i++){
  var strip = 				{
            "name"    : "ring_top_"+i,
  					"leds"    : 90,
  					"artnet"	: { "ip":"127.0.0.2", "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
  					"end"     : { "x": vertices_top[(i+1)%vertices_top.length][0], "y":3000,    "z": vertices_top[(i+1)%vertices_top.length][1] }
  				}
  ring_top.push(strip);
}

var ring_bottom = [];
for(i=0; i<12;i++){
  var strip = 				{
            "name"    : "ring_bottom_"+i,
  					"leds"    : 90,
  					"artnet"	: { "ip":"127.0.0.2", "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_bottom[i][0],	  "y": 0, "z":vertices_bottom[i][1]},
  					"end"     : { "x": vertices_bottom[(i+1)%vertices_bottom.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_bottom.length][1] }
  				}
  ring_bottom.push(strip);
}

var triangles = [];
for(i=0; i<12;i++){
  var strip = 				{
            "name"    : "triangle_"+i,
  					"leds"    : 90,
  					"artnet"	: { "ip":"127.0.0.2", "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_top[i][0],	  "y": 3000, "z":vertices_top[i][1]},
  					"end"     : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] }
  				};
  triangles.push(strip);
  var strip = 				{
            "name"    : "triangle_"+i+"_2",
  					"leds"    : 90,
  					"artnet"	: { "ip":"127.0.0.2", "universe": 0, "address": 0},
  					"start"	  : { "x": vertices_top[(i+1)%vertices_top.length][0],	  "y": 3000, "z":vertices_top[(i+1)%vertices_top.length][1]},
  					"end"     : { "x": vertices_bottom[(i+1)%vertices_top.length][0], "y": 0,    "z": vertices_bottom[(i+1)%vertices_top.length][1] }
  				}
  triangles.push(strip);
}

var reactor = {
	"elements": [
		{
			"name": "Ring Bottom",
			"x":0,
			"y":0,
			"strips": ring_bottom
		},
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
			"strips": [
      ]
    }

  ]
}

var json = JSON.stringify(reactor);
console.log(json);

var fs = require('fs');
fs.writeFile('hammock_reactor.json', json, 'utf8', function(){});
