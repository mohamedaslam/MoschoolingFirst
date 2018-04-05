//
//  ParentsUpdateVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 05/04/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ParentsUpdateVC: UIViewController {
    @IBOutlet weak var fatherFNTextfield: UITextField!
    
    @IBOutlet weak var motherAddressTextField: UITextField!
    @IBOutlet weak var motherMobileTextField: UITextField!
    @IBOutlet weak var motherEmailTextField: UITextField!
    @IBOutlet weak var motherOccupationTextField: UITextField!
    @IBOutlet weak var motherqulificationTextField: UITextField!
    @IBOutlet weak var motherLNTextField: UITextField!
    @IBOutlet weak var motherFNTextField: UITextField!
    @IBOutlet weak var fatherAddressTextField: UITextField!
    @IBOutlet weak var fatherMobileTextField: UITextField!
    @IBOutlet weak var fatherEmailTextField: UITextField!
    @IBOutlet weak var fatherOccupactionTextField: UITextField!
    @IBOutlet weak var fatherQualificationTextfield: UITextField!
    @IBOutlet weak var fatherLNTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://school.moschooling.com/api/GetParentDetailsByStudent", method: .get, parameters: ["studentID": 213], encoding: URLEncoding.default, headers: ["UserID":"102"]).responseJSON { (response:DataResponse<Any>) in
            // Alamofire.request("https://school.moschooling.com/API/GetParentChildren", method : .post, parameters:["UserID":92], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    print("VEHICLESTUDENTTGetdata")
                    var getMotherInfo = swiftyJsonVar["MotherInfo"]
                    let MotherFirstName = getMotherInfo["FirstName"].stringValue
                    self.motherFNTextField.text = MotherFirstName
                    let MotherEmail = getMotherInfo["Email"].stringValue
                    self.motherEmailTextField.text = MotherEmail

                    let MotherPhoneNo = getMotherInfo["PhoneNo"].stringValue
                    self.motherMobileTextField.text = MotherPhoneNo

                    let MotherLastName = getMotherInfo["LastName"].stringValue
                    self.motherLNTextField.text = MotherLastName

                    let MotherUserID = getMotherInfo["UserID"].stringValue
                    print(getMotherInfo)
                    print(MotherFirstName)
                    print(MotherEmail)
                    print(MotherPhoneNo)
                    print(MotherLastName)
                    print(MotherUserID)
                    print("FullName")
                    for getMotherAddress in getMotherInfo["Addresses"].arrayValue {
                        let Address = getMotherAddress["Address"].stringValue
                        self.motherAddressTextField.text = Address

                        let AddressID = getMotherAddress["AddressID"].stringValue

                        print(Address)
                        print(AddressID)

                    }
                    for getMotherAcademics in getMotherInfo["Academics"].arrayValue {
                        let Academic = getMotherAcademics["Academic"].stringValue
                        self.motherqulificationTextField.text = Academic

                        let AcadamicID = getMotherAcademics["AcadamicID"].stringValue
                        print(Academic)
                        print(AcadamicID)
                        
                    }
                    for getMotherWorks in getMotherInfo["Works"].arrayValue {
                        let Work = getMotherWorks["Work"].stringValue
                        self.motherOccupationTextField.text = Work

                        let WorkID = getMotherWorks["WorkID"].stringValue
                        print(Work)
                        print(WorkID)
                        
                    }

              
                    ////////////Father

      
                    var getFatherInfo = swiftyJsonVar["FatherInfo"]
                    let FatherFirstName = getFatherInfo["FirstName"].stringValue
                    self.fatherFNTextfield.text = FatherFirstName

                    let FatherEmail = getFatherInfo["Email"].stringValue
                    self.fatherEmailTextField.text = FatherEmail

                    let FatherPhoneNo = getFatherInfo["PhoneNo"].stringValue
                    self.fatherMobileTextField.text = FatherPhoneNo

                    let FatherLastName = getFatherInfo["LastName"].stringValue
                    self.fatherLNTextField.text = FatherLastName

                    let FatherUserID = getFatherInfo["UserID"].stringValue
                    print(getFatherInfo)
                    print(FatherFirstName)
                    print(FatherEmail)
                    print(FatherPhoneNo)
                    print(FatherLastName)
                    print(FatherUserID)
                    print("FATHERFullName")
                    for getFatherAddress in getFatherInfo["Addresses"].arrayValue {
                        let Address = getFatherAddress["Address"].stringValue
                        self.fatherAddressTextField.text = Address

                        let AddressID = getFatherAddress["AddressID"].stringValue
                        print(Address)
                        print(AddressID)
                        
                    }
                    for getFatherAcademics in getFatherInfo["Academics"].arrayValue {
                        let Academic = getFatherAcademics["Academic"].stringValue
                        self.fatherQualificationTextfield.text = Academic

                        let AcadamicID = getFatherAcademics["AcadamicID"].stringValue
                        print(Academic)
                        print(AcadamicID)
                        
                    }
                    for getFatherWorks in getFatherInfo["Works"].arrayValue {
                        let Work = getFatherWorks["Work"].stringValue
                        self.fatherOccupactionTextField.text = Work

                        let WorkID = getFatherWorks["WorkID"].stringValue
                        print(Work)
                        print(WorkID)
                        
                    }

                }
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateBtn(_ sender: Any) {
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
