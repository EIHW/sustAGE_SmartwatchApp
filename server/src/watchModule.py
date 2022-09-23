import os
import pdb
import json

import requests
import time

from numpy import arange

URL = 'http://0.0.0.0:5000'

def watchData():
    
    resp = requests.get(URL)
    
    if (resp.status_code!=200):
        print('GET request error {}'.format(resp.status_code))
        return None
    else:
        apiData = resp.json()['Data']
        if len(apiData)>=1:
            return apiData
        else:
            return None

def cleanData(inputData):
    return inputData[3:-3].replace(' ','').split(',')

def cleanArrayData(inputData):
    return inputData[4:-4].replace(' ','').split('],[')


while 1==1:
    time.sleep(1)
            
    apiData = watchData()
    if apiData != None :
        
        for item in apiData:

            timestampList = cleanData(item['Timestamp'])
            hrList = cleanData(item['Heart Rate'])
            hrvList = cleanArrayData(item['HRV'])
            accXlist = cleanArrayData(item['AccelX'])
            accYlist = cleanArrayData(item['AccelY'])
            accZlist = cleanArrayData(item['AccelZ'])
            stepsList = cleanData(item['Steps'])
            
            for idx in arange(len(timestampList)):

                print('Device ID: {}'.format(item['Device']))
                print('Timestamp: {}'.format(timestampList[idx]))
                print('HR data: {}'.format(hrList[idx]))
                print('HRV data: {}'.format(hrvList[idx]))
                print('Steps data: {}'.format(stepsList[idx]))
                print('Accelerometer data')
                print('-> x-axis: {}'.format(accXlist[idx]))
                print('-> y-axis: {}'.format(accYlist[idx]))
                print('-> z-axis: {}'.format(accZlist[idx]))
                print('<------------------->')
