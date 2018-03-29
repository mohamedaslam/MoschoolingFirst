//
//  DashboardVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 27/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit

class DashboardVC: BaseViewController {

    @IBOutlet weak var MessageViewAllBtn: UIButton!
    @IBOutlet weak var ReviewViewAllbtn: UIButton!
    @IBOutlet weak var AssignmentsViewAllbtn: UIButton!
    @IBOutlet weak var requestLeaveBtn: UIButton!
    @IBOutlet weak var updateProfilebtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      addSlideMenuButton()
        requestLeaveBtn.layer.masksToBounds = true;
        requestLeaveBtn.layer.cornerRadius = 8.0;
        requestLeaveBtn.layer.borderColor = UIColor.red.cgColor
        requestLeaveBtn.layer.borderWidth = 2;
        updateProfilebtn.layer.masksToBounds = true;
        updateProfilebtn.layer.cornerRadius = 8.0;
        updateProfilebtn.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        updateProfilebtn.layer.borderWidth = 2;
        ///////////
        MessageViewAllBtn.layer.masksToBounds = true;
        MessageViewAllBtn.layer.cornerRadius = 8.0;
        MessageViewAllBtn.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        MessageViewAllBtn.layer.borderWidth = 2;
        //////
        AssignmentsViewAllbtn.layer.masksToBounds = true;
        AssignmentsViewAllbtn.layer.cornerRadius = 8.0;
        AssignmentsViewAllbtn.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        AssignmentsViewAllbtn.layer.borderWidth = 2;
        ////////
        ReviewViewAllbtn.layer.masksToBounds = true;
        ReviewViewAllbtn.layer.cornerRadius = 8.0;
        ReviewViewAllbtn.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        ReviewViewAllbtn.layer.borderWidth = 2;
        // Do any additional setup after loading the view.
    }

    @IBAction func requestLeaveBtn(_ sender: Any) {
    }
    @IBAction func updateProfilebtn(_ sender: Any) {
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
