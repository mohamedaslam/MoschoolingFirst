//
//  AssignmentData.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 30/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import Foundation
struct AssignmentData {
  
    let Status: Double
    let createdDate: Double
    let description: String
    let imagepathOne: String
    let subjectID: Double
    let taskDate: Double
    let taskTittle: String
    let taskType: String
    let teacherName: String
    let userID: Double
    let ref: DatabaseReference?
    
    init(Status: Double,createdDate: Double,description: String,imagepathOne: String,subjectID: Double,taskDate: Double,taskTittle: String,taskType: String,teacherName: String,userID: Double)
    {
        self.Status = Status
        self.createdDate = createdDate
        self.description = description
        self.imagepathOne = imagepathOne
        self.subjectID = subjectID
        self.taskDate = taskDate
        self.taskTittle = taskTittle
        self.taskType = taskType
        self.teacherName = teacherName
        self.userID = userID
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        Status = snapshotValue["Status"] as! Double
        createdDate = snapshotValue["createdDate"] as! Double
        description = snapshotValue["description"] as! String
        imagepathOne = snapshotValue["imagepathOne"] as! String
        subjectID = snapshotValue["subjectID"] as! Double
        taskDate = snapshotValue["taskDate"] as! Double
        taskTittle = snapshotValue["taskTittle"] as! String
        taskType = snapshotValue["taskType"] as! String
        teacherName = snapshotValue["teacherName"] as! String
        userID = snapshotValue["userID"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "Status": Status,
            "createdDate": createdDate,
            "description": description,
            "imagepathOne": imagepathOne,
            "subjectID": subjectID,
            "taskDate": taskDate,
            "taskTittle": taskTittle,
            "taskType": taskType,
            "teacherName": teacherName,
            "userID": userID
        ]
    }
    
}
