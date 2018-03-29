//
//  AttendanceVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 05/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CVCalendar
import UICircularProgressRing

class AttendanceVC:  BaseViewController,UICircularProgressRingDelegate {
    var categories = [ImageCategory]() //to hold the data to be displayed
    let headerReuseId = "TableHeaderViewReuseId"
    @IBOutlet weak var ring2: UICircularProgressRingView!

    fileprivate var randomNumberOfDotMarkersForDay = [Int]()
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var arryday = [String]()
    var arrystatus = [String]()
/////////??Weekday data
      var sundayarraydata = [String]()
      var mondayarraydata = [String]()
      var tuesdayarraydata = [String]()
      var wednesdayarraydata = [String]()
      var thursdayarraydata = [String]()
      var fridayarraydata = [String]()
      var saturdayarraydata = [String]()
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var firstweekday = String()
    var mondayweekday = String()
    var tuesdayweekday = String()
    var wednesdayweekday = String()
    var thursdayweekday = String()
    var fridayweekday = String()
    var sundayStatusInfo = String()
    var mondayStatusInfo = String()
    var tuesdayStatusInfo = String()
    var wednesdayStatusInfo = String()
    var thursdayStatusInfo = String()
    var fridayStatusInfo = String()
    var saturdayStatusInfo = String()
    var firstweekname = String()
    var tostr = String()
    var lastweekname = String()
//    STUDENT_PRESENT 1020
//    STUDNT_ABSENT_ON_APPROVE 1021
//    STUDENT_ABSENT_WITHOUT_APPROVE 1022
    ////////
    var stdPresentArrayData = [String]()
    var stdAbsentApproveArrayData = [String]()
    var stdAbsentWithOutApproveArrayData = [String]()
    ////
    @IBOutlet weak var weeksnameLabel: UILabel!
    var lastweekday = String()
    
    @IBOutlet weak var weekDateNameLabel: UILabel!
    @IBOutlet weak var Weekdatebtnext: UIButton!
    @IBOutlet weak var Weekdatebtnnext: UIButton!
    var selectedDay:DayView!
    
    var currentCalendar: Calendar?
    var getselecteddate = String()
    ////////////DAYS
    var days = [Int]()

    @IBOutlet weak var weekdatebtntext: UIButton!
    @IBOutlet weak var CalendarBGview: UIView!
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    @IBOutlet weak var AttendanceListTableView: UITableView!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    
    var WeekDaysArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday","Friday","Saturday"]
    var getimagesArray = ["Image_0","Image_1","Image_0","Image_1","Image_0","Image_1"]
    var gettitleArray = ["Image_0","Image_1"]
    var gettimeArray = ["2018-03-05T00:00:00","2018-03-05T00:00:00"]
    var getdayArray = ["Image_0","Image_0","Image_1"]
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
        if ring === ring2 {
            print("From delegate: Ring 1 finished")
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        self.ring2.ringStyle = UICircularProgressRingStyle(rawValue: 2)!

   
        Alamofire.request("https://school.moschooling.com/API/GetStudentWeekAttendance", method: .post, parameters: ["StudentID":198,"UserID":92,"StartDate": "2018-03-05T00:00:00+05:30","EndDate": "2018-03-09T00:00:00+05:30"], encoding: JSONEncoding.default, headers:["UserID":"92"]).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                print("VEHICLESTUDENTTGetdata")
             
            }
        }
        print("arrASDADADRes")
        let tap = UITapGestureRecognizer(target: self, action: #selector(AttendanceVC.tapFunction))
        weekDateNameLabel.isUserInteractionEnabled = true
        weekDateNameLabel.addGestureRecognizer(tap)
    
        weekDateNameLabel.layer.masksToBounds = true;
        weekDateNameLabel.layer.cornerRadius = 20.0;
        weekDateNameLabel.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        weekDateNameLabel.layer.borderWidth = 2;
        // Do any additional setup after loading the view.
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        CalendarBGview.isHidden = false
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.calendarView.commitCalendarViewUpdate()
        self.calendarMenuView.commitMenuViewUpdate()
        CalendarBGview.isHidden = true

        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBOutlet weak var monthLabel: UILabel!
    //MARK: Data initlisers methods
    func setupData() {
        categories.removeAll()
        for index in 0..<7 {
            var infoDict = [String:Any]()
            infoDict = dataForIndex(index: index)
            
            print(infoDict)
            print("infoDict")
            let aCategory = ImageCategory(withInfo: infoDict)
            
            print(aCategory)
            print("aCategory")
            categories.append(aCategory)
            
            print(categories)
            print("categories")
        }
        self.AttendanceListTableView.reloadData()

    }
    
    func dataForIndex(index:Int) -> [String:Any] {
        var data = [String:Any]()
        print(self.mondayarraydata)
        print(self.tuesdayarraydata)
        print(self.wednesdayarraydata)
        print(self.thursdayarraydata)
        print(self.fridayarraydata)
        print(self.saturdayarraydata)
        
        print(index)
        print(self.stdPresentArrayData.count)
        print(self.stdAbsentApproveArrayData.count)
        print(self.stdAbsentWithOutApproveArrayData.count)
        ring2.delegate = self
        ring2.fontColor = UIColor.gray

        ring2.innerRingColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0)
        ring2.outerRingColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0)
        var a : Double = Double(self.stdPresentArrayData.count)
        var b : Double = Double(self.stdAbsentApproveArrayData.count) + Double(self.stdPresentArrayData.count)
        var c = ceil((a/b)*100)
        print(CGFloat(a))
        print(CGFloat(b))
        print(CGFloat(c))
        print("CGFloat(c)")
        if(self.stdPresentArrayData.count + self.stdAbsentApproveArrayData.count) > 0
        {
              c = ceil((a/b)*100)
        }else{
            c = 0
        }
        ring2.setProgress(value:CGFloat(c), animationDuration: 2) { [unowned self] in
            // Increase it more, and customize some properties

            //            self.ring2.setProgress(value: 100, animationDuration: 3) {
            //                self.ring2.font = UIFont.systemFont(ofSize: 50)
            //                print("Ring 2 finished")
            //            }
        }
        self.weekDateNameLabel.layer.masksToBounds = true;
        self.weekDateNameLabel.layer.cornerRadius = 20.0;
        self.weekDateNameLabel.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        self.weekDateNameLabel.text = firstweekname + tostr + lastweekname
        print("stdAbsentWithOutApproveArrayData")
        print("self.sundayarraydata")
        switch index {
        case 0:
            data["cat_name"] = sundayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "birds pics shot in the Forest"
            data["cat_items"] = sundayarraydata
        case 1:
            data["cat_name"] = mondayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "Animals pics shot in the Forest"
            data["cat_items"] = mondayarraydata
        case 2:
            data["cat_name"] = tuesdayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "Fishes pics shot in the Lake"
            data["cat_items"] = tuesdayarraydata
        case 3:
            data["cat_name"] = wednesdayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "Plants pics shot in the Forest"
            data["cat_items"] = wednesdayarraydata
        case 4:
            data["cat_name"] = thursdayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "Trees pics shot in the Forest"
            data["cat_items"] = thursdayarraydata
        case 5:
            data["cat_name"] = fridayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "Trees pics shot in the Forest"
            data["cat_items"] = fridayarraydata
        case 6:
            data["cat_name"] = saturdayStatusInfo
            data["cat_id"]   = "\(index)"
            data["cat_description"] = "Trees pics shot in the Forest"
            data["cat_items"] = saturdayarraydata
        default: break
//            data["cat_name"] = "RandomPics"
//            data["cat_id"]   = "\(index)"
//            data["cat_description"] = "Random pics"
//            data["cat_items"] = ["Image_2","Image_7"]
        }
        return data
      
    }
    
    func apicall() {
        var Onlydatefirstweekday = String(firstweekday.prefix(10)) // result is "1234"
        print(Onlydatefirstweekday)
      
        var Onlydatelastweekday = String(lastweekday.prefix(10)) // result is "1234"
        print(Onlydatelastweekday)
        let dateAsString = String(firstweekday.prefix(10))
        let firstdateFormatter = DateFormatter()
      
        firstdateFormatter.dateFormat = "yyyy-MM-dd"
        if let firstdate = firstdateFormatter.date(from: String(firstweekday.prefix(10))) {
            firstdateFormatter.dateFormat = "dd-MMM"
            print("firstdate is \(firstdateFormatter.string(from: firstdate))")
            firstweekname = firstdateFormatter.string(from: firstdate)
            tostr = " to "
        }
        let lastdateFormatter = DateFormatter()
        lastdateFormatter.dateFormat = "yyyy-MM-dd"
        if let lastdate = lastdateFormatter.date(from: String(lastweekday.prefix(10))) {
            lastdateFormatter.dateFormat = "dd-MMM"
            print("lastdate is \(lastdateFormatter.string(from: lastdate))")
            lastweekname = lastdateFormatter.string(from: lastdate)
        }
       
       

        let DefaultFormat = "T00:00:00+05:30";
        Onlydatefirstweekday = Onlydatefirstweekday + DefaultFormat;
        Onlydatelastweekday = Onlydatelastweekday + DefaultFormat;
        print(Onlydatefirstweekday)
        print(Onlydatelastweekday)
        
        Alamofire.request("https://school.moschooling.com/API/GetStudentWeekAttendance", method: .post, parameters: ["StudentID":198,"UserID":92,"StartDate": Onlydatefirstweekday,"EndDate": Onlydatelastweekday], encoding: JSONEncoding.default, headers:["UserID":"92"]).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stdPresentArrayData.removeAll()
                self.stdAbsentApproveArrayData.removeAll()
                self.stdAbsentWithOutApproveArrayData.removeAll()
                print("VEHICLESTUDENTTGetdata")
                if(swiftyJsonVar["status"] == true)
                {
                    self.sundayarraydata.removeAll()
                    self.mondayarraydata.removeAll()
                    self.tuesdayarraydata.removeAll()
                    self.wednesdayarraydata.removeAll()
                    self.thursdayarraydata.removeAll()
                    self.fridayarraydata.removeAll()
                    self.saturdayarraydata.removeAll()
                    
                    if let resData = swiftyJsonVar["Attendance"].arrayObject
                    {
                        print(resData)
                        self.arrRes = resData as! [[String:AnyObject]]
                       
                        for books in self.arrRes
                        {
                            let daydata = books["Day"] as! String
                            print(books["Markings"]?.stringValue ?? "<#default value#>")
                            let statusdata = books["Status"] as! String
                            for innerItem in (books["Markings"] as! [[String:AnyObject]])
                            {
                                print("Markingsdata")
                                self.sundayStatusInfo = books["Status"] as! String
                                let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                let stringValue = "\(getmarktime)"
                                print(String(stringValue.suffix(8)))
                                print(innerItem["Comments"] ?? "<#default value#>")
                                print(innerItem["MarkedTeacher"] ?? "<#default value#>")
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "h:mm a"
//                                //innerItem["MarkTime"] as! String
//                                let date = dateFormatter.date(from: "2018-03-05T13:14:45" )
//                                print(date ?? <#default value#>)
//
                                let string = "2017-01-27T18:36:36Z"
                                let isoFormatter = ISO8601DateFormatter()
                                let date = isoFormatter.date(from: string)!
                                print(date)
                                let formatter = DateFormatter()
                                formatter.timeStyle = .medium
                                let result = formatter.string(from:date)
                                print(result)

                                print("Markingsdata")


                            }
                            print("Markingsdata")

                            //                            let arraymarking = books["Markings"] as! Dictionary
                            print("\n"+daydata+"\n"+statusdata)
                            print("+title+release")
                            if(Onlydatefirstweekday == String(daydata.prefix(10)))
                            {
                                print("SUnday")

                                self.sundayarraydata = [daydata]
                            }
                            if(String(self.mondayweekday.prefix(10)) == String(daydata.prefix(10)))
                            {
                                print("MONDAYY")
                                self.mondayStatusInfo = books["Status"] as! String
                                print(books["StatusCode"]!)
                                let statusdata = books["Status"] as! String
                                if(books["Status"] as! String == "STUDENT_PRESENT")
                                {
                                    
                                    self.stdPresentArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDNT_ABSENT_ON_APPROVE")
                                {
                                    self.stdAbsentApproveArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDENT_ABSENT_WITHOUT_APPROVE")
                                {
                                    self.stdAbsentWithOutApproveArrayData.append(statusdata)
                                }
                               
                               // self.mondayarraydata = [String(daydata)]
                                for innerItem in (books["Markings"] as! [[String:AnyObject]])
                                {
                                    print("Markingsdata")

                                    print(innerItem["MarkTime"] ?? "default")
                                    print(innerItem["Comments"] ?? "<#default value#>")
                                    print(innerItem["MarkedTeacher"] ?? "<#default value#>")
                                    let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                    let stringValue = "\(getmarktime)"
                                    print(String(stringValue.suffix(8)))
                                    self.mondayarraydata.append(String(stringValue.suffix(8)))

                                }
                                print(self.mondayarraydata)
                                print(self.tuesdayarraydata)
                                print(self.wednesdayarraydata)
                                print(self.thursdayarraydata)
                                print(self.fridayarraydata)
                                print(self.saturdayarraydata)
                                print(self.sundayarraydata)
                                
                            }
                            if(String(self.tuesdayweekday.prefix(10)) == String(daydata.prefix(10)))
                            {
                                print("TUESDAYY")
                                self.tuesdayStatusInfo = books["Status"] as! String
                                let statusdata = books["Status"] as! String
                                if(books["Status"] as! String == "STUDENT_PRESENT")
                                {
                                    
                                    self.stdPresentArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDNT_ABSENT_ON_APPROVE")
                                {
                                    self.stdAbsentApproveArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDENT_ABSENT_WITHOUT_APPROVE")
                                {
                                    self.stdAbsentWithOutApproveArrayData.append(statusdata)
                                }
//                                self.tuesdayarraydata = [String(daydata)]
                                for innerItem in (books["Markings"] as! [[String:AnyObject]])
                                {
                                    print("Markingsdata")
                                    
                                    print(innerItem["MarkTime"] ?? "default")
                                    print(innerItem["Comments"] ?? "<#default value#>")
                                    print(innerItem["MarkedTeacher"] ?? "<#default value#>")
                                    let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                    let stringValue = "\(getmarktime)"
                                    print(String(stringValue.suffix(8)))
                                    self.tuesdayarraydata.append(String(stringValue.suffix(8)))
                                 


                                }
                                print(self.mondayarraydata)
                                print(self.tuesdayarraydata)
                                print(self.wednesdayarraydata)
                                print(self.thursdayarraydata)
                                print(self.fridayarraydata)
                                print(self.saturdayarraydata)
                                print(self.sundayarraydata)
                            }
                            if(String(self.wednesdayweekday.prefix(10)) == String(daydata.prefix(10)))
                            {
                                print("WEDNESDAYY")
                                self.wednesdayStatusInfo = books["Status"] as! String
                                let statusdata = books["Status"] as! String
                                if(books["Status"] as! String == "STUDENT_PRESENT")
                                {
                                    
                                    self.stdPresentArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDNT_ABSENT_ON_APPROVE")
                                {
                                    self.stdAbsentApproveArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDENT_ABSENT_WITHOUT_APPROVE")
                                {
                                    self.stdAbsentWithOutApproveArrayData.append(statusdata)
                                }
                               // self.wednesdayarraydata = [String(daydata)]
                                for innerItem in (books["Markings"] as! [[String:AnyObject]])
                                {
                                    print("Markingsdata")
                                    
                                    print(innerItem["MarkTime"] ?? "default")
                                    print(innerItem["Comments"] ?? "<#default value#>")
                                    print(innerItem["MarkedTeacher"] ?? "<#default value#>")
                                    let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                    let stringValue = "\(getmarktime)"
                                    print(String(stringValue.suffix(8)))
                                    self.wednesdayarraydata.append(String(stringValue.suffix(8)))
                                    
                                }
                                print(self.mondayarraydata)
                                print(self.tuesdayarraydata)
                                print(self.wednesdayarraydata)
                                print(self.thursdayarraydata)
                                print(self.fridayarraydata)
                                print(self.saturdayarraydata)
                                print(self.sundayarraydata)
                                
                            }
                            if(String(self.thursdayweekday.prefix(10)) == String(daydata.prefix(10)))
                            {
                                print("THURSDAYY")
                                self.thursdayStatusInfo = books["Status"] as! String
                                let statusdata = books["Status"] as! String
                                if(books["Status"] as! String == "STUDENT_PRESENT")
                                {
                                    
                                    self.stdPresentArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDNT_ABSENT_ON_APPROVE")
                                {
                                    self.stdAbsentApproveArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDENT_ABSENT_WITHOUT_APPROVE")
                                {
                                    self.stdAbsentWithOutApproveArrayData.append(statusdata)
                                }
                               // self.thursdayarraydata.append(String(daydata))
                                for innerItem in (books["Markings"] as! [[String:AnyObject]])
                                {
                                    print("Markingsdata")
                                    
                                    print(innerItem["MarkTime"] ?? "default")
                                    print(innerItem["Comments"] ?? "<#default value#>")
                                    print(innerItem["MarkedTeacher"] ?? "<#default value#>")
                                    let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                    let stringValue = "\(getmarktime)"
                                    print(String(stringValue.suffix(8)))
                                    self.thursdayarraydata.append(String(stringValue.suffix(8)))
                                    
                                }
                                print(self.mondayarraydata)
                                print(self.tuesdayarraydata)
                                print(self.wednesdayarraydata)
                                print(self.thursdayarraydata)
                                print(self.fridayarraydata)
                                print(self.saturdayarraydata)
                                print(self.sundayarraydata)
                            }
                            if(String(self.fridayweekday.prefix(10)) == String(daydata.prefix(10)))
                            {
                                print("FRIDAYY")
                                self.fridayStatusInfo = books["Status"] as! String
                                let statusdata = books["Status"] as! String
                                if(books["Status"] as! String == "STUDENT_PRESENT")
                                {
                                    
                                    self.stdPresentArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDNT_ABSENT_ON_APPROVE")
                                {
                                    self.stdAbsentApproveArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDENT_ABSENT_WITHOUT_APPROVE")
                                {
                                    self.stdAbsentWithOutApproveArrayData.append(statusdata)
                                }
                              //  self.fridayarraydata.append(String(daydata))
                                for innerItem in (books["Markings"] as! [[String:AnyObject]])
                                {
                                    print("Markingsdata")
                                    
                                    print(innerItem["MarkTime"] ?? "default")
                                    print(innerItem["Comments"] ?? "<#default value#>")
                                    print(innerItem["MarkedTeacher"] ?? "<#default value#>")
                                    let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                    let stringValue = "\(getmarktime)"
                                    print(String(stringValue.suffix(8)))
                                    self.fridayarraydata.append(String(stringValue.suffix(8)))
                                    
                                }
                                //self.fridayarraydata = ["2018-03-10T00:00:00"]
                                print(self.mondayarraydata)
                                print(self.tuesdayarraydata)
                                print(self.wednesdayarraydata)
                                print(self.thursdayarraydata)
                                print(self.fridayarraydata)
                                print(self.saturdayarraydata)
                                print(self.sundayarraydata)
                                
                            }
                            
                            if(String(self.lastweekday.prefix(10)) == String(daydata.prefix(10)))
                            {
                                print("SATURDAYY")
                                self.saturdayStatusInfo = books["Status"] as! String
                                let statusdata = books["Status"] as! String
                                if(books["Status"] as! String == "STUDENT_PRESENT")
                                {
                                    
                                    self.stdPresentArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDNT_ABSENT_ON_APPROVE")
                                {
                                    self.stdAbsentApproveArrayData.append(statusdata)
                                }
                                if(books["Status"] as! String == "STUDENT_ABSENT_WITHOUT_APPROVE")
                                {
                                    self.stdAbsentWithOutApproveArrayData.append(statusdata)
                                }
                                for innerItem in (books["Markings"] as! [[String:AnyObject]])
                                {
                                    print("Markingsdata")
                                    
                                    print(innerItem["MarkTime"] ?? "default")
                                    print(innerItem["Comments"] ?? "<#default value#>")
                                    print(innerItem["MarkedTeacher"] ?? "<#default value#>")
                                    let getmarktime = innerItem["MarkTime"] ?? "default" as AnyObject
                                    let stringValue = "\(getmarktime)"
                                    print(String(stringValue.suffix(8)))
                                    self.saturdayarraydata.append(String(stringValue.suffix(8)))
                                    
                                }
                                print(self.mondayarraydata)
                                print(self.tuesdayarraydata)
                                print(self.wednesdayarraydata)
                                print(self.thursdayarraydata)
                                print(self.fridayarraydata)
                                print(self.saturdayarraydata)
                                print(self.sundayarraydata)
                            }
                        }
                    }
                    self.setupData()
                    self.AttendanceListTableView.reloadData()
                }
            }
        }


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
extension AttendanceVC : UITableViewDelegate { }

extension AttendanceVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 82.0;//Choose your custom row height
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       // return self.WeekDaysArray.count
//        return categories.count
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsAttendanceTableViewCell") as! StudentsAttendanceTableViewCell
//        let text = "\(self.days[indexPath.row])"
//
//        cell.weekdayslabel.text = self.WeekDaysArray[indexPath.row]
//        cell.daylabel.text = text
//        
//        return cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
        
        if cell == nil {
            cell = CustomTableViewCell.customCell
        }
        
        cell?.WeekDayLabel.text = WeekDaysArray[indexPath.section]
        let text = "\(self.days[indexPath.section])"
        cell?.WeekDateLabel.text = text
        print(indexPath.section);
        print("indexPath.section");

        let aCategory = self.categories[indexPath.section]
        print(indexPath.section);

        print(aCategory.cayegoryItems);
        print("aCategory.cayegoryItems");

        cell?.updateCellWith(category: aCategory)
        return cell!
    }
   
    
}
// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension AttendanceVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        print("ONLYYRANGE SELECTED: \(dayView.date.commonDescription)")
        CalendarBGview.isHidden = true
        // selectedDateText.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        print(dayView.date.description)
        print(dayView.date.day)
        print(dayView.date.convertedDate()!)
        print("dayView")
        print(dayView.date.debugDescription)
        print(dayView.date.globalDescription)
        
        print(dayView)
        // create calendar
        let calendar = Calendar(identifier: .gregorian)
        
        // today's date
        // let today = Date()
        let isoDate = "2018-03-07T10:44:00+0000"
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd 00:00:00ZZZZ"
        
        let myString = formatter.string(from: dayView.date.convertedDate()!)
        // convert your string to date

        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
//        let dateFormatter = ISO8601DateFormatter()
//        let date = dateFormatter.date(from:myString)
        let weekday = calendar.component(.weekday, from: yourDate!)
        let beginningOfWeek : Date
        if weekday != 2 { // if today is not Monday, get back
            let weekDateConponent = DateComponents(weekday: 2)
            beginningOfWeek = calendar.nextDate(after: yourDate!, matching: weekDateConponent, matchingPolicy: .nextTime, direction: .backward)!
            
        } else { // today is Monday
            beginningOfWeek = calendar.startOfDay(for: yourDate!)
        }
        days .removeAll()
//        var days = [Int]()
       

        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: beginningOfWeek)!
            print(date)
            print(beginningOfWeek)

            if(i == 0)
            {
            firstweekday = String(describing: date)
            }
            if(i == 1)
            {
                mondayweekday = String(describing: date)
            }
            if(i == 2)
            {
                tuesdayweekday = String(describing: date)
            }
            if(i == 3)
            {
                wednesdayweekday = String(describing: date)
            }
            if(i == 4)
            {
                thursdayweekday = String(describing: date)
            }
            if(i == 5)
            {
                fridayweekday = String(describing: date)
            }
            if(i == 6)
            {
                lastweekday = String(describing: date)
            }
           // let calendar = Calendar.current
            let day = calendar.component(.day, from: beginningOfWeek)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)

            print("date")
            print(String(String(describing: date).prefix(10)))
            let getstring = String(String(describing: date).prefix(10))
            print(getstring)

            print(getstring.suffix(2))
            days.append(Int(getstring.suffix(2))!)
        }
        
        print(days)
        print(firstweekday)
        apicall()

    }
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(100)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0

                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity

            }) { _ in

                self.animationFinished = true
               // self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
                self.CalendarBGview.isHidden = false

            }
            
            self.CalendarBGview.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
   
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 70
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        } else {
            return Date()
        }
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension AttendanceVC: CVCalendarViewAppearanceDelegate {
    
    
    
    
}

// MARK: - IB Actions

extension AttendanceVC {
    @IBAction func switchChanged(sender: UISwitch) {
        calendarView.changeDaysOutShowingState(shouldShow: sender.isOn)
        shouldShowDaysOut = sender.isOn
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.weekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.monthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension AttendanceVC {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar) // from today
        
        components.month! += offset
        let resultDate = currentCalendar.date(from: components)!
        print(resultDate)
        print("RESULTDATE")
        self.calendarView.toggleViewWithDate(resultDate)
    }
    func didShowNextMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
    
    func didShowPreviousMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }

    
}
//Milliseconds to date
extension Int {
    func dateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}
/*
 STUDENT_PRESENT 1020
 STUDNT_ABSENT_ON_APPROVE 1021
 STUDENT_ABSENT_WITHOUT_APPROVE 1022
 */
