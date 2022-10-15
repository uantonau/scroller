using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Math;

class Util {
	private static const refWidth = 280;
	private static const refHeight = 280;
    
    public static function norm(number, actualWidth, actualHeight) {
    	if (actualWidth > actualHeight) {
    		return number.toFloat() * actualHeight / refHeight;
    	} else {
    		return number.toFloat() * actualWidth / refWidth;
    	}
    }
    
    public static function normPt(point, actualWidth, actualHeight) {
		var x = point[0].toFloat() * actualWidth / refWidth;
		var y = point[1].toFloat() * actualHeight / refHeight;
		return [x, y];
    }
    
    public static function normPts(points, actualWidth, actualHeight) {
    	var newPoints = [];
        for (var i = 0; i < points.size(); i++) {
        	newPoints.add(normPt(points[i], actualWidth, actualHeight));
    	}
    	return newPoints;
    }
}