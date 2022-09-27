// Author: Adria Mallol-Ragolta, Thomas Wiest, 2019-2020 

using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Timer;

var samplesInBuffer = 20; 
var dataRecordingSession = null;
var notification = null;
var previousNotification = "init";
var HRmeasurement = null;
var PROGRAM_MODE = "prod"; // "devel" or "prod"

// Declaration of URL where to store data
var url = "https://[ip]:[port]/api";

class sustAGEApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
 
    }

    // onStart() is called on application start up
    function onStart(state) {
    	var timerProgram = new Timer.Timer();
    	timerProgram.start(method(:requestDisplayUpdate),1000,true);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new sustAGEView(), new sustAGEDelegate() ];
    }

}
