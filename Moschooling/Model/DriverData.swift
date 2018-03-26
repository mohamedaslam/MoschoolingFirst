//
//  DriverData.swift
//  MoschoollingApp
//
//  Created by Mohammed Aslam on 18/01/18.
//  Copyright © 2018 Moschoolling. All rights reserved.
//

import Foundation
struct DriverData {
//    public double busLatitude;
//    public double busLongitude;
//    public String busAddress;
//    public Long locationTimestamp;
//    public String driverId;
//    public String provider;
//    public Driver currentDriver;
//    public User user;
    let currentlatitude: Double
    let currentlongitude: Double
    let currentAddress: String
    let locationTimestamp: Double
//    let driverId: String
    let locationProvider: String
    let ref: DatabaseReference?
//    var completed: Bool
    let key: String

    init(currentlatitude: Double,currentlongitude: Double,currentAddress: String,locationTimestamp: Double,driverId: String,locationProvider: String,key:String = "")
  {
        self.key = key
        self.currentlatitude = currentlatitude
        self.currentlongitude = currentlongitude
        self.currentAddress = currentAddress
        self.locationTimestamp = locationTimestamp
       // self.driverId = driverId
        self.locationProvider = locationProvider
      //  self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        currentlatitude = snapshotValue["currentlatitude"] as! Double
        currentlongitude = snapshotValue["currentlongitude"] as! Double
        currentAddress = snapshotValue["currentAddress"] as! String
        locationTimestamp = snapshotValue["locationTimestamp"] as! Double
       // driverId = snapshotValue["driverId"] as! String
        locationProvider = snapshotValue["locationProvider"] as! String
       // completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "currentlatitude": currentlatitude,
            "currentlongitude": currentlongitude,
            "currentAddress": currentAddress,
            "locationTimestamp": locationTimestamp,
        // "driverId": driverId,
            "locationProvider": locationProvider,
        // "completed": completed
        ]
    }
    
}
