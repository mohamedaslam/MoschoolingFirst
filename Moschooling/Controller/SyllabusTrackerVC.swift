//
//  SyllabusTrackerVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 05/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import SwiftyJSON
class SyllabusTrackerVC:BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var selectedDateText: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    
    fileprivate var randomNumberOfDotMarkersForDay = [Int]()
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var selectedDay:DayView!
    
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
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    private let myArray: NSArray = ["First","Second","Third"]
    
    @IBOutlet weak var syllabustrackertableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        syllabustrackertableview.dataSource = self
        syllabustrackertableview.delegate = self
        
        
        // CVCalendarMenuView initialization with frame
        //        self.calendarMenuView = CVCalendarMenuView(frame: CGRectMake(0, 0, 300, 15))
        //self.calendarMenuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 400, width: 320, height: 15))
        
        // CVCalendarView initialization with frame
        // self.calendarView = CVCalendarView(frame: CGRectMake(0, 20, 300, 450))
        //self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 420, width: 320, height: 450))
        // Appearance delegate [Unnecessary]
        // self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        // self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        // self.calendarMenuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        // self.calendarView.calendarDelegate = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return myArray.count
        return 0
        
    }
    
    @IBAction func nextdate(_ sender: Any) {
        calendarView.loadPreviousView()
        
    }
    @IBAction func previewsdate(_ sender: Any)
    {
        calendarView.loadNextView()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SyllabusTrackerTableViewCell", for: indexPath) as! SyllabusTrackerTableViewCell
        
        // cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 194.0;//Choose your custom row height
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.calendarMenuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
}
// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension SyllabusTrackerVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        // selectedDateText.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        print(dayView.date.description)
        print(dayView.date.debugDescription)
        print(dayView.date.globalDescription)
        
        print(dayView)
        getselecteddate = dayView.date.commonDescription
        // self.selectedDateLabel.text = dayView.date.commonDescription
        
        //selectedDateText.titleLabel?.text = dayView.date.commonDescription
    }
    
    
}
// MARK: - CVCalendarViewAppearanceDelegate

extension SyllabusTrackerVC: CVCalendarViewAppearanceDelegate {
    
    
    
    
}

// MARK: - IB Actions

extension SyllabusTrackerVC {
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

extension SyllabusTrackerVC {
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


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */




