using Toybox.Graphics;
using Toybox.System;

class Scroller {
	var value;
	var oldValue;
	var partial;
	var shift;
	var mx;
	
	var pos;
	var siz;
	var dist;
	var clip;
	
	var prevY;
   	var currY;
   	var nextY;
   	var prevLineY;
   	var nextLineY;
   	var tick;
   	
   	var middle;
   	
   	var rotationDirection = Application.getApp().getProperty("RotationDirection");

	function initialize(position, size, max, width, height) {
		// normalize sizes here
		
		value = 0;
		partial = 0;
		shift = 0;
		
		pos = position;
		siz = size;
		dist = 60;
		
		middle = [pos[0]+siz[0]/2, pos[1]+siz[1]/2];
		
		currY = middle[1]-mainFontHeight-15;
		
		System.println("middle[1] " + middle[1]);
		System.println("currY " + currY);
		prevY = currY+dist;
		nextY = currY-dist;
		
		prevLineY = middle[1]-dist;
		nextLineY = middle[1];
		
		clip = [pos[0], pos[1], siz[0], siz[1]];
		
		tick = [pos[0],middle[0]];
		
		mx = max;
	}
	
	public function set(newValue,newPartial) {
		value = newValue;
		partial = newPartial;
		shift = partial*dist/60;
		if (rotationDirection > 0) {
			shift = partial*dist/60;
		} else {
			shift = dist - partial*dist/60;
		}
		
		System.println(shift);
	}

   	public function draw(dc) {
   				var rd = rotationDirection;
   	
				var nextMinute1 = value + 1 * rd > mx ? value - mx + 2 * rd : value + 1 * rd;
		   		var prevMinute1 = value - 1 * rd < 0 ? value + mx : value - 1 * rd;
		   		
		   		dc.setClip(clip[0],clip[1],clip[2],clip[3]);
		   		
		   		// belt
		   		dc.setColor(beltColor, beltColor);
		   		dc.clear();
		   		dc.fillRectangle(clip[0],clip[1],clip[2],clip[3]);
		   		
		   		// digits inactive
		   		dc.setColor(inactiveColor, Graphics.COLOR_TRANSPARENT);
				dc.drawText(middle[0], prevY+shift, mainFont, prevMinute1.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);
		   		dc.drawText(middle[0], nextY+shift, mainFont, nextMinute1.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);
		
				// digit active
				dc.setColor(activeColor, Graphics.COLOR_TRANSPARENT);
				dc.drawText(middle[0], currY+shift, mainFont, value.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);
				
				// ticks
				dc.setColor(activeColor, Graphics.COLOR_TRANSPARENT);
				dc.drawLine(tick[0], prevLineY+shift, tick[1], prevLineY+shift);
				dc.drawLine(tick[0], nextLineY+shift, tick[1], nextLineY+shift);
				
				dc.clearClip();
   	}
   	
   	public static function refreshSettings() {
   		rotationDirection = Application.getApp().getProperty("RotationDirection");
   	}
}