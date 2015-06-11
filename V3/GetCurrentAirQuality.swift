//
//  GetCurrentAirQuality.swift
//  V3
//
//  Created by Mohak Nahta  on 6/11/15.
//  Copyright (c) 2015 Speck Sensor. All rights reserved.
//

import Foundation
import UIKit

struct CurrentAirQuality {
    
    var stationData: AnyObject
    var rowArray: Array<NSDictionary>
    var pmStations: Array<Int> = [Int]()
    var distanceAndIdArray: Array<(Double,Int)> = [(Double, Int)]()
    var closestStationID: Int  = 0
    
    init(airQualityDictionary: NSDictionary, currentLatitude: Double, currentLongitude: Double){
        stationData = airQualityDictionary["data"]! as AnyObject
        //        println("station data is \(stationData)")
        rowArray = stationData["rows"] as! Array<NSDictionary>
        pmStations = findStationsWithPM(rowArray)
        distanceAndIdArray = findDistanceAndIdArray(pmStations, dataArray: rowArray, latRef: currentLatitude, lonRef: currentLongitude)
        
        closestStationID = findClosestPMStation(distanceAndIdArray)
        
    }
    
    func findStationsWithPM(dataArray:Array<NSDictionary>) -> Array<Int> {
        var pmStationIndexArray = [Int]()
        var tempDict: NSDictionary
        var tempChannelBounds: NSDictionary
        var tempChannels: NSDictionary
        var lengthOfDataArray = dataArray.count
        
        if (lengthOfDataArray > 1 ){
            for i in 0...(dataArray.count - 1) {
                tempDict = dataArray[i]
                tempChannelBounds = tempDict["channelBounds"] as! NSDictionary
                tempChannels = tempChannelBounds["channels"] as! NSDictionary
                
                
                if let val:AnyObject = tempChannels["PM2_5"] {
                    pmStationIndexArray.append(i)
                }
                else if let val:AnyObject = tempChannels["PM25B_UG_M3"] {
                    pmStationIndexArray.append(i)
                }
                    
                else if let val:AnyObject = tempChannels["PM25_FL_PERCENT"] {
                    pmStationIndexArray.append(i)
                }
                    
                else if let val:AnyObject = tempChannels["PM25_UG_M3"] {
                    pmStationIndexArray.append(i)
                }
                
            }
        }
            
        else {
            pmStationIndexArray = []
        }
        
        return pmStationIndexArray
    }
    
    func findDistanceAndIdArray(pmStations: Array<Int>, dataArray: Array<NSDictionary>, latRef: Double, lonRef: Double) -> Array<(Double,Int)>{
        var distanceAndIds: Array<(Double,Int)> = [(Double, Int)]()
        var r: Double = 6378.137
        var tempData: NSDictionary
        var lat: Double
        var lon: Double
        var currDistance: Double
        var currId: Int
        var pmStationLength = pmStations.count
        
        if (pmStationLength > 1){
            
            for i in 0...(pmStations.count - 1){
                tempData = rowArray[pmStations[i]] as NSDictionary
                lat = tempData["latitude"] as! Double
                lon = tempData["longitude"] as! Double
                currDistance = haversine(latRef, lat2: lat, lon1: lonRef, lon2: lon)
                currId = tempData["id"] as! Int
                distanceAndIds += [(currDistance, currId)]
            }
            
        }
            
        else{
            distanceAndIds = []
        }
        
        //       println("distance and ids \(distanceAndIds)")
        return distanceAndIds
        
    }
    
    //from Rosetta Code wiki
    //test by comparing values from http://andrew.hedges.name/experiments/haversine/
    func haversine(lat1:Double, lat2:Double, lon1:Double, lon2:Double) -> Double { //finds the distance in kilometers
        //        println("lat 1 is \(lat1), lat2 is \(lat2), lon1 is \(lon1) and lon2 is \(lon2)")
        let lat1rad = lat1 * M_PI/180
        let lon1rad = lon1 * M_PI/180
        let lat2rad = lat2 * M_PI/180
        let lon2rad = lon2 * M_PI/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 6372.8
        
        return R * c
    }
    
    
    func findClosestPMStation(finalArray:Array<(Double,Int)>) -> Int {
        
        var minimum: Double = 10000000.0 //change this
        var minimumStationID: Int = 0
        var lengthOfFinalArray = distanceAndIdArray.count
        
        if (lengthOfFinalArray > 1){
            for i in 0...(distanceAndIdArray.count - 1){
                var (tempD, tempID) = distanceAndIdArray[i]
                if (tempD < minimum){
                    minimum = tempD
                    minimumStationID = tempID
                }
            }
            //            println("ID of the closest statio is \(minimumStationID)")
        }
            
        else{
            minimumStationID = 0
        }
        return minimumStationID
    }
    
    
}
