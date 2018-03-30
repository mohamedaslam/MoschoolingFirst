//
//  AccessCodeVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 05/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccessCodeVC: UIViewController  {
    @IBOutlet weak var accesscodetextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    @IBAction func submitbnt(_ sender: Any)
    {
        //E-1066-TGMJ"E-1066-TGMJ
        // ["tokenAccesscode": accesscodetextfield.text ?? " "]
        Alamofire.request("https://school.moschooling.com/API/verifyaccesscode?", method: .get, parameters: ["tokenAccesscode": "E-1066-TGMJ"], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    print(swiftyJsonVar["status"])
                    print("Getdata")
                   
                  
                    if(swiftyJsonVar["status"] == true)
                    {
                    var resData = swiftyJsonVar["school"]
                        let schoolName = resData["schoolName"]
                        print(schoolName)
                        print(resData["SchoolID"])
                        print(resData["schoolAddress"])
                        print(resData["phone"])
                        print(resData["schoolLogo"])
                        print(resData["email"])
                        print("ALLLGetdata")

                    let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        next.schoolNamestr = resData["schoolName"].string!
                          next.schoolAddressstr = resData["schoolAddress"].string!
                         next.SchoolIDstr = resData["SchoolID"].int!
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
            print(self.arrRes)
            print("self.arrRes")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//rgb(87, 167, 87)  Primary
//UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0)
