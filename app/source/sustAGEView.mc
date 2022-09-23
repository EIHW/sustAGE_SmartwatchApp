// Author: Adria Mallol-Ragolta, Thomas Wiest, 2019-2020

using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;
using Toybox.ActivityRecording; 

// Declaration of variables that will run all over the program
var currentDate = null;
var currentTime = null;
var currentHR = null; 
var recString = null;

function requestDisplayUpdate() {
	WatchUi.requestUpdate();
}

class sustAGEView extends WatchUi.View {

	var connectionIcon;
	var recIcon; 

	function updateDisplay(dc){
		var currentTime2display = Gregorian.info(Time.now(), Time.FORMAT_LONG);
	        
	    var dateString = Lang.format("$1$, $2$ $3$ $4$", 
	    				[currentTime2display.day_of_week,
	    				currentTime2display.day,
	    				currentTime2display.month,
	    				currentTime2display.year]);
	    				
	    var timeString = Lang.format("$1$:$2$:$3$", 
	    				[currentTime2display.hour,
	    				currentTime2display.min.format("%02d"),
	    				currentTime2display.sec.format("%02d")]);
	    				
	    currentDate = new WatchUi.Text({
	    	:text=>dateString,
	    	:color=>Graphics.COLOR_WHITE,
	    	:font=>Graphics.FONT_SMALL,
	    	:locX=>WatchUi.LAYOUT_HALIGN_CENTER,
	    	:locY=>59
	    });
	    				
	    currentTime = new WatchUi.Text({
			    	:text=>timeString,
			    	:color=>Graphics.COLOR_WHITE,
			    	:font=>Graphics.FONT_NUMBER_HOT,
			    	:locX=>WatchUi.LAYOUT_HALIGN_CENTER,
			    	:locY=>WatchUi.LAYOUT_VALIGN_CENTER
		});
		
		if (recommendationFlag == false){
		
			if (HRmeasurement != null){
				if (HRmeasurement.toString().length() == 2){
					    					    	
					if ("devel".equals(PROGRAM_MODE)){
						currentHR = new WatchUi.Text({
							:color=>Graphics.COLOR_WHITE,
					    	:text=>HRmeasurement.toString() + "," + notification,
					    	:font=>Graphics.FONT_SMALL,
					    	:locX=>125,
					    	:locY=>150
					    	});
					} else if ("prod".equals(PROGRAM_MODE)){
						currentHR = new WatchUi.Text({
							:color=>Graphics.COLOR_WHITE,
					    	:text=>HRmeasurement.toString(),
							:font=>Graphics.FONT_NUMBER_HOT,
					    	:locX=>125,
					    	:locY=>150
					    	});
					}				    	
				}else{
						    	
					if ("devel".equals(PROGRAM_MODE)){
						currentHR = new WatchUi.Text({
							:color=>Graphics.COLOR_WHITE,
					    	:text=>HRmeasurement.toString() + "," + notification,
					    	:font=>Graphics.FONT_SMALL,
					    	:locX=>103,
					    	:locY=>150
					    	});
					} else if ("prod".equals(PROGRAM_MODE)){
						currentHR = new WatchUi.Text({
							:color=>Graphics.COLOR_WHITE,
					    	:text=>HRmeasurement.toString(),
							:font=>Graphics.FONT_NUMBER_HOT,
					    	:locX=>103,
					    	:locY=>150
					    	});
					}
				}
				currentHR.draw(dc);
			} else{
				currentHR = new WatchUi.Text({
							:text=>"--",
							:font=>Graphics.FONT_NUMBER_HOT,
							:color=>Graphics.COLOR_WHITE, 	
					    	:locX=>130,
					    	:locY=>150
				}); 
				currentHR.draw(dc);
			}
			
			if ((dataRecordingSession != null) && ("200".equals(notification))){
				connectionIcon.draw(dc);
			}
			
			currentDate.draw(dc);
			currentTime.draw(dc);
		}
		else {
			if (recommendationString.equals("vibrateCommand")){
				recString = new WatchUi.Text({
								:text=>"I'M HERE!",
								:font=>Graphics.FONT_LARGE,
								:color=>Graphics.COLOR_WHITE,
								:locX=>WatchUi.LAYOUT_HALIGN_CENTER,
				    			:locY=>180
					}); 
				recString.draw(dc);
			} else if (recommendationString.equals("LP")){
				dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
				dc.clear();
				recIcon.draw(dc);
			} else if (recommendationString.equals("MP")){
				dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_YELLOW);
				dc.clear();
				recIcon.draw(dc);
			} else if (recommendationString.equals("HP")){
				dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
				dc.clear();
				recIcon.draw(dc);
			}
		}
				
	}

    function initialize() {
        View.initialize();    
        
        connectionIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.connectivityIcon,
            :locX=>LAYOUT_HALIGN_CENTER,
            :locY=>-2
        });
        
        recIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.recIconPhone,
            :locX=>LAYOUT_HALIGN_CENTER,
            :locY=>LAYOUT_VALIGN_CENTER
        });
        
    }
   
    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {  	
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout

        if (recommendationFlag == false){
        	setLayout(Rez.Layouts.MainLayout(dc));
	        View.onUpdate(dc);	
	        updateDisplay(dc);

	    }
	    else {
	    	if (recommendationString.equals("vibrateCommand")){
	    		setLayout(Rez.Layouts.RecLayoutTest(dc));
	    		View.onUpdate(dc);	
	        	updateDisplay(dc);
	        } else {
	        	setLayout(Rez.Layouts.emptyLayout(dc));
	    		View.onUpdate(dc);	
	        	updateDisplay(dc);
	        }
	    }
    }
    

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {	
    	var timeInfo = System.getClockTime();
		System.println("Stop sensing: " +
			    timeInfo.hour.format("%02d") + ":" +
			    timeInfo.min.format("%02d") + ":" +
			    timeInfo.sec.format("%02d")
		);
		Sensor.enableSensorEvents(null);
		
		if (dataRecordingSession != null){
			var activityInfo = ActivityMonitor.getInfo();
		 		
			dataRecordingSession = null;
		
			WatchUi.requestUpdate();
		}	
    }

}
