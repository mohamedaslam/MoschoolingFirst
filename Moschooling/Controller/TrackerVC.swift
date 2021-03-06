//
//  TrackerVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 27/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import SwiftyJSON
class TrackerVC: BaseViewController {
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var CalendarBGview: UIView!
    @IBOutlet weak var weekDateNameLabel: UILabel?
    var firstweekday = String()
    var mondayweekday = String()
    var tuesdayweekday = String()
    var wednesdayweekday = String()
    var thursdayweekday = String()
    var fridayweekday = String()
    var lastweekday = String()

    var shouldShowDaysOut = true
    var animationFinished = true
    var selectedDay:DayView!
    @IBOutlet weak var monthLabel: UILabel!
    var firstweekname = String()
    var tostr = String()
    var lastweekname = String()
    var currentCalendar: Calendar?
    var getselecteddate = String()
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        let tap = UITapGestureRecognizer(target: self, action: #selector(AttendanceVC.tapFunction))
        weekDateNameLabel?.isUserInteractionEnabled = true
        weekDateNameLabel?.addGestureRecognizer(tap)
        
        weekDateNameLabel?.layer.masksToBounds = true;
        weekDateNameLabel?.layer.cornerRadius = 20.0;
        weekDateNameLabel?.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        weekDateNameLabel?.layer.borderWidth = 2;
        // Do any additional setup after loading the view.
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        CalendarBGview.isHidden = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setupData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.calendarView.commitCalendarViewUpdate()
        self.calendarMenuView.commitMenuViewUpdate()
        CalendarBGview.isHidden = true
        
        if let currentCalendar = currentCalendar {
            //monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Data initlisers methods
    func setupData() {
        for index in 0..<7 {
            var infoDict = [String:Any]()
            infoDict = dataForIndex(index: index)
            
            print(infoDict)
            print("infoDict")
           
        }
        
    }
    
    func dataForIndex(index:Int) -> [String:Any] {
        var data = [String:Any]()

        
        print(index)
        self.weekDateNameLabel?.layer.masksToBounds = true;
        self.weekDateNameLabel?.layer.cornerRadius = 20.0;
        self.weekDateNameLabel?.layer.borderColor = UIColor(red: 117/255.0, green: 167/255.0, blue: 87/255.0, alpha: 1.0).cgColor
        self.weekDateNameLabel?.text = firstweekname + tostr + lastweekname
        print("stdAbsentWithOutApproveArrayData")
        print("self.sundayarraydata")
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
        
        self.weekDateNameLabel?.text = firstweekname + tostr + lastweekname

        
        let DefaultFormat = "T00:00:00+05:30";
        Onlydatefirstweekday = Onlydatefirstweekday + DefaultFormat;
        Onlydatelastweekday = Onlydatelastweekday + DefaultFormat;
        print(Onlydatefirstweekday)
        print(Onlydatelastweekday)
        
        
       
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
// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension TrackerVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .weekView
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
        }
        
        print(firstweekday)
        apicall()
//        setupData()
        
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

extension TrackerVC: CVCalendarViewAppearanceDelegate {
    
    
    
    
}

// MARK: - IB Actions

extension TrackerVC {
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

extension TrackerVC {
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

