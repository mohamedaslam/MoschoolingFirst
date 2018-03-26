//
//  LoginVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 05/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginVC: UIViewController {
  
    var schoolNamestr = ""
    var SchoolIDstr : Int = 0
    var schoolAddressstr = ""
    var phonestr = ""
    var schoolLogostr = ""
    var emailstr = ""
    @IBOutlet weak var SchoolLogoImageview: UIImageView!
    @IBOutlet weak var SchoolNameLabel: UILabel!
    @IBOutlet weak var SchoolAddress: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitbtn(_ sender: Any)
    {
        //["tokenAccesscode": accesscodetextfield.text ?? " "]
        //["username":"test14@gmail.com","password":"test123","schoolID": 1066]
        //["username":usernameTextField.text ?? " ","password":passwordTextField.text ?? " ","schoolID": SchoolIDstr]
        Alamofire.request("https://school.moschooling.com/API/login", method:.post, parameters: ["username":"test14@gmail.com","password":"test123","schoolID": 1066], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    print(swiftyJsonVar["status"])
                    print("Getdata")
                    
                    
                    if(swiftyJsonVar["status"] == true)
                    {
                        var resData = swiftyJsonVar["User"]
                        let schoolName = resData["email"]
                        print(schoolName)
                        print(resData["IsPasswordResetted"])
                        print(resData["userID"])
                        print(resData["phone"])
                        print(resData["userName"])
                        print(resData["lastName"])
                        print(resData["firstName"])

                        print("ALLLGetdata")
                        
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
                       // next.userIDstr = resData["userID"].int!
                      
                        self.present(next, animated: true, completion: nil)
                    }else
                    {
                        let alert = UIAlertController(title: "Alert", message: "Worng AccessCode", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                                
                            }}))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                }
                
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     {
     "status" : true,
     "statusMessage" : "Successfull login",
     "User" : {
     "email" : "test14@gmail.com",
     "IsPasswordResetted" : true,
     "userID" : 92,
     "phone" : "8596456325",
     "userName" : "test14@gmail.com",
     "lastName" : "Nath",
     "firstName" : "Sunil"
     }
     }
     
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

