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

function create_back_panel_center(universe) {
  var back_panel = [];
  for (var i=0; i<5; i++) {
    var rev = !!(i%2);
    var universe_shift = Math.floor( (i*90) / 170 );
    var offset_shifted = (i*90) % 170;

    var strip = {
      "name"    : "back_panel_center_strip_"+i,
      "leds"    : 90,
      "artnet"	: { "ip":ip, "universe": universe+universe_shift, "offset": offset_shifted, reverse: rev},
      "start"	  : { "x": 150+i*300, "y": 4000, "z": 0},
      "end"     : { "x": 150+i*300, "y": 1000, "z": 0}
    }
    back_panel.push(strip);
  }
  return back_panel;
}

function back_panels_center(universes_per_output, universe_offset) {
  var back_panels = [];
  for (var i = 0; i < 2; i++) {
    var panel = {
      "name": "Back Panel Center " + i,
      "x": -1500 + i * 1500,
      "y": 0,
      "z": 10000,
      "group": "back_panels",
      "strips": create_back_panel_center(universe_offset+(i*2)*universes_per_output)
    };

    back_panels.push(panel);
  }
  return back_panels;
}

function create_back_panel_left(universe) {
  var back_panel = [];
  for (var i=0; i<5; i++) {
    var rev = !!(i%2);
    var universe_shift = Math.floor( (i*90) / 170 );
    var offset_shifted = (i*90) % 170;

    var strip = {
      "name"    : "back_panel_left_strip_"+i,
      "leds"    : 90,
      "artnet"	: { "ip":ip, "universe": universe+universe_shift, "offset": offset_shifted, reverse: rev},
      "start"	  : { "x": i*212, "y": 4000, "z": i*212},
      "end"     : { "x": i*212, "y": 1000, "z": i*212}
    }
    back_panel.push(strip);
  }
  return back_panel;
}

function back_panels_left(universes_per_output, universe_offset) {
  var back_panels = [];
  for (var i = 0; i < 2; i++) {
    var panel = {
      "name": "Back Panel Left " + i,
      "x": -3600 + i * 1100,
      "y": 0,
      "z": 8000 + i * 1100,
      "group": "back_panels",
      "strips": create_back_panel_left(universe_offset+(i*2)*universes_per_output)
    };

    back_panels.push(panel);
  }
  return back_panels;
}
function create_back_panel_right(universe) {
  var back_panel = [];
  for (var i=0; i<5; i++) {
    var rev = !!(i%2);
    var universe_shift = Math.floor( (i*90) / 170 );
    var offset_shifted = (i*90) % 170;

    var strip = {
      "name"    : "back_panel_left_strip_"+i,
      "leds"    : 90,
      "artnet"	: { "ip":ip, "universe": universe+universe_shift, "offset": offset_shifted, reverse: rev},
      "start"	  : { "x": i*212, "y": 4000, "z": -i*212},
      "end"     : { "x": i*212, "y": 1000, "z": -i*212}
    }
    back_panel.push(strip);
  }
  return back_panel;
}

function back_panels_right(universes_per_output, universe_offset) {
  var back_panels = [];
  for (var i = 0; i < 2; i++) {
    var panel = {
      "name": "Back Panel Left " + i,
      "x": 1600 + i * 1100,
      "y": 0,
      "z": 10000 - i * 1100,
      "group": "back_panels",
      "strips": create_back_panel_right(universe_offset+(i*2)*universes_per_output)
    };

    back_panels.push(panel);
  }
  return back_panels;
}

function create_pillar(universe, universes_per_output){
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

    var strip = {
      "name"    : "pillar_strip_"+i,
      "leds"    : 30,
      "artnet"	: { "ip":ip, "universe": universe + universe_shift, "offset": offset_shifted, reverse: rev},
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
      x = -1650 + i * 1500;
      z = 1000;
    }
    if( i >= 3 && i < 6 ) {
      x = -1650 + (i%3) * 1500;
      z = 2000;
    }
    if( i >= 6 && i < 9 ) {
      x = -1650 + (i%3) * 1500;
      z = 3000;
    }
    if( i >= 9 && i < 12 ) {
      x = -1650 + (i%3) * 1500;
      z = 4000;
    }

    var p = {
      "name": "Pillar " + i,
      "x": x,
      "y": 0,
      "z": z,
      "group": "pillars",
      "strips": create_pillar(universe_offset + i*universes_per_output, universes_per_output) // 3 universes per output
    };

    pillars.push(p);
  }
  return pillars;
}

var tardis = {
  "name": "tardis",
	"elements": []
}
tardis.elements = tardis.elements.concat(side_panels_right(3, 0));
tardis.elements = tardis.elements.concat(side_panels_left(3, 18));
tardis.elements = tardis.elements.concat(back_panels_left(3, 36));
tardis.elements = tardis.elements.concat(back_panels_center(3, 42));
tardis.elements = tardis.elements.concat(back_panels_right(3, 51));
// tardis.elements = tardis.elements.concat(pillars(3, 60));

var json = JSON.stringify(tardis, null, ' ');

var fs = require('fs');
fs.writeFile('./charma_tardis.json', json, 'utf8', function(){

});
