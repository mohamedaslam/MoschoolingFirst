//
//  StudentUpdateProfileVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 03/04/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class StudentUpdateProfileVC: UIViewController {
    @IBOutlet weak var stdprofileImgView: UIImageView!
    
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var bloodGroupTextField: UITextField!
    @IBOutlet weak var genderFemaleBtn: UIButton!
    @IBOutlet weak var genderMaleBtn: UIButton!

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    
    @IBOutlet weak var parentProfilebtn: UIButton!
    @IBOutlet weak var stdClassInfoLabel: UILabel!
    @IBOutlet weak var stdClassIDInfoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        genderFemaleBtn.isHidden = true

        parentProfilebtn.layer.masksToBounds = true;
        parentProfilebtn.layer.cornerRadius = 8.0;
        parentProfilebtn.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        parentProfilebtn.layer.borderWidth = 1;
        ///////////?GetVehicle student info
        
        Alamofire.request("https://school.moschooling.com/api/GetStudentDetails", method: .get, parameters: ["studentID": 213], encoding: URLEncoding.default, headers: ["UserID":"102"]).responseJSON { (response:DataResponse<Any>) in
            // Alamofire.request("https://school.moschooling.com/API/GetParentChildren", method : .post, parameters:["UserID":92], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    print("VEHICLESTUDENTTGetdata")
                    let ImagePath = swiftyJsonVar["ImagePath"]
                    let DOB = swiftyJsonVar["DOB"]
                    let Caste = swiftyJsonVar["Caste"]
                    let Address = swiftyJsonVar["Address"]
                    let BloodGroup = swiftyJsonVar["BloodGroup"]
                    let Gender = swiftyJsonVar["Gender"]
                    let Religion = swiftyJsonVar["Religion"]
                    let Reservation = swiftyJsonVar["Reservation"]
                    let StudentID = swiftyJsonVar["StudentID"]
                    let FullName = swiftyJsonVar["FullName"]
                    let FirstName = swiftyJsonVar["FirstName"]
                    let LastName = swiftyJsonVar["LastName"]
                    print(ImagePath)
                    print(DOB)
                    print(Caste)
                    print(Address)
                    print(BloodGroup)
                    print(Gender)
                    print(Religion)
                    print(Reservation)
                    print(StudentID)
                    print(FullName)
                    print(FirstName)
                    print(LastName)
                    print("FullName")


                   
                    
                    /*
                     {
                     "status" : true,
                     "driver" :
                     {
                     "lastName" : "Rajan",
                     "phone" : "99564251",
                     "firstName" : "Rajith",
                     "email" : "hellorajith@gmail.com",
                     "profileImage" : "https:\/\/s3.amazonaws.com\/mos-resources\/Employee\/ProfileImage\/636421107418500192Al_Gore,_Vice_President_of_the_United_States,_official_portrait_1994.jpg",
                     "userID" : 61
                     },
                     "vehicle" :
                     {
                     "routeName" : "WHT_MATHLI",
                     "vehicleID" : 5,
                     "vehicleNumber" : "KA 45K 8654",
                     "totalStudent" : 18,
                     "routeDestination" : "Marathahalli"
                     },
                     "driverSupport" :
                     {
                     "lastName" : "Babu",
                     "phone" : "8547960818",
                     "firstName" : "Vishal",
                     "email" : "vinodbramesan@gmail.com",
                     "profileImage" : "https:\/\/s3.amazonaws.com\/mos-resources\/Employee\/ProfileImage\/636421108051945156images.jpg",
                     "userID" : 60
                     },
                     "statusMessage" : "Successfully loaded"
                     }
                     VEHICLESTUDENTTGetdata
                     
                     
                     */
                }
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
 
        print("DRIVERVEHICLE")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateBtn(_ sender: Any)
    {
        
    }
    @IBAction func malebtn(_ sender: Any)
    {
        genderMaleBtn.isHidden = false
        genderFemaleBtn.isHidden = true
    }
    @IBAction func changeProfilePicbtn(_ sender: Any) {
    }
    
    @IBAction func femaleBtn(_ sender: Any)
    {
        genderMaleBtn.isHidden = true
        genderFemaleBtn.isHidden = false
    }
    @IBAction func parentProfilebtn(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
