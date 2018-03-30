//
//  StudentListVC.swift
//  Moschooling
//
//  Created by Aslam on 3/6/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class StudentListVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        Alamofire.request("https://school.moschooling.com/API/GetParentChildren", method: .post, parameters: nil, encoding: JSONEncoding.default, headers:["UserID":"107"]).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["Students"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
               
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
            }
        }
        print(self.arrRes)
        print("arrASDADADRes")

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")!
        var dict = arrRes[(indexPath as NSIndexPath).row]
        print(dict)
        print(arrRes);
        print("asdfasdfasfsaf")
        cell.textLabel?.text = dict["StudentName"] as? String
        cell.detailTextLabel?.text = dict["ClassDivision"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(arrRes[indexPath.row])")
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = myStoryBoard.instantiateViewController(withIdentifier: "Tab") as? UITabBarController
        tabBarController?.selectedIndex = 0
        if let aController = tabBarController {
            self.present(aController, animated: true, completion: nil)
            //            navigationController?.pushViewController(aController, animated: true)
        }
    }
    
    @IBAction func btn(_ sender: Any)
    {
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = myStoryBoard.instantiateViewController(withIdentifier: "Tab") as? UITabBarController
        tabBarController?.selectedIndex = 0
        if let aController = tabBarController {
            self.present(aController, animated: true, completion: nil)
//            navigationController?.pushViewController(aController, animated: true)
        }
    }
    
}

