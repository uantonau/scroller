using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;

const mainFont = Application.loadResource(Rez.Fonts.Main);
const dateFont = Application.loadResource(Rez.Fonts.Date);
const mainFontHeight = Graphics.getFontHeight(mainFont);
var center = [0,0];
var canvas = [0,0];

//var bgColor = Graphics.COLOR_BLACK;
var marksColor = Graphics.COLOR_WHITE;

var activeColor = Graphics.COLOR_BLACK;
var inactiveColor = Graphics.COLOR_LT_GRAY;
var beltColor = Graphics.COLOR_WHITE;

//var bgColor = Graphics.COLOR_WHITE;
//var marksColor = Graphics.COLOR_BLACK;

//var activeColor = Graphics.COLOR_WHITE;
//var inactiveColor = Graphics.COLOR_RED;
//var beltColor = Graphics.COLOR_DK_RED;

class AppFaceView extends WatchUi.WatchFace {

    var minuteHand;
    var hourHand;
    var battery;
    
    var bgColor = Application.getApp().getProperty("BackgroundColor");
    
    var batSize = [24, 52];
    var hhSize = [72, 100];
    var mhSize = [72, 100];
    
    var batPosition;
    var hhPosition;
    var mhPosition;
    
    const spacing = [6,2];
    const batSpacing = [4,2];
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	// normalize sizes
    	batSize = Util.normPt(batSize, dc.getWidth(), dc.getHeight());
    	hhSize = Util.normPt(hhSize, dc.getWidth(), dc.getHeight());
    	mhSize = Util.normPt(mhSize, dc.getWidth(), dc.getHeight());
    
    	dc.setPenWidth(2);
    	canvas = [dc.getWidth(),dc.getHeight()];
    	center = [dc.getWidth()/2,dc.getHeight()/2];
    	
    	batPosition = [center[0]*18/10-batSize[0]/2,center[1]-batSize[1]/2];
    	hhPosition = [center[0]*68/100-hhSize[0]/2,center[1]-hhSize[1]/2];
    	mhPosition = [center[0]*132/100-mhSize[0]/2,center[1]-mhSize[1]/2];

		hourHand = new Scroller(hhPosition, hhSize, 59, dc.getWidth(), dc.getHeight());
    	minuteHand = new Scroller(mhPosition, mhSize, 59, dc.getWidth(), dc.getHeight());
//    	minuteHand.tick = [minuteHand.middle[0],minuteHand.pos[0]+minuteHand.siz[0]];
		battery = new BatteryScroller(batPosition, batSize, dc.getWidth(), dc.getHeight());
    }

    // Handle the update event
    function onUpdate(dc) {
    	dc.clearClip();
    	dc.setColor(bgColor, bgColor);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(hhPosition[0]-spacing[0], hhPosition[1]-spacing[1], hhSize[0]+2*spacing[0], hhSize[1]+2*spacing[1], 5);
        dc.fillRoundedRectangle(mhPosition[0]-spacing[0], mhPosition[1]-spacing[1], mhSize[0]+2*spacing[0], mhSize[1]+2*spacing[1], 5);
		dc.fillRoundedRectangle(batPosition[0]-batSpacing[0], batPosition[1]-batSpacing[1], batSize[0]+2*batSpacing[0], batSize[1]+2*batSpacing[1], 5);

        dc.setColor(marksColor, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(0, center[1], hhPosition[0]-spacing[0], center[1]);
        dc.drawLine(hhPosition[0]+hhSize[0]+spacing[0], center[1], mhPosition[0]-spacing[0], center[1]);
		dc.drawLine(mhPosition[0]+mhSize[0]+spacing[0], center[1], batPosition[0]-batSpacing[0], center[1]);
		dc.drawLine(batPosition[0]+batSize[0]+batSpacing[0], center[1], canvas[0], center[1]);

        dc.drawRoundedRectangle(hhPosition[0]-spacing[0], hhPosition[1]-spacing[1], hhSize[0]+2*spacing[0], hhSize[1]+2*spacing[1], 5);
        dc.drawRoundedRectangle(mhPosition[0]-spacing[0], mhPosition[1]-spacing[1], mhSize[0]+2*spacing[0], mhSize[1]+2*spacing[1], 5);
		dc.drawRoundedRectangle(batPosition[0]-batSpacing[0], batPosition[1]-batSpacing[1], batSize[0]+2*batSpacing[0], batSize[1]+2*batSpacing[1], 5);
        
    	var date = new Time.Moment(Time.today().value());
		var gregorianDate = Time.Gregorian.info(date, Time.FORMAT_SHORT);
		var day = gregorianDate.day;
		var dayOfWeek = gregorianDate.day_of_week;
		dc.drawText(center[0], canvas[1]*3/4, dateFont, getDayName(dayOfWeek) + " " + day, Graphics.TEXT_JUSTIFY_CENTER);
                
        var clockTime = System.getClockTime();
        
		hourHand.set(clockTime.hour,clockTime.min);
		hourHand.draw(dc);

		minuteHand.set(clockTime.min,clockTime.sec);
		minuteHand.draw(dc);
		
		var batteryLevel = (System.getSystemStats().battery + 0.5).toNumber();
		battery.set(batteryLevel);
		battery.draw(dc);
    }

    // Handle the partial update event
    function onPartialUpdate( dc ) {
        var clockTime = System.getClockTime();
        if (clockTime.sec%2 == 0) {
	        minuteHand.set(clockTime.min,clockTime.sec);
			minuteHand.draw(dc);
		}
		System.println("bgColor=" + bgColor);
    }
    
        // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        WatchUi.requestUpdate();
        System.println("onEnterSleep");
    }

    // This method is called when the device exits sleep mode.
    // Set the isAwake flag to let onUpdate know it should render the second hand.
    function onExitSleep() {
    	System.println("onExitSleep");
    }
    
	function refreshSettings() {
		// order is important
		minuteHand.refreshSettings();
		hourHand.refreshSettings();
		bgColor = Application.getApp().getProperty("BackgroundColor");
		System.println("SET bgColor=" + bgColor);
    }
    
    function getDayName(number) {
    	if (number == 1) {
    		return "sun";
    	} else if (number == 2) {
    		return "mon";
    	} else if (number == 3) {
    		return "tue";
    	} else if (number == 4) {
    		return "wed";
    	} else if (number == 5) {
    		return "thu";
    	} else if (number == 6) {
    		return "fri";
    	} else if (number == 7) {
    		return "sat";
    	}  else {
    		return "???";
    	}
    }
}