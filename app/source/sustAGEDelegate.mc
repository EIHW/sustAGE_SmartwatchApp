// Author: Adria Mallol-Ragolta, Thomas Wiest, 2019-2020

using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;
using Toybox.Time.Gregorian;
using Toybox.Sensor;
using Toybox.ActivityMonitor;
using Toybox.ActivityRecording;
using Toybox.Communications;
using Toybox.Attention;

// Declaration of variables
var timerSessions = null;
var timerSessions_early = null;
var timerMeasurements = null;
var canSend = true;
var retransmission = false;

var samplingRate = Sensor.getMaxSampleRate();
var xAcc = [];
var yAcc = [];
var zAcc = [];
var HR_B2B = [];
var xAcc_tmp = [];
var yAcc_tmp = [];
var zAcc_tmp = [];
var HR_B2B_tmp = [];

var timestamp_list = [];
var heartRate_list = []b;
var HRV_list = [];
var steps_list = [];
var xAcc_list = [];
var yAcc_list = [];
var zAcc_list = [];

var timestamp_list_2transmit = [];
var heartRate_list_2transmit = []b;
var HRV_list_2transmit = [];
var steps_list_2transmit = [];
var xAcc_list_2transmit = [];
var yAcc_list_2transmit = [];
var zAcc_list_2transmit = [];



// Variable to handle the reception of recommendations
var recommendationFlag = false; 
var recommendationString = null;

var NTPoffset = 0;

// Declaration of variables to store data on server
var url_options = {
	:method => Communications.HTTP_REQUEST_METHOD_POST,
	:headers => {
		"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
	},		
	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON 
};

// Get device information
var mySettings = System.getDeviceSettings();
var deviceID = mySettings.uniqueIdentifier;

class sustAGEDelegate extends WatchUi.BehaviorDelegate {

	var recScreenTimer = new Timer.Timer();

    function initialize() {
        BehaviorDelegate.initialize();
        startSensing();
		
        Communications.registerForPhoneAppMessages(method(:phoneMessageCallback));
    }

    function onMenu() {

    }
    
    
    function onReceive(responseCode, data) {
		notification = responseCode.toString();
		
		System.println("=========== SERVER RESPONSE =============");
		System.println("Response code: " + notification);
		System.println("=========================================");
		
		if ("200".equals(notification)) {
			System.println("Request Successful");    
			
			timestamp_list_2transmit = [];
			heartRate_list_2transmit = [];
			HRV_list_2transmit = [];
			steps_list_2transmit = [];
			xAcc_list_2transmit = [];
			yAcc_list_2transmit = [];
			zAcc_list_2transmit = [];
			
			retransmission = false;
		
		} else if ("-2".equals(notification)){
			if (notification.equals(previousNotification)){
			
			} else{
				Attention.vibrate([
					new Attention.VibeProfile(85, 1000), 
				]);
			}
			
			retransmission = true;
					
		}else{
			if ("devel".equals(PROGRAM_MODE)){
				if (notification.equals(previousNotification)){
				
				} else{
					Attention.vibrate([
						new Attention.VibeProfile(85, 1000), 
					]);
				}
			}
			
			retransmission = true;
		}
		
		canSend = true;
		previousNotification = notification;
			
	}
	
	function appMainScreen() {
		recommendationFlag = false;
		WatchUi.requestUpdate();                 
	}
    
    function phoneMessageCallback(msg){
		var message = new Communications.PhoneAppMessage();
		message = msg.data;
		System.println(msg);
		System.println(message);
				
		if ("vibrateCommand".equals(message)) {
		
			recommendationFlag = true;
			recommendationString = message;
	    	WatchUi.requestUpdate();
	    	
	    	recScreenTimer.start(method(:appMainScreen), 2000, false);
			
			Attention.vibrate([
		    	new Attention.VibeProfile(85, 1000), 
		        new Attention.VibeProfile(0, 250),  
		        new Attention.VibeProfile(85, 250), 
		        new Attention.VibeProfile(0, 250),  
		        new Attention.VibeProfile(85, 250)  
		    ]);
		    
		} else if ("LP".equals(message)){
		
			recommendationFlag = true;
			recommendationString = message;
	    	WatchUi.requestUpdate();
	    	
	    	recScreenTimer.start(method(:appMainScreen), 4000, false);
			
			Attention.vibrate([
		    	new Attention.VibeProfile(90, 1000), 
		    ]);
		
		} else if ("MP".equals(message)){
		
			recommendationFlag = true;
			recommendationString = message;
	    	WatchUi.requestUpdate();
	    	
	    	recScreenTimer.start(method(:appMainScreen), 4000, false);
			
			Attention.vibrate([
		    	new Attention.VibeProfile(90, 450), 
		        new Attention.VibeProfile(0, 100),  
		        new Attention.VibeProfile(90, 450), 
		    ]);
		    
		} else if ("HP".equals(message)){
			
			recommendationFlag = true;
			recommendationString = message;
	    	WatchUi.requestUpdate();
	    	
	    	recScreenTimer.start(method(:appMainScreen), 4000, false);
			
			Attention.vibrate([
		    	new Attention.VibeProfile(100, 500), 
		        new Attention.VibeProfile(0, 200),  
		        new Attention.VibeProfile(100, 200), 
		        new Attention.VibeProfile(0, 200),  
		        new Attention.VibeProfile(100, 200), 
		        new Attention.VibeProfile(0, 200),  
		        new Attention.VibeProfile(100, 500), 		        
		    ]);
				
		} else {
			
			NTPoffset = message.toLong();	
			
			if ("devel".equals(PROGRAM_MODE)){
			
				Attention.vibrate([
					new Attention.VibeProfile(50, 1000), 
				]);
			
				notification = message;
				WatchUi.requestUpdate();
			}	
		}
			
    }
    
    function sensorDataCallback(sensorData){
    	
    	var now_UNIX_sensor = new Time.Moment(Time.now().value());
    	now_UNIX_sensor = now_UNIX_sensor.value().toLong()*1000;
    	System.println("Sensor data timestamp: " + now_UNIX_sensor);
    	
    	xAcc_tmp = []; yAcc_tmp = []; zAcc_tmp = [];
    	if (sensorData has :accelerometerData && sensorData.accelerometerData != null) {

	    	xAcc_tmp = sensorData.accelerometerData.x;
			yAcc_tmp = sensorData.accelerometerData.y;
			zAcc_tmp = sensorData.accelerometerData.z;
			
		}
		
		HR_B2B_tmp = [];
		if (sensorData has :heartRateData && sensorData.heartRateData != null) {
			HR_B2B_tmp = sensorData.heartRateData.heartBeatIntervals; // The most recent beat-to-beat interval in milliseconds (ms).
		} 
		
		xAcc.addAll(xAcc_tmp);
		yAcc.addAll(yAcc_tmp);
		zAcc.addAll(zAcc_tmp);
		HR_B2B.addAll(HR_B2B_tmp);

    }
    
    function sensorOn(sensorInfo){
    
    	var now_UNIX = new Time.Moment(Time.now().value());
    	now_UNIX = now_UNIX.value().toLong()*1000;
		
		if (sensorInfo has :heartRate && sensorInfo.heartRate != null){
		
			HRmeasurement = sensorInfo.heartRate;
			var ActivityMonitorInfo = ActivityMonitor.getInfo();
			var STEPSmeasurement = ActivityMonitorInfo.steps;
			
			System.println("========= DATA READING =============");
			System.println("Timestamp: " + now_UNIX + " milliseconds");
			System.println("Acceleration: x-axis " + xAcc);
			System.println("Acceleration: y-axis " + yAcc);
			System.println("Acceleration: z-axis " + zAcc);
			System.println("Heart Rate: " + HRmeasurement);
			System.println("Heart Rate Variability: " + HR_B2B);
			System.println("Steps since midnight: " + STEPSmeasurement);
			
			timestamp_list.add(now_UNIX + NTPoffset);
			
			heartRate_list.add(HRmeasurement);
			
			HRV_list.add(HR_B2B);
			HR_B2B = [];
			
			xAcc_list.add(xAcc);  
			yAcc_list.add(yAcc);  
			zAcc_list.add(zAcc); 
			xAcc = []; yAcc = []; zAcc = [];
			
			steps_list.add(STEPSmeasurement);
			
			var percentageFreeMemory =  System.getSystemStats().freeMemory.toFloat() / System.getSystemStats().totalMemory;
			
			System.println("========= SYSTEM STATS =============");
			System.println("Total memory: " + System.getSystemStats().totalMemory);
			System.println("Used memory: " + System.getSystemStats().usedMemory );
			System.println("Free memory: " + System.getSystemStats().freeMemory);
			System.println(percentageFreeMemory);
			System.println("=========================================");
			
			if (percentageFreeMemory < .525){
				var riddingOfNsamples = 1;

				timestamp_list = timestamp_list.slice(riddingOfNsamples, null);

				heartRate_list = heartRate_list.slice(riddingOfNsamples, null);
				
				HRV_list = HRV_list.slice(riddingOfNsamples, null);
				
				steps_list = steps_list.slice(riddingOfNsamples, null);
				
				xAcc_list = xAcc_list.slice(riddingOfNsamples, null);
				yAcc_list = yAcc_list.slice(riddingOfNsamples, null);
				zAcc_list = zAcc_list.slice(riddingOfNsamples, null);
			} 
			
			if (canSend == true){
								
				// Control the maximum number of samples sent at once
				if (retransmission != true){
				
					if ((timestamp_list_2transmit.size() + timestamp_list.size()) < samplesInBuffer){
						timestamp_list_2transmit.addAll(timestamp_list); timestamp_list = [];
						
						heartRate_list_2transmit.addAll(heartRate_list); heartRate_list = [];
						
						HRV_list_2transmit.addAll(HRV_list); HRV_list = [];
						
						xAcc_list_2transmit.addAll(xAcc_list); xAcc_list = [];
						yAcc_list_2transmit.addAll(yAcc_list); yAcc_list = [];
						zAcc_list_2transmit.addAll(zAcc_list); zAcc_list = [];
						
						steps_list_2transmit.addAll(steps_list); steps_list = [];
						
					} else{
					
						var freeSamplesInBuffer = samplesInBuffer - timestamp_list_2transmit.size();
						if (freeSamplesInBuffer > 0){

							timestamp_list_2transmit.addAll(timestamp_list.slice(0, freeSamplesInBuffer));
							timestamp_list = timestamp_list.slice(freeSamplesInBuffer, null);
							
							heartRate_list_2transmit.addAll(heartRate_list.slice(0, freeSamplesInBuffer));
							heartRate_list = heartRate_list.slice(freeSamplesInBuffer, null);
							
							HRV_list_2transmit.addAll(HRV_list.slice(0, freeSamplesInBuffer));
							HRV_list = HRV_list.slice(freeSamplesInBuffer, null);
							
							xAcc_list_2transmit.addAll(xAcc_list.slice(0, freeSamplesInBuffer)); 
							xAcc_list = xAcc_list.slice(freeSamplesInBuffer, null);
							yAcc_list_2transmit.addAll(yAcc_list.slice(0, freeSamplesInBuffer)); 
							yAcc_list = yAcc_list.slice(freeSamplesInBuffer, null);
							zAcc_list_2transmit.addAll(zAcc_list.slice(0, freeSamplesInBuffer)); 
							zAcc_list = zAcc_list.slice(freeSamplesInBuffer, null);
							
							steps_list_2transmit.addAll(steps_list.slice(0, freeSamplesInBuffer)); 
							steps_list = steps_list.slice(freeSamplesInBuffer, null);
							
						}
						
					}
				}
				
				System.println("========= DATA IN MEMORY =============");
				System.println("Timestamps: " + timestamp_list);
				System.println("Heart Rate List: " + heartRate_list);
				System.println("Heart Rate Variability List: " + HRV_list);
				System.println("xAcc List: " + xAcc_list);
				System.println("=========================================");
				
				System.println("========= DATA TO TRANSMIT =============");
				System.println("Timestamps: " + timestamp_list_2transmit);
				System.println("Heart Rate List: " + heartRate_list_2transmit);
				System.println("Heart Rate Variability List: " + HRV_list_2transmit);
				System.println("xAcc List: " + xAcc_list_2transmit);
				System.println("=========================================");
				
				canSend = false;
				
				var params = {
					"D"=>deviceID,
					"T"=>timestamp_list_2transmit.toString(),
					"H"=>heartRate_list_2transmit.toString(),
					"V"=>HRV_list_2transmit.toString(),
					"S"=>steps_list_2transmit.toString(),
					"X"=>xAcc_list_2transmit.toString(),
					"Y"=>yAcc_list_2transmit.toString(),
					"Z"=>zAcc_list_2transmit.toString(),
				};
				
				Communications.makeWebRequest(url, params, url_options, method(:onReceive));
				
			}				
		} else {
			System.println("No sensor data");
		}

	}
    
    function startSensing(){
        	
    	var today_UNIX = new Time.Moment(Time.now().value());
    	var today_UNIX_value = today_UNIX.value();
		
		if (dataRecordingSession == null){
			dataRecordingSession = ActivityRecording.createSession({
				:name=>today_UNIX_value.format("%010d")
			});
					 	
			WatchUi.requestUpdate();
		}	
		
		var options = {
			:period => 1,               
		    :accelerometer => {
		        :enabled => true,       
		        :sampleRate => samplingRate       
		    },
		    :heartBeatIntervals => {
        		:enabled => true
        	}
		};
		Sensor.registerSensorDataListener(method(:sensorDataCallback), options);
    	
    	Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
		Sensor.enableSensorEvents(method(:sensorOn));
				
	}

}