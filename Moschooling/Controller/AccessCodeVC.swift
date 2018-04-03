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
    func getDiffernce(toTime:Date) -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let startstrDate = "2018-03-29T05:40:00+05:30"//Tue Apr 03 2018 00:19:56
        let startdateFormatter = DateFormatter()
        startdateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        startdateFormatter.timeZone = (NSTimeZone(name: "UTC") as NSTimeZone!) as TimeZone!
        let startdate = startdateFormatter.date(from: startstrDate)
        print(startdate!)
        let startmillieseconds = self.getDiffernce(toTime: startdate!)
        print(startmillieseconds)
        print("startmillieseconds")
        let endstrDate = "2018-03-29T23:59:00+05:30"
        let enddateFormatter = DateFormatter()
        enddateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let enddate = enddateFormatter.date(from: endstrDate)
        enddateFormatter.timeZone = (NSTimeZone(name: "UTC") as NSTimeZone!) as TimeZone!
        
        print(enddate!)
        let endmillieseconds = self.getDiffernce(toTime: enddate!)
        print(endmillieseconds)
        print("endmillieseconds")
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
