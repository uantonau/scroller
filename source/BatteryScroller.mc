using Toybox.Graphics;

class BatteryScroller {
	var pos;
	var siz;
	var tick;
	var batteryLevel;
	
	var battery;

	function initialize(position, size, screenWidth, screenHeight) {
		pos = position;
		siz = size;
		tick = [position[0]+3, position[0]+size[0]/2];
		battery = [
			[pos[0]+2,pos[1]+siz[1]],
			[pos[0]+2,pos[1]+4],
			[pos[0]+6,pos[1]+4],
			[pos[0]+6,pos[1]+0],
			[pos[0]+siz[0]-8,pos[1]+0],
			[pos[0]+siz[0]-8,pos[1]+4],
			[pos[0]+siz[0]-3,pos[1]+4],
			[pos[0]+siz[0]-3,pos[1]+siz[1]]
		];
	}
	
	function set(newBatteryLevel) {
		batteryLevel = newBatteryLevel;
	}
	
	function draw(dc) {
		var shift = (100 - batteryLevel) * siz[1] / 100;
	
		dc.setClip(pos[0],pos[1],siz[0],siz[1]); 
		
		dc.setColor(beltColor, Graphics.COLOR_TRANSPARENT);
		dc.fillRectangle(pos[0],pos[1],siz[0],siz[1]);

		dc.setColor(activeColor, Graphics.COLOR_TRANSPARENT);
		dc.fillPolygon(shiftPolygon(battery, shift));
		
		for (var i = 1; i<6; i++) {
			var y = siz[1]*i/6;
			dc.setColor(activeColor, Graphics.COLOR_TRANSPARENT);
			dc.drawLine(tick[0], pos[1]+shift-y, tick[1], pos[1]+shift-y);
			dc.setColor(beltColor, Graphics.COLOR_TRANSPARENT);
			dc.drawLine(tick[0], pos[1]+shift+y, tick[1], pos[1]+shift+y);
		}
		
		dc.clearClip();
	}
	
	function shiftPolygon(points, shift) {
		var newPoints = [];
		for (var i = 0; i < points.size(); i++) {
			newPoints.add([points[i][0],points[i][1]+shift]);
		}
		return newPoints;
	}
}
