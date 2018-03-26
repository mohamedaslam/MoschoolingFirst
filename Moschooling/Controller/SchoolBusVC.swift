//
//  SchoolBusVC.swift
//  Moschooling
//
//  Created by Mohammed Aslam on 05/03/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//
extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
import UIKit
import Alamofire
import SwiftyJSON
class SchoolBusVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var vehicleLocationTableview: UITableView!
    var items: [DriverData] = []
    var driverinfodata = [[String:AnyObject]]() //Array of dictionary
    var vehicleinfoData = [[String:AnyObject]]() //Array of dictionary
    var driversupportinfodata = [[String:AnyObject]]() //Array of dictionary

    @IBOutlet weak var vehicleNumberLabel: UILabel!
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var careTakerNameLabel: UILabel!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var careTakerImageView: UIImageView!
    
    
    
    
    //.updateChildValues(["locationTimestamp": "1520792794780"])
    //myRef.orderByChild("locationTimestamp").startAt(timeStamp).limitToLast(15).addChildEventListene
    func getDiffernce(toTime:Date) -> Int{
        let elapsed = NSDate().timeIntervalSince(toTime)
        return Int(elapsed * 1000)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let strDate = "2018-03-11T00:00:00+05:30"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: strDate)
        print(date!)
        let millieseconds = self.getDiffernce(toTime: date!)
        print(millieseconds)
        print("millieseconds")
        let ref = Database.database().reference(withPath: "vehicleLocation").child("1066").child("61").child("Location")
        let _ = ref
            .queryOrdered(byChild: "locationTimestamp")
            .queryStarting(atValue: 1520873630868)
            .queryLimited(toLast: 5)
            .observe(.value, with: { snapshot in

           // .observeSingleEvent(of: .value, with: { snapshot in
               //  2
                            var newItems: [DriverData] = []
                            print(newItems)
                            print("newItems")
                
                            // 3
                            for item in snapshot.children {
                                // 4
                                let groceryItem = DriverData(snapshot: item as! DataSnapshot)
                                newItems.append(groceryItem)
                                print(groceryItem)
                                print("GGgroceryItem")
                
                            }
                
                            // 5
                            self.items = newItems
                            self.vehicleLocationTableview .reloadData()
            })

        /*  Alamofire.request("https://school.moschooling.com/API/GetParentChildren", method:.post, parameters: ["UserID":92], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
         
         switch(response.result) {
         case .success(_):
         if response.result.value != nil{
         let swiftyJsonVar = JSON(response.result.value!)
         print(swiftyJsonVar)
         print("Getdata")
         if let resData = swiftyJsonVar["school"].array
         {
         print(resData)
         print("RESDATA")
         }
         }
         break
         
         case .failure(_):
         print(response.result.error as Any)
         break
         
         }
         }
         */
        
        //////
        //let headerss = ["UserID":92] as [String : Int]
     
        ///////////?GetVehicle student info
        
        Alamofire.request("https://school.moschooling.com/api/getStudentvehicleInfo", method: .get, parameters: ["studentID": 198], encoding: URLEncoding.default, headers: ["UserID":"92"]).responseJSON { (response:DataResponse<Any>) in
            // Alamofire.request("https://school.moschooling.com/API/GetParentChildren", method : .post, parameters:["UserID":92], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    print("VEHICLESTUDENTTGetdata")
                    var resData = swiftyJsonVar["driver"]
                    let schoolName = resData["lastName"]
                    print(schoolName)
                    print(resData["lastName"])

                    print(resData["phone"])
                    print(resData["firstName"])
                    self.driverNameLabel.text = resData["firstName"].string ?? "" + resData["lastName"].string!
                    print(resData["email"])
                    print(resData["profileImage"])
                    print(resData["userID"])
                    
                    /////////
                    var vehicledata = swiftyJsonVar["vehicle"]
                    let routeName = resData["routeName"]
                    print(routeName)
                    self.routeNameLabel.text = vehicledata["routeName"].string ?? ""
                    print(vehicledata["routeName"].string ?? "")
                    print(vehicledata["vehicleID"])
                    print(vehicledata["vehicleNumber"])
                    self.vehicleNumberLabel.text = vehicledata["vehicleNumber"].string ?? ""

                    print(vehicledata["totalStudent"])
                    print(vehicledata["routeDestination"])
                    
                    //////////
                    var driverSupportData = swiftyJsonVar["driverSupport"]
                    print(driverSupportData["lastName"])
                    print(driverSupportData["phone"])
                    print(driverSupportData["firstName"])
                    self.careTakerNameLabel.text = driverSupportData["firstName"].string ?? "" + driverSupportData["lastName"].string!

                    print(driverSupportData["email"])
                    print(driverSupportData["profileImage"])
                    print(driverSupportData["userID"])
                  
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
        print(self.driverinfodata)
        print(self.driversupportinfodata)
        print(self.vehicleinfoData)
        print("DRIVERVEHICLE")
        var getcurrentdate = String()
        ////////////////?VEHICLE STaTUS
        var getcurrendate : String!
        
        //        let dateString = Formatter.iso8601.string(from: Date())   // "2018-01-23T03:06:46.232Z"
        //        print(dateString)   // "2018-01-23 03:06:46 +0000\n"
        //        print("1CURENNTDATTEEEdate")
        //        if let date = Formatter.iso8601.date(from: dateString)  {
        //            print(date)   // "2018-01-23 03:06:46 +0000\n"
        //            print("2CURENNTDATTEEEdate")
        //        }
//        let dateString = "2016-12-15T22:10:00Z"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let date = dateFormatter.date(from: dateString)
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//                                   //2018-03-09T00:07:31+05:30
//
//        let date = Date()
//        let dateString = dateFormatter.string(from: date)
//        let interval = date.timeIntervalSince1970
//        print(interval)
//        print(dateString)
//        print("<#T##items: Any...##Any#>")
      //  let s = dateFormatter.string(from: date!)
        //        "VehicleID": 5,
        //        "busDate": "2018-02-22T10:09:12.578Z"
        Alamofire.request("https://school.moschooling.com/API/getvehicleStatus", method: .post, parameters: ["VehicleID": 5 ,"busDate": "2018-03-11T00:00:00+05:30"
            ], encoding: JSONEncoding.default, headers:["UserID":"92"]).responseJSON { (response:DataResponse<Any>) in
                // Alamofire.request("https://school.moschooling.com/API/GetParentChildren", method : .post, parameters:["UserID":92], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        let swiftyJsonVar = JSON(response.result.value!)
                        print(swiftyJsonVar)
                        print("VEHICLE STATUS DATAAAA")
                   
                        print(swiftyJsonVar["status"])
                        print(swiftyJsonVar["routeType"])
                        print(swiftyJsonVar["vehicleStatus"])
                        print(swiftyJsonVar["statusMessage"])
                        print(swiftyJsonVar["laststatusUpdatetime"])
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error as Any)
                    break
                    
                }
        }
        
        
        addSlideMenuButton()
        vehicleLocationTableview.delegate = self
        vehicleLocationTableview.dataSource = self
        
     
        
        // Do any additional setup after loading the view.
    }
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleLocationTableViewCell", for: indexPath) as! VehicleLocationTableViewCell
        let groceryItem = items[indexPath.row]
        
       // cell.latituteLabel?.text = String(groceryItem.currentlatitude)
       // cell.LongituteLabel?.text = String(groceryItem.currentlongitude)
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(groceryItem.locationTimestamp)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        print(dateFormatter.string(from: dateVar))
        cell.timestampLabel?.text = dateFormatter.string(from: dateVar)

       // cell.timestampLabel?.text = String(describing: date)
        cell.addressLabel?.text = groceryItem.currentAddress
        // toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
        //    if editingStyle == .delete {
        //      items.remove(at: indexPath.row)
        //      tableView.reloadData()
        //    }
    }
    
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     2018-02-15 15:11:16.145201+0530 MoschoollingApp[12990:275264] [Firebase/Analytics][I-ACS023007] Firebase Analytics v.40005000 started
     2018-02-15 15:11:16.145533+0530 MoschoollingApp[12990:275264] [Firebase/Analytics][I-ACS023008] To enable debug logging set the following application argument: -FIRAnalyticsDebugEnabled (see http://goo.gl/RfcP7r)
     2018-02-15 15:11:17.572296+0530 MoschoollingApp[12990:275334] TIC Read Status [1:0x0]: 1:57
     2018-02-15 15:11:17.572458+0530 MoschoollingApp[12990:275334] TIC Read Status [1:0x0]: 1:57
     2018-02-15 15:11:18.101270+0530 MoschoollingApp[12990:274969] [MC] Lazy loading NSBundle MobileCoreServices.framework
     2018-02-15 15:11:18.102265+0530 MoschoollingApp[12990:274969] [MC] Loaded MobileCoreServices.framework
     {
     "status" : true,
     "statusMessage" : "School found",
     "school" : {
     "phone" : "99547823654",
     "schoolLogo" : "https:\/\/s3.amazonaws.com\/mos-resources\/School\/Images\/Logo\/636419539225332508bvb.jpg",
     "schoolName" : "Bharathi vidya bhavan",
     "email" : "info@moschooling.com",
     "SchoolID" : 1066,
     "schoolAddress" : "Bangalore"
     }
     }
     Getdata
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
     Getdata
     {
     "status" : true,
     "statusMessage" : "Success",
     "Students" : [
     {
     "StudentName" : "Vinod Babu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "Divsion 1",
     "ClassDepartDivID" : 8,
     "pickuplocation" : null,
     "ClassDivision" : "Class1 GENERAL Divsion 1",
     "ClassName" : "Class1",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 167
     },
     {
     "StudentName" : "Ravi Shankar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 9,
     "pickuplocation" : null,
     "ClassDivision" : "I GENERAL A",
     "ClassName" : "I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 170
     },
     {
     "StudentName" : "Oman rashi",
     "DepartmentName" : "GENERAL",
     "latitude" : "10.5703867",
     "DivisionName" : "A",
     "ClassDepartDivID" : 9,
     "pickuplocation" : "Kolazhy",
     "ClassDivision" : "I GENERAL A",
     "ClassName" : "I",
     "longitude" : "76.22183940000002",
     "ImageLocation" : "",
     "StudentID" : 171
     },
     {
     "StudentName" : "Shifa Mol",
     "DepartmentName" : "GENERAL",
     "latitude" : "10.6418441",
     "DivisionName" : "B",
     "ClassDepartDivID" : 10,
     "pickuplocation" : "Parlikad",
     "ClassDivision" : "I GENERAL B",
     "ClassName" : "I",
     "longitude" : "76.22183940000002",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/636418744388429978fire.png",
     "StudentID" : 172
     },
     {
     "StudentName" : "Ravi Shankar",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/636474168577288265VINOD_0726 copy.jpg",
     "StudentID" : 173
     },
     {
     "StudentName" : "Oman rashi",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9488681",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "India",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.74016519999998",
     "ImageLocation" : "",
     "StudentID" : 174
     },
     {
     "StudentName" : "Ravi Shankar",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "",
     "StudentID" : 175
     },
     {
     "StudentName" : "Oman rashi",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9689968",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Kundalahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273530938081927.jpg",
     "StudentID" : 176
     },
     {
     "StudentName" : "Raju Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273535958676804.jpg",
     "StudentID" : 177
     },
     {
     "StudentName" : "Amar Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9566734",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Siddapura",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.73399930000005",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/63642735395813683210.jpg",
     "StudentID" : 178
     },
     {
     "StudentName" : "Bindu Madhavi",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9566734",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Siddapura",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.73399930000005",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273544243126406.jpg",
     "StudentID" : 179
     },
     {
     "StudentName" : "Kamal Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273547137223209.jpg",
     "StudentID" : 180
     },
     {
     "StudentName" : "Ankith Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9566734",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Siddapura",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.73399930000005",
     "ImageLocation" : "",
     "StudentID" : 181
     },
     {
     "StudentName" : "Catherin Thomas",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9566734",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Siddapura",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.73399930000005",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273525181091521.jpg",
     "StudentID" : 182
     },
     {
     "StudentName" : "Naveen Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273521987444005.jpg",
     "StudentID" : 183
     },
     {
     "StudentName" : "Jason Jojo",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9689968",
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : "Kundalahalli",
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "https:\/\/s3.amazonaws.com\/mos-resources\/Images\/Student\/ProfileImage\/6364273507779066882.jpg",
     "StudentID" : 184
     },
     {
     "StudentName" : "Ravi Shankar",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9566734",
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : "Siddapura",
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : "77.73399930000005",
     "ImageLocation" : "",
     "StudentID" : 185
     },
     {
     "StudentName" : "Oman rashi",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "",
     "StudentID" : 186
     },
     {
     "StudentName" : "Raju Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "",
     "StudentID" : 187
     },
     {
     "StudentName" : "Amar Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "",
     "StudentID" : 188
     },
     {
     "StudentName" : "Bindu Madhavi",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 189
     },
     {
     "StudentName" : "Kamal Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 190
     },
     {
     "StudentName" : "Ankith Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 191
     },
     {
     "StudentName" : "Catherin Thomas",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 192
     },
     {
     "StudentName" : "Naveen Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 193
     },
     {
     "StudentName" : "Jason Jojo",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 88,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL B",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 194
     },
     {
     "StudentName" : "Anil Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 195
     },
     {
     "StudentName" : "Oman rashi",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 196
     },
     {
     "StudentName" : "Raju Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 197
     },
     {
     "StudentName" : "Akhil Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9520393",
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : "Thubarahalli",
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : "77.72088529999996",
     "ImageLocation" : "",
     "StudentID" : 198
     },
     {
     "StudentName" : "Bindu Madhavi",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 199
     },
     {
     "StudentName" : "Radha Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 200
     },
     {
     "StudentName" : "Ankith Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 201
     },
     {
     "StudentName" : "Catherin Thomas",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 202
     },
     {
     "StudentName" : "Dicson Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 203
     },
     {
     "StudentName" : "Anuradha Jojo",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 90,
     "pickuplocation" : null,
     "ClassDivision" : "Class II GENERAL A",
     "ClassName" : "Class II",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 204
     },
     {
     "StudentName" : "Shibu Koriyan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 205
     },
     {
     "StudentName" : "Amudha Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 206
     },
     {
     "StudentName" : "Kumar Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 207
     },
     {
     "StudentName" : "Sabu John",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 208
     },
     {
     "StudentName" : "Keerthi Kanth",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 209
     },
     {
     "StudentName" : "Bindu Wilson",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 210
     },
     {
     "StudentName" : "Kavi Raja",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 211
     },
     {
     "StudentName" : "Sendhil Nathan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 212
     },
     {
     "StudentName" : "Banu Priya",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 213
     },
     {
     "StudentName" : "Shibu Koriyan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 214
     },
     {
     "StudentName" : "Sundar Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 114,
     "pickuplocation" : null,
     "ClassDivision" : "Class III GENERAL A",
     "ClassName" : "Class III",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 215
     },
     {
     "StudentName" : "Banu Priya",
     "DepartmentName" : "GENERAL",
     "latitude" : "12.9566734",
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : "Siddapura",
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : "77.73399930000005",
     "ImageLocation" : "",
     "StudentID" : 216
     },
     {
     "StudentName" : "Sudha Kuamr",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 217
     },
     {
     "StudentName" : "Kanthi Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 218
     },
     {
     "StudentName" : "Sneha Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 219
     },
     {
     "StudentName" : "Jony Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 220
     },
     {
     "StudentName" : "Sunil Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 221
     },
     {
     "StudentName" : "Sindhu Ja",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 222
     },
     {
     "StudentName" : "Anu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 223
     },
     {
     "StudentName" : "Bindya Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 224
     },
     {
     "StudentName" : "Vishal Naidu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 113,
     "pickuplocation" : null,
     "ClassDivision" : "Class IV GENERAL A",
     "ClassName" : "Class IV",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 225
     },
     {
     "StudentName" : "Snehan Priya",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 226
     },
     {
     "StudentName" : "Bindu Kuamr",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 227
     },
     {
     "StudentName" : "Arav Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 228
     },
     {
     "StudentName" : "Harish Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 229
     },
     {
     "StudentName" : "Amar kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 230
     },
     {
     "StudentName" : "Basil Kuamr",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 231
     },
     {
     "StudentName" : "Kanaka Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 232
     },
     {
     "StudentName" : "Dali Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 233
     },
     {
     "StudentName" : "Lijo Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 234
     },
     {
     "StudentName" : "Amar Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 108,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL A",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 235
     },
     {
     "StudentName" : "Aji Kuamr",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 236
     },
     {
     "StudentName" : "Suraj Albert",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 237
     },
     {
     "StudentName" : "Madhu Sudhan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 238
     },
     {
     "StudentName" : "Logha Nathan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 239
     },
     {
     "StudentName" : "Girish Babu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 240
     },
     {
     "StudentName" : "Thyagu Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 241
     },
     {
     "StudentName" : "Balu Vardhan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 242
     },
     {
     "StudentName" : "Krishna Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 243
     },
     {
     "StudentName" : "Balraj John",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 244
     },
     {
     "StudentName" : "Lankesh Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 107,
     "pickuplocation" : null,
     "ClassDivision" : "Class VI GENERAL A",
     "ClassName" : "Class VI",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 245
     },
     {
     "StudentName" : "Anu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 246
     },
     {
     "StudentName" : "Bindya Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 247
     },
     {
     "StudentName" : "Sneha Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 248
     },
     {
     "StudentName" : "Jony Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 249
     },
     {
     "StudentName" : "Elija Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 250
     },
     {
     "StudentName" : "Sindu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 251
     },
     {
     "StudentName" : "Amar Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 252
     },
     {
     "StudentName" : "Basil Naidu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 253
     },
     {
     "StudentName" : "Kanaka Vardhan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 254
     },
     {
     "StudentName" : "Sindhu Ja",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 255
     },
     {
     "StudentName" : "Anu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 256
     },
     {
     "StudentName" : "Bindya Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 257
     },
     {
     "StudentName" : "Sneha Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 258
     },
     {
     "StudentName" : "Jony Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 259
     },
     {
     "StudentName" : "Elija Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 260
     },
     {
     "StudentName" : "Sindu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 261
     },
     {
     "StudentName" : "Amar Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 262
     },
     {
     "StudentName" : "Basil Naidu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 263
     },
     {
     "StudentName" : "Kanaka Vardhan",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 264
     },
     {
     "StudentName" : "Sindhu Ja",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 265
     },
     {
     "StudentName" : "Anu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 266
     },
     {
     "StudentName" : "Bindya Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 103,
     "pickuplocation" : null,
     "ClassDivision" : "Class VII GENERAL A",
     "ClassName" : "Class VII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 267
     },
     {
     "StudentName" : "Snehan Priya",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 268
     },
     {
     "StudentName" : "Harish Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 269
     },
     {
     "StudentName" : "Amar kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 270
     },
     {
     "StudentName" : "Lijo Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 271
     },
     {
     "StudentName" : "Anu Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 272
     },
     {
     "StudentName" : "Bindya Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 273
     },
     {
     "StudentName" : "Vishal Naidu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 274
     },
     {
     "StudentName" : "Banu Priya",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 275
     },
     {
     "StudentName" : "Sudha Kuamr",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 276
     },
     {
     "StudentName" : "Kanthi Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 99,
     "pickuplocation" : null,
     "ClassDivision" : "Class VIII GENERAL A",
     "ClassName" : "Class VIII",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 277
     },
     {
     "StudentName" : "Sree jith",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 278
     },
     {
     "StudentName" : "Shobin varghese",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 279
     },
     {
     "StudentName" : "Tinto john",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 280
     },
     {
     "StudentName" : "Sony varghese",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 281
     },
     {
     "StudentName" : "Vinodh Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 282
     },
     {
     "StudentName" : "Dali Sree",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 283
     },
     {
     "StudentName" : "Rakshith Bangere",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 284
     },
     {
     "StudentName" : "Sindu varghese",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 285
     },
     {
     "StudentName" : "Sailesh Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 286
     },
     {
     "StudentName" : "Basil Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 98,
     "pickuplocation" : null,
     "ClassDivision" : "Class IX GENERAL A",
     "ClassName" : "Class IX",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 287
     },
     {
     "StudentName" : "Rajashekar kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 288
     },
     {
     "StudentName" : "Sreeja Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 289
     },
     {
     "StudentName" : "Amu Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 290
     },
     {
     "StudentName" : "Arvind Kumar",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 291
     },
     {
     "StudentName" : "Vibin Joy",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 292
     },
     {
     "StudentName" : "Rohith Nath",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 293
     },
     {
     "StudentName" : "Ajith J",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 294
     },
     {
     "StudentName" : "Raghava Ram",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 295
     },
     {
     "StudentName" : "Jeevan Raj",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 296
     },
     {
     "StudentName" : "Sharath Naidu",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 93,
     "pickuplocation" : null,
     "ClassDivision" : "Class X GENERAL A",
     "ClassName" : "Class X",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 297
     },
     {
     "StudentName" : "Shana Sadi",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "B",
     "ClassDepartDivID" : 109,
     "pickuplocation" : null,
     "ClassDivision" : "Class V GENERAL B",
     "ClassName" : "Class V",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 299
     },
     {
     "StudentName" : "Anand Pandey",
     "DepartmentName" : "GENERAL",
     "latitude" : null,
     "DivisionName" : "A",
     "ClassDepartDivID" : 87,
     "pickuplocation" : null,
     "ClassDivision" : "Class I GENERAL A",
     "ClassName" : "Class I",
     "longitude" : null,
     "ImageLocation" : "",
     "StudentID" : 301
     }
     ]
     }
     Getdata
     DriverData(currentlatitude: 12.970783600000001, currentlongitude: 77.736858900000001, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507357099097.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpU-15CoYPHX5mWGsh), key: "-KvpU-15CoYPHX5mWGsh")
     GGgroceryItem
     DriverData(currentlatitude: 12.970783600000001, currentlongitude: 77.736858900000001, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358581421.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpZeE8xgk4qR6cEMO1), key: "-KvpZeE8xgk4qR6cEMO1")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707604, currentlongitude: 77.736836600000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358641671.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpZsZUSkgw53PxNjyd), key: "-KvpZsZUSkgw53PxNjyd")
     GGgroceryItem
     DriverData(currentlatitude: 12.970783600000001, currentlongitude: 77.736858900000001, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358701967.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kvp_6HfnSgKgdjZgt5Q), key: "-Kvp_6HfnSgKgdjZgt5Q")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358762314.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kvp_L0MtoBdMFiZpuMx), key: "-Kvp_L0MtoBdMFiZpuMx")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358822720.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kvp_ZlD07FmEsIo8nh8), key: "-Kvp_ZlD07FmEsIo8nh8")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707604, currentlongitude: 77.736836600000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358882936.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kvp_nSunhQ6BOQRjb64), key: "-Kvp_nSunhQ6BOQRjb64")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507358948624.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kvpa2VP6W9bfNetAp3j), key: "-Kvpa2VP6W9bfNetAp3j")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359008787.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpaHBIdAiJiFsJUEJe), key: "-KvpaHBIdAiJiFsJUEJe")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359069274.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpaVxaDn3CrDwnFmLS), key: "-KvpaVxaDn3CrDwnFmLS")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359129403.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpajcwpzTwRssAAhMT), key: "-KvpajcwpzTwRssAAhMT")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359189839.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpayOGdvrpkxP8yQtp), key: "-KvpayOGdvrpkxP8yQtp")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359249934.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpbC3L8PYATWo6vYrA), key: "-KvpbC3L8PYATWo6vYrA")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359310366.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpbQoV6sjDP4CmOT9c), key: "-KvpbQoV6sjDP4CmOT9c")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707951, currentlongitude: 77.736870100000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1507359370483.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KvpbeUrCtnXRdKdE1Ak), key: "-KvpbeUrCtnXRdKdE1Ak")
     GGgroceryItem
     DriverData(currentlatitude: 10.7483833, currentlongitude: 76.275387199999997, currentAddress: "Chelakkara Government College Road, Cheruthuruthy, Kerala 679531, India\n", locationTimestamp: 1508568241982.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kwxf8YmyAtaIRaD5i0l), key: "-Kwxf8YmyAtaIRaD5i0l")
     GGgroceryItem
     DriverData(currentlatitude: 10.522087300000001, currentlongitude: 76.212604099999993, currentAddress: "3, Kodungallur - Shornur Rd, Kuruppam, Thekkinkadu Maidan, Thrissur, Kerala 680001, India\n", locationTimestamp: 1508568303648.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KwxfNYVGPDyzlvcS6OQ), key: "-KwxfNYVGPDyzlvcS6OQ")
     GGgroceryItem
     DriverData(currentlatitude: 10.523116999999999, currentlongitude: 76.212604099999993, currentAddress: "3, Kodungallur - Shornur Rd, Kuruppam, Thekkinkadu Maidan, Thrissur, Kerala 680001, India\n", locationTimestamp: 1508568362961.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kwxfb-pW_21M-BaeAFr), key: "-Kwxfb-pW_21M-BaeAFr")
     GGgroceryItem
     DriverData(currentlatitude: 10.523116999999999, currentlongitude: 76.212604099999993, currentAddress: "3, Kodungallur - Shornur Rd, Kuruppam, Thekkinkadu Maidan, Thrissur, Kerala 680001, India\n", locationTimestamp: 1508568423114.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KwxfpamCd6asgrvIl5k), key: "-KwxfpamCd6asgrvIl5k")
     GGgroceryItem
     DriverData(currentlatitude: 10.523116999999999, currentlongitude: 76.212604099999993, currentAddress: "3, Kodungallur - Shornur Rd, Kuruppam, Thekkinkadu Maidan, Thrissur, Kerala 680001, India\n", locationTimestamp: 1508568482761.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kwxg3A4EH3c9g6cKpnz), key: "-Kwxg3A4EH3c9g6cKpnz")
     GGgroceryItem
     DriverData(currentlatitude: 10.7483833, currentlongitude: 76.275387199999997, currentAddress: "Chelakkara Government College Road, Cheruthuruthy, Kerala 679531, India\n", locationTimestamp: 1508606350765.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KwxhIs_NsZq8zROmtMn), key: "-KwxhIs_NsZq8zROmtMn")
     GGgroceryItem
     DriverData(currentlatitude: 10.7483833, currentlongitude: 76.275387199999997, currentAddress: "Chelakkara Government College Road, Cheruthuruthy, Kerala 679531, India\n", locationTimestamp: 1508606410637.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KwxhXTXiDdz5IeL0qm7), key: "-KwxhXTXiDdz5IeL0qm7")
     GGgroceryItem
     DriverData(currentlatitude: 10.7483833, currentlongitude: 76.275387199999997, currentAddress: "Chelakkara Government College Road, Cheruthuruthy, Kerala 679531, India\n", locationTimestamp: 1508606558523.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kwxi5_JoIlPGJmJF2Z3), key: "-Kwxi5_JoIlPGJmJF2Z3")
     GGgroceryItem
     DriverData(currentlatitude: 10.7483833, currentlongitude: 76.275387199999997, currentAddress: "Chelakkara Government College Road, Cheruthuruthy, Kerala 679531, India\n", locationTimestamp: 1508606229931.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kwzw2uwfqVIX6EbGjAL), key: "-Kwzw2uwfqVIX6EbGjAL")
     GGgroceryItem
     DriverData(currentlatitude: 12.970753699999999, currentlongitude: 77.737012800000002, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511595874361.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-Kzm7dXze3GvUY1ihpmC), key: "-Kzm7dXze3GvUY1ihpmC")
     GGgroceryItem
     DriverData(currentlatitude: 12.970751099999999, currentlongitude: 77.737009999999998, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597086053.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmCGPx_3jw6zYlXWVR), key: "-KzmCGPx_3jw6zYlXWVR")
     GGgroceryItem
     DriverData(currentlatitude: 12.970760800000001, currentlongitude: 77.737008299999999, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597146751.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmCVEmZpjsz3-qYtI6), key: "-KzmCVEmZpjsz3-qYtI6")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707645, currentlongitude: 77.737004999999996, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597225563.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmCnU2C824YcIe2wZU), key: "-KzmCnU2C824YcIe2wZU")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707601, currentlongitude: 77.737008799999998, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597288014.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmD1isfdQQmje2mxuk), key: "-KzmD1isfdQQmje2mxuk")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707615, currentlongitude: 77.737008000000003, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597349023.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmDGcHRKNDAgjfWht6), key: "-KzmDGcHRKNDAgjfWht6")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707629, currentlongitude: 77.737006399999999, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597410032.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmDVWDWn-LWgu0bFGf), key: "-KzmDVWDWn-LWgu0bFGf")
     GGgroceryItem
     DriverData(currentlatitude: 12.970754899999999, currentlongitude: 77.737013099999999, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597531360.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmDy8FKjbpELjpwZKj), key: "-KzmDy8FKjbpELjpwZKj")
     GGgroceryItem
     DriverData(currentlatitude: 12.970750600000001, currentlongitude: 77.737014299999998, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597591528.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmEBpHskrgV2oiqUKg), key: "-KzmEBpHskrgV2oiqUKg")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707644, currentlongitude: 77.737005100000005, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597654708.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmERFBVADemzKGXNy9), key: "-KzmERFBVADemzKGXNy9")
     GGgroceryItem
     DriverData(currentlatitude: 12.970743199999999, currentlongitude: 77.737015600000007, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597720309.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmEgGvC5q9A1fiboFs), key: "-KzmEgGvC5q9A1fiboFs")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707609, currentlongitude: 77.737003400000006, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597780540.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmEuz4_k0n1LS2zzdP), key: "-KzmEuz4_k0n1LS2zzdP")
     GGgroceryItem
     DriverData(currentlatitude: 12.970758, currentlongitude: 77.737010499999997, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597863027.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmFE6WMLgRpR-UFx8a), key: "-KzmFE6WMLgRpR-UFx8a")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707498, currentlongitude: 77.737016199999999, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597923110.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmFSm70235Eyl5_l2W), key: "-KzmFSm70235Eyl5_l2W")
     GGgroceryItem
     DriverData(currentlatitude: 12.970752600000001, currentlongitude: 77.737007000000006, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511597988618.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmFhlw0qm0zlD3Ul8e), key: "-KzmFhlw0qm0zlD3Ul8e")
     GGgroceryItem
     DriverData(currentlatitude: 12.970753500000001, currentlongitude: 77.736998299999996, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511598049647.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmFwfFHN3kAp09w-Ay), key: "-KzmFwfFHN3kAp09w-Ay")
     GGgroceryItem
     DriverData(currentlatitude: 12.970756700000001, currentlongitude: 77.737014099999996, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1511598130911.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-KzmGFW9br9lYEPFzR1W), key: "-KzmGFW9br9lYEPFzR1W")
     GGgroceryItem
     DriverData(currentlatitude: 12.970703, currentlongitude: 77.736874799999995, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274561716.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LBKNKf9c6DQTY5pa9), key: "-L0LBKNKf9c6DQTY5pa9")
     GGgroceryItem
     DriverData(currentlatitude: 12.970976666666665, currentlongitude: 77.737141666666673, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274595637.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LBScTgs0Xt2w_E9bE), key: "-L0LBScTgs0Xt2w_E9bE")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707069, currentlongitude: 77.736892499999996, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274621919.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LBZ-8qpr5qBYi_X9P), key: "-L0LBZ-8qpr5qBYi_X9P")
     GGgroceryItem
     DriverData(currentlatitude: 12.970702299999999, currentlongitude: 77.736883700000007, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274693350.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LBpR9zBo-HB3BhCZG), key: "-L0LBpR9zBo-HB3BhCZG")
     GGgroceryItem
     DriverData(currentlatitude: 12.970697700000001, currentlongitude: 77.736912000000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274754415.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LC3LOqXSfXPuZSPw9), key: "-L0LC3LOqXSfXPuZSPw9")
     GGgroceryItem
     DriverData(currentlatitude: 12.9707013, currentlongitude: 77.736914600000006, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274821600.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LCJkJHNhRLmh0G_6P), key: "-L0LCJkJHNhRLmh0G_6P")
     GGgroceryItem
     DriverData(currentlatitude: 12.973410000000001, currentlongitude: 77.73789166666667, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513274841657.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LCOhYQSjPiGCc-mcf), key: "-L0LCOhYQSjPiGCc-mcf")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706864, currentlongitude: 77.736914900000002, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274886760.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LCZlfb8fHMQV1JCef), key: "-L0LCZlfb8fHMQV1JCef")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706615, currentlongitude: 77.736980500000001, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274947245.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LCnT0oPccTJhlJ1nl), key: "-L0LCnT0oPccTJhlJ1nl")
     GGgroceryItem
     DriverData(currentlatitude: 12.969391666666668, currentlongitude: 77.738191666666665, currentAddress: "Buildwell, Borewell Rd, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513274962151.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LCr8h6hMDrz7sS5Aw), key: "-L0LCr8h6hMDrz7sS5Aw")
     GGgroceryItem
     DriverData(currentlatitude: 12.970688600000001, currentlongitude: 77.736915999999994, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275007574.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LD194zxwoU4AXQhzV), key: "-L0LD194zxwoU4AXQhzV")
     GGgroceryItem
     DriverData(currentlatitude: 12.969648333333335, currentlongitude: 77.737890000000007, currentAddress: "3, Borewell Rd, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275050648.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LDBloxudVb-7YjRjy), key: "-L0LDBloxudVb-7YjRjy")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706961, currentlongitude: 77.736903400000003, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275093332.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LDM4x-gN8koDn_HHV), key: "-L0LDM4x-gN8koDn_HHV")
     GGgroceryItem
     DriverData(currentlatitude: 12.970695900000001, currentlongitude: 77.736892900000001, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275153583.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LD_nPU-N5G21xiqfc), key: "-L0LD_nPU-N5G21xiqfc")
     GGgroceryItem
     DriverData(currentlatitude: 12.973659999999999, currentlongitude: 77.738011666666665, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275203663.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LDm8hUTRMk7AwflqF), key: "-L0LDm8hUTRMk7AwflqF")
     GGgroceryItem
     DriverData(currentlatitude: 12.970701500000001, currentlongitude: 77.736897600000006, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275213869.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LDoWPbVnvpE0aYx26), key: "-L0LDoWPbVnvpE0aYx26")
     GGgroceryItem
     DriverData(currentlatitude: 12.970695299999999, currentlongitude: 77.736912000000004, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275274297.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LE2Gv4HIHIkSRMh75), key: "-L0LE2Gv4HIHIkSRMh75")
     GGgroceryItem
     DriverData(currentlatitude: 12.972745000000002, currentlongitude: 77.737878333333342, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275359687.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LENGjk4eYWt2uezuB), key: "-L0LENGjk4eYWt2uezuB")
     GGgroceryItem
     DriverData(currentlatitude: 12.970702299999999, currentlongitude: 77.7368886, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275363096.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LENx1zbyzN-ZG2ijL), key: "-L0LENx1zbyzN-ZG2ijL")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706969, currentlongitude: 77.736893100000003, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275423938.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LEbnuEjIMZI4JbA3R), key: "-L0LEbnuEjIMZI4JbA3R")
     GGgroceryItem
     DriverData(currentlatitude: 12.972634999999999, currentlongitude: 77.737788333333341, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275435676.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LEetdLcrk9DPd3tTX), key: "-L0LEetdLcrk9DPd3tTX")
     GGgroceryItem
     DriverData(currentlatitude: 12.970694999999999, currentlongitude: 77.736908799999995, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275484081.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LEqUP9hYPZAGiwn5V), key: "-L0LEqUP9hYPZAGiwn5V")
     GGgroceryItem
     DriverData(currentlatitude: 12.970688300000001, currentlongitude: 77.736927300000005, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275544143.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LF48z68QgnL8iGvZx), key: "-L0LF48z68QgnL8iGvZx")
     GGgroceryItem
     DriverData(currentlatitude: 12.971138333333332, currentlongitude: 77.738061666666667, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275556677.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LF7GbU53lSxQuE8GH), key: "-L0LF7GbU53lSxQuE8GH")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706946, currentlongitude: 77.736905199999995, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275609061.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LFK-KpOXR-SiLJRAi), key: "-L0LFK-KpOXR-SiLJRAi")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706954, currentlongitude: 77.736905399999998, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275669328.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LFYiGTuBwaOL1icUE), key: "-L0LFYiGTuBwaOL1icUE")
     GGgroceryItem
     DriverData(currentlatitude: 12.971596666666668, currentlongitude: 77.737980000000007, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275693829.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LFdtdY7xzdLlPMo7H), key: "-L0LFdtdY7xzdLlPMo7H")
     GGgroceryItem
     DriverData(currentlatitude: 12.970702599999999, currentlongitude: 77.736885200000003, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275729509.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LFmPGuGc-fWjdhYxG), key: "-L0LFmPGuGc-fWjdhYxG")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706957, currentlongitude: 77.736904699999997, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275789737.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LG06_ItK-NNUNwGjd), key: "-L0LG06_ItK-NNUNwGjd")
     GGgroceryItem
     DriverData(currentlatitude: 12.972166666666665, currentlongitude: 77.738133333333323, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275793170.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LG17MSGfIGdieKnxf), key: "-L0LG17MSGfIGdieKnxf")
     GGgroceryItem
     DriverData(currentlatitude: 12.9706966, currentlongitude: 77.736902000000001, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275854800.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LGG--MhP_t5IY7r6p), key: "-L0LGG--MhP_t5IY7r6p")
     GGgroceryItem
     DriverData(currentlatitude: 12.972591666666665, currentlongitude: 77.739046666666667, currentAddress: "Nallurhalli, Whitefield, Bengaluru, Karnataka, India\n", locationTimestamp: 1513275869402.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LGJdZRX9CaEu4zDnq), key: "-L0LGJdZRX9CaEu4zDnq")
     GGgroceryItem
     DriverData(currentlatitude: 12.970694399999999, currentlongitude: 77.736902999999998, currentAddress: "Amrutha Value, Nallurhalli, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513275919272.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0LGVjVZ2z7bKsnB3gl), key: "-L0LGVjVZ2z7bKsnB3gl")
     GGgroceryItem
     DriverData(currentlatitude: 12.986572300000001, currentlongitude: 77.737518300000005, currentAddress: "Discoverer, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513323754728.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O6zjVYSsX-4vmhdh-), key: "-L0O6zjVYSsX-4vmhdh-")
     GGgroceryItem
     DriverData(currentlatitude: 12.986404999999998, currentlongitude: 77.736956666666671, currentAddress: "Discoverer, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513323796882.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O78ftC-f22RRU_PUA), key: "-L0O78ftC-f22RRU_PUA")
     GGgroceryItem
     DriverData(currentlatitude: 12.986026300000001, currentlongitude: 77.736221499999999, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513323840083.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O7JBMPYBLcULYB18a), key: "-L0O7JBMPYBLcULYB18a")
     GGgroceryItem
     DriverData(currentlatitude: 12.9860091, currentlongitude: 77.736240199999997, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513323902637.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O7YWrwO9W7RSHV859), key: "-L0O7YWrwO9W7RSHV859")
     GGgroceryItem
     DriverData(currentlatitude: 12.990868333333333, currentlongitude: 77.74096333333334, currentAddress: "Container Corporation Rd, Kadugodi, Bengaluru, Karnataka 560067, India\n", locationTimestamp: 1513323909114.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O7_3EE8MVV15ZDT39), key: "-L0O7_3EE8MVV15ZDT39")
     GGgroceryItem
     DriverData(currentlatitude: 12.986258333333334, currentlongitude: 77.737271666666658, currentAddress: "Discoverer, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513323974309.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O7ozkb1gy9nBwTKf_), key: "-L0O7ozkb1gy9nBwTKf_")
     GGgroceryItem
     DriverData(currentlatitude: 12.985988600000001, currentlongitude: 77.736243400000006, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513323981744.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O7qgWvSVE_epoQWgk), key: "-L0O7qgWvSVE_epoQWgk")
     GGgroceryItem
     DriverData(currentlatitude: 12.985980400000001, currentlongitude: 77.736222299999994, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324042876.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O84kDQ3c0HUCY0KzB), key: "-L0O84kDQ3c0HUCY0KzB")
     GGgroceryItem
     DriverData(currentlatitude: 12.986161666666666, currentlongitude: 77.73686166666667, currentAddress: "Discoverer, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324050133.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O86Ur4I1d7DVFJP-7), key: "-L0O86Ur4I1d7DVFJP-7")
     GGgroceryItem
     DriverData(currentlatitude: 12.9859829, currentlongitude: 77.736234400000001, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324103912.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O8JWcHfXNpjWvcP4m), key: "-L0O8JWcHfXNpjWvcP4m")
     GGgroceryItem
     DriverData(currentlatitude: 12.986210000000002, currentlongitude: 77.737043333333332, currentAddress: "Discoverer, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324140210.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O8SX7WBCOiXzvNYJD), key: "-L0O8SX7WBCOiXzvNYJD")
     GGgroceryItem
     DriverData(currentlatitude: 12.9860541, currentlongitude: 77.736214399999994, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324226381.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O8mQEqQJI3GN_qqjl), key: "-L0O8mQEqQJI3GN_qqjl")
     GGgroceryItem
     DriverData(currentlatitude: 12.987201666666666, currentlongitude: 77.738551666666666, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324240200.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O8pzjC_TB0pfn-YAW), key: "-L0O8pzjC_TB0pfn-YAW")
     GGgroceryItem
     DriverData(currentlatitude: 12.9859686, currentlongitude: 77.736200199999999, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324306735.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O958P5AXJk4Lfg6jj), key: "-L0O958P5AXJk4Lfg6jj")
     GGgroceryItem
     DriverData(currentlatitude: 12.987821666666665, currentlongitude: 77.737308333333345, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324314196.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O970ASGr2ai_SWsld), key: "-L0O970ASGr2ai_SWsld")
     GGgroceryItem
     DriverData(currentlatitude: 12.985978299999999, currentlongitude: 77.7362313, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324369621.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O9KO_OomdWDhwaTGQ), key: "-L0O9KO_OomdWDhwaTGQ")
     GGgroceryItem
     DriverData(currentlatitude: 12.987153333333334, currentlongitude: 77.73853166666666, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324394975.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O9Qq2STI2rodpRxvF), key: "-L0O9Qq2STI2rodpRxvF")
     GGgroceryItem
     DriverData(currentlatitude: 12.9860177, currentlongitude: 77.736188499999997, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324430661.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O9ZQCHPZwvaZPWOs8), key: "-L0O9ZQCHPZwvaZPWOs8")
     GGgroceryItem
     DriverData(currentlatitude: 12.988001666666666, currentlongitude: 77.737624999999994, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324481149.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O9kjRIw9Dz6lltYgl), key: "-L0O9kjRIw9Dz6lltYgl")
     GGgroceryItem
     DriverData(currentlatitude: 12.9859825, currentlongitude: 77.736235399999998, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324495642.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0O9o9oo5Ao9lZHNA6x), key: "-L0O9o9oo5Ao9lZHNA6x")
     GGgroceryItem
     DriverData(currentlatitude: 12.985962900000001, currentlongitude: 77.736234400000001, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324561549.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OA3FgD4t4GKXtWuvo), key: "-L0OA3FgD4t4GKXtWuvo")
     GGgroceryItem
     DriverData(currentlatitude: 12.98798, currentlongitude: 77.737840000000006, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324569739.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OA5PLn9WQ7D6ac2dp), key: "-L0OA5PLn9WQ7D6ac2dp")
     GGgroceryItem
     DriverData(currentlatitude: 12.986062799999999, currentlongitude: 77.736210700000001, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324625591.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OAIt0SeZgyFGHOr5a), key: "-L0OAIt0SeZgyFGHOr5a")
     GGgroceryItem
     DriverData(currentlatitude: 12.986075, currentlongitude: 77.736183299999993, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324686804.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OAXwZOOXBvDrciTWP), key: "-L0OAXwZOOXBvDrciTWP")
     GGgroceryItem
     DriverData(currentlatitude: 12.986835000000001, currentlongitude: 77.738878333333332, currentAddress: "MLCP Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324705161.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OAbPEd3JLNnAaq8T7), key: "-L0OAbPEd3JLNnAaq8T7")
     GGgroceryItem
     DriverData(currentlatitude: 12.986041699999999, currentlongitude: 77.736182200000002, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324748639.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OAlvW_Y52sfmVY--A), key: "-L0OAlvW_Y52sfmVY--A")
     GGgroceryItem
     DriverData(currentlatitude: 12.985944999999999, currentlongitude: 77.739106666666672, currentAddress: "MLCP Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324806214.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OB-9_HHrJ8JdU6KJ5), key: "-L0OB-9_HHrJ8JdU6KJ5")
     GGgroceryItem
     DriverData(currentlatitude: 12.986046200000001, currentlongitude: 77.736204900000004, currentAddress: "40, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324819278.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OB2A8ryGQWUe2hhJt), key: "-L0OB2A8ryGQWUe2hhJt")
     GGgroceryItem
     DriverData(currentlatitude: 12.986053333333333, currentlongitude: 77.737198333333325, currentAddress: "Discoverer, ITPB Main Rd, Pattandur Agrahara, Whitefield, Bengaluru, Karnataka 560066, India\n", locationTimestamp: 1513324886488.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L0OBIkGUCQo48c5RZH1), key: "-L0OBIkGUCQo48c5RZH1")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515844792801.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jNz8W9_nVBzLLav6h), key: "-L2jNz8W9_nVBzLLav6h")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192418, currentlongitude: 76.212732799999998, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515844859212.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jOE6SdPD0xv8GHZT3), key: "-L2jOE6SdPD0xv8GHZT3")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192338, currentlongitude: 76.212722099999993, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515844921899.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jOTR3msccsFr3Uhkg), key: "-L2jOTR3msccsFr3Uhkg")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845002980.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jOmDK7N7AYpN84GUX), key: "-L2jOmDK7N7AYpN84GUX")
     GGgroceryItem
     DriverData(currentlatitude: 10.519220000000001, currentlongitude: 76.212636900000007, currentAddress: "Address could not be determined", locationTimestamp: 1515845063894.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jP1Ilfjn3JgTPn2Qj), key: "-L2jP1Ilfjn3JgTPn2Qj")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192461, currentlongitude: 76.212750400000004, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845124832.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jPF147g6O4ZhGMYAV), key: "-L2jPF147g6O4ZhGMYAV")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192453, currentlongitude: 76.212779999999995, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845186079.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jPTv92d4DVc1IvR0j), key: "-L2jPTv92d4DVc1IvR0j")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845265367.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jPmGrg2DlnvqXuwMf), key: "-L2jPmGrg2DlnvqXuwMf")
     GGgroceryItem
     DriverData(currentlatitude: 10.51934, currentlongitude: 76.212636399999994, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845326523.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jQ0GS3EQzmN0zbGDY), key: "-L2jQ0GS3EQzmN0zbGDY")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845387585.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jQF6ah7XSX9c2yEST), key: "-L2jQF6ah7XSX9c2yEST")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192231, currentlongitude: 76.212722900000003, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845447970.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jQTqxLNAITu-e-g1E), key: "-L2jQTqxLNAITu-e-g1E")
     GGgroceryItem
     DriverData(currentlatitude: 10.519215000000001, currentlongitude: 76.212741500000007, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845508212.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jQhgYzPVK8WD-x_9Y), key: "-L2jQhgYzPVK8WD-x_9Y")
     GGgroceryItem
     DriverData(currentlatitude: 10.519239600000001, currentlongitude: 76.212691899999996, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845589507.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jR0VvRRE4Kn_ILcZ3), key: "-L2jR0VvRRE4Kn_ILcZ3")
     GGgroceryItem
     DriverData(currentlatitude: 10.519296666666666, currentlongitude: 76.212468333333334, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845643830.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jRDkokZ_PT_uKu7Oe), key: "-L2jRDkokZ_PT_uKu7Oe")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192263, currentlongitude: 76.212781699999994, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845650363.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jRFGLLzV35NkvX7ZV), key: "-L2jRFGLLzV35NkvX7ZV")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845712353.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jRUPUaMH9EpIze96v), key: "-L2jRUPUaMH9EpIze96v")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845779615.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jRjqxgJ73lDKkTS3_), key: "-L2jRjqxgJ73lDKkTS3_")
     GGgroceryItem
     DriverData(currentlatitude: 10.519329999999998, currentlongitude: 76.212651666666673, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845825176.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jRv2sYVzpejYYjURu), key: "-L2jRv2sYVzpejYYjURu")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845860375.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jS2Y13HOSQ6g-_zj3), key: "-L2jS2Y13HOSQ6g-_zj3")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845922621.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jSHjgm0XUDAoGk_05), key: "-L2jSHjgm0XUDAoGk_05")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515845982854.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jSWn6K1_pHbFdvwDC), key: "-L2jSWn6K1_pHbFdvwDC")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846044558.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jSkq9bGhniZkB-8u7), key: "-L2jSkq9bGhniZkB-8u7")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846104672.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jSzX4Nfw_NHsic1e_), key: "-L2jSzX4Nfw_NHsic1e_")
     GGgroceryItem
     DriverData(currentlatitude: 10.519008333333334, currentlongitude: 76.212756666666664, currentAddress: "RCM Ln, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846127621.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jT4HwScp08aC7KjDR), key: "-L2jT4HwScp08aC7KjDR")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846164802.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jTDBssyssA6pnGOrV), key: "-L2jTDBssyssA6pnGOrV")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846225008.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jTRu92vWgo9Y-9_w7), key: "-L2jTRu92vWgo9Y-9_w7")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846285268.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jTfb9tCl21B3OMPvY), key: "-L2jTfb9tCl21B3OMPvY")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846346476.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jTuYsfHJu0rMbwQ_w), key: "-L2jTuYsfHJu0rMbwQ_w")
     GGgroceryItem
     DriverData(currentlatitude: 10.519560000000002, currentlongitude: 76.213170000000005, currentAddress: "Post Office Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846369498.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jU-ITE-uzX18RYwCF), key: "-L2jU-ITE-uzX18RYwCF")
     GGgroceryItem
     DriverData(currentlatitude: 10.519237499999999, currentlongitude: 76.212741600000001, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846463456.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jUM6vUi5ytVAiEgui), key: "-L2jUM6vUi5ytVAiEgui")
     GGgroceryItem
     DriverData(currentlatitude: 10.519196666666668, currentlongitude: 76.212991666666667, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846485504.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jURa0jlJ-iJhYnyUq), key: "-L2jURa0jlJ-iJhYnyUq")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846524346.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jU_yeaWADVRrzL69S), key: "-L2jU_yeaWADVRrzL69S")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846584342.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jUocFXt4X1J0iRUUa), key: "-L2jUocFXt4X1J0iRUUa")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846644487.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jV2IzNHmzjhAVJbfz), key: "-L2jV2IzNHmzjhAVJbfz")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846707682.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jVHjoahG_yl8UpOBl), key: "-L2jVHjoahG_yl8UpOBl")
     GGgroceryItem
     DriverData(currentlatitude: 10.519005, currentlongitude: 76.212471666666673, currentAddress: "House Of Trust Building, Post Office Rd, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846729007.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jVN8dW6sLtT-DafUb), key: "-L2jVN8dW6sLtT-DafUb")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192406, currentlongitude: 76.212697899999995, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846791751.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jVbGP2UAhiC8Z8FTm), key: "-L2jVbGP2UAhiC8Z8FTm")
     GGgroceryItem
     DriverData(currentlatitude: 10.518988333333334, currentlongitude: 76.212421666666657, currentAddress: "Post Office Rd, Marar Road Area, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846802002.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jVdprkumuBkMDNVvS), key: "-L2jVdprkumuBkMDNVvS")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846851784.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jVpw06It9nWyDC91_), key: "-L2jVpw06It9nWyDC91_")
     GGgroceryItem
     DriverData(currentlatitude: 10.519341666666666, currentlongitude: 76.212326666666669, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846906313.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jW2IqZJK8cuWSgZf2), key: "-L2jW2IqZJK8cuWSgZf2")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192519, currentlongitude: 76.212725000000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846918638.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jW5ExTy5oUmw22NGR), key: "-L2jW5ExTy5oUmw22NGR")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192195, currentlongitude: 76.212684999999993, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846986530.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jWLq3jZhwS9sK-5kn), key: "-L2jWLq3jZhwS9sK-5kn")
     GGgroceryItem
     DriverData(currentlatitude: 10.519155000000001, currentlongitude: 76.212456666666668, currentAddress: "Post Office Rd, Marar Road Area, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515846992036.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jWNF0gnqe_koPm9Ho), key: "-L2jWNF0gnqe_koPm9Ho")
     GGgroceryItem
     DriverData(currentlatitude: 10.519251300000001, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847068545.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jWepzxoVpaGbTynX2), key: "-L2jWepzxoVpaGbTynX2")
     GGgroceryItem
     DriverData(currentlatitude: 10.519188333333334, currentlongitude: 76.212583333333342, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847077002.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jWh2DS8GKiQgC6395), key: "-L2jWh2DS8GKiQgC6395")
     GGgroceryItem
     DriverData(currentlatitude: 10.519224700000001, currentlongitude: 76.212669000000005, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847130457.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jWtxVHVThQ0zr2aC2), key: "-L2jWtxVHVThQ0zr2aC2")
     GGgroceryItem
     DriverData(currentlatitude: 10.519111666666667, currentlongitude: 76.213093333333333, currentAddress: "RCM Ln, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847153362.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jWzcOzyddbzuAYgU5), key: "-L2jWzcOzyddbzuAYgU5")
     GGgroceryItem
     DriverData(currentlatitude: 10.519125000000001, currentlongitude: 76.212511666666657, currentAddress: "Post Office Rd, Marar Road Area, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847231411.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jXHepDdIg-lxko1gP), key: "-L2jXHepDdIg-lxko1gP")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192421, currentlongitude: 76.212719399999997, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847255344.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jXNRb6mcHHLF5VXO8), key: "-L2jXNRb6mcHHLF5VXO8")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847364622.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jXn7VBk8TBPQtTzCW), key: "-L2jXn7VBk8TBPQtTzCW")
     GGgroceryItem
     DriverData(currentlatitude: 10.519541666666665, currentlongitude: 76.212336666666673, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847376460.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jXq5XsObBMku_QsIv), key: "-L2jXq5XsObBMku_QsIv")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192382, currentlongitude: 76.212643400000005, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847425460.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jY121QJkLSfkeeWD6), key: "-L2jY121QJkLSfkeeWD6")
     GGgroceryItem
     DriverData(currentlatitude: 10.519533333333333, currentlongitude: 76.21268666666667, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847466090.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jYB-fENkFgyHWyhBl), key: "-L2jYB-fENkFgyHWyhBl")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847485617.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jYFer3UIHL0RRb3Px), key: "-L2jYFer3UIHL0RRb3Px")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192312, currentlongitude: 76.212659400000007, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847545988.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jYUP1eoEUVBHoGvps), key: "-L2jYUP1eoEUVBHoGvps")
     GGgroceryItem
     DriverData(currentlatitude: 10.519775000000001, currentlongitude: 76.212465000000009, currentAddress: "3, Kodungallur - Shornur Rd, Kuruppam, Thekkinkadu Maidan, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847569464.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jY_J_ablya7jezUK9), key: "-L2jY_J_ablya7jezUK9")
     GGgroceryItem
     DriverData(currentlatitude: 10.519242, currentlongitude: 76.212719000000007, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847610606.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jYjAZ8xa5LYxh-8NQ), key: "-L2jYjAZ8xa5LYxh-8NQ")
     GGgroceryItem
     DriverData(currentlatitude: 10.519304099999999, currentlongitude: 76.212617300000005, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847674498.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jYylz4aicmZqfedcm), key: "-L2jYylz4aicmZqfedcm")
     GGgroceryItem
     DriverData(currentlatitude: 10.519641666666667, currentlongitude: 76.21253333333334, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847695223.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jZ2uIYTJrYcukJeY0), key: "-L2jZ2uIYTJrYcukJeY0")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192557, currentlongitude: 76.212695800000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847741651.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jZEAbggsrbx800a8k), key: "-L2jZEAbggsrbx800a8k")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192473, currentlongitude: 76.212738400000006, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847801496.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jZSmcPWj7xRNs_BWj), key: "-L2jZSmcPWj7xRNs_BWj")
     GGgroceryItem
     DriverData(currentlatitude: 10.519528333333335, currentlongitude: 76.212833333333336, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847815971.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jZWQjLQmqxI_vKf04), key: "-L2jZWQjLQmqxI_vKf04")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192236, currentlongitude: 76.212669500000004, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847862371.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jZgdS54-gq8li0IDi), key: "-L2jZgdS54-gq8li0IDi")
     GGgroceryItem
     DriverData(currentlatitude: 10.519258333333335, currentlongitude: 76.212885, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847928968.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jZx4kxwy37zirRKYb), key: "-L2jZx4kxwy37zirRKYb")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192677, currentlongitude: 76.212675099999998, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515847941495.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_-Bt2W3EkqOOKh8C), key: "-L2j_-Bt2W3EkqOOKh8C")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192266, currentlongitude: 76.212642299999999, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848002149.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_DsodoiWvmknsOEt), key: "-L2j_DsodoiWvmknsOEt")
     GGgroceryItem
     DriverData(currentlatitude: 10.519376666666668, currentlongitude: 76.212818333333345, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848011647.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_GGtn1qEoetnFYFv), key: "-L2j_GGtn1qEoetnFYFv")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192333, currentlongitude: 76.212702800000002, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848063099.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_SlRNEqAO5Ht-On-), key: "-L2j_SlRNEqAO5Ht-On-")
     GGgroceryItem
     DriverData(currentlatitude: 10.519536666666665, currentlongitude: 76.213328333333322, currentAddress: "Post Office Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848121231.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_g1xqQ_O-3LBHKqi), key: "-L2j_g1xqQ_O-3LBHKqi")
     GGgroceryItem
     DriverData(currentlatitude: 10.519254399999999, currentlongitude: 76.212699200000003, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848124551.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_glDXrUeabHQlb-5), key: "-L2j_glDXrUeabHQlb-5")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192248, currentlongitude: 76.212728499999997, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848191481.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_x6L4q_Owy7Rz3XZ), key: "-L2j_x6L4q_Owy7Rz3XZ")
     GGgroceryItem
     DriverData(currentlatitude: 10.519506666666667, currentlongitude: 76.213131666666669, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848196559.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2j_yQ7eevO4qc41Z0z), key: "-L2j_yQ7eevO4qc41Z0z")
     GGgroceryItem
     DriverData(currentlatitude: 10.5191882, currentlongitude: 76.212707600000002, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848270920.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jaFZ8k8TToP2HNy67), key: "-L2jaFZ8k8TToP2HNy67")
     GGgroceryItem
     DriverData(currentlatitude: 10.519203333333333, currentlongitude: 76.212795, currentAddress: "Bejays Complex, RCM Ln, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848291426.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jaKZ_AyIDxiDfyr3f), key: "-L2jaKZ_AyIDxiDfyr3f")
     GGgroceryItem
     DriverData(currentlatitude: 10.519045000000002, currentlongitude: 76.212573333333324, currentAddress: "IPH Tower, Post Office Rd, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848377520.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jaefFXrr50q-r3Mnz), key: "-L2jaefFXrr50q-r3Mnz")
     GGgroceryItem
     DriverData(currentlatitude: 10.5193292, currentlongitude: 76.212635599999999, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848391548.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jahzBw1kJgVa6IkHf), key: "-L2jahzBw1kJgVa6IkHf")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192423, currentlongitude: 76.212733299999996, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848452333.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jawnToxf9PS-vis5B), key: "-L2jawnToxf9PS-vis5B")
     GGgroceryItem
     DriverData(currentlatitude: 10.518933333333333, currentlongitude: 76.212845000000002, currentAddress: "RCM Ln, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848486145.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jb4FmUCeVEdepOvKP), key: "-L2jb4FmUCeVEdepOvKP")
     GGgroceryItem
     DriverData(currentlatitude: 10.519254999999999, currentlongitude: 76.212796299999994, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848562076.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jbMiH42bfLD-AoO_D), key: "-L2jbMiH42bfLD-AoO_D")
     GGgroceryItem
     DriverData(currentlatitude: 10.519293333333334, currentlongitude: 76.212598333333332, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848570189.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jbOgpAdnLbrhKZrUo), key: "-L2jbOgpAdnLbrhKZrUo")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192222, currentlongitude: 76.212761999999998, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848623208.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jbaZSrBreSCbV0hxV), key: "-L2jbaZSrBreSCbV0hxV")
     GGgroceryItem
     DriverData(currentlatitude: 10.519058333333332, currentlongitude: 76.212463333333332, currentAddress: "Post Office Rd, Marar Road Area, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848650407.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jbhJ7IrcDPku76yd2), key: "-L2jbhJ7IrcDPku76yd2")
     GGgroceryItem
     DriverData(currentlatitude: 10.519251499999999, currentlongitude: 76.212722499999998, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848684208.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jbpQV94NPAk77QVoZ), key: "-L2jbpQV94NPAk77QVoZ")
     GGgroceryItem
     DriverData(currentlatitude: 10.519138333333334, currentlongitude: 76.212699999999998, currentAddress: "Post Office Rd, Marar Road Area, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848727308.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jc-3Pi0yZIzeWtqOr), key: "-L2jc-3Pi0yZIzeWtqOr")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192833, currentlongitude: 76.212641199999993, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848745275.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jc3RNur3GmL1EgBDe), key: "-L2jc3RNur3GmL1EgBDe")
     GGgroceryItem
     DriverData(currentlatitude: 10.519149999999998, currentlongitude: 76.21271333333334, currentAddress: "Post Office Rd, Marar Road Area, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848796102.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jcFj7htgSIF1vSMeg), key: "-L2jcFj7htgSIF1vSMeg")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192347, currentlongitude: 76.212694499999998, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848810297.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jcJArZA06QeK8MPYt), key: "-L2jcJArZA06QeK8MPYt")
     GGgroceryItem
     DriverData(currentlatitude: 10.5192543, currentlongitude: 76.212697899999995, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848872413.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jcYFmthjM3-PtZKU8), key: "-L2jcYFmthjM3-PtZKU8")
     GGgroceryItem
     DriverData(currentlatitude: 10.51976, currentlongitude: 76.213056666666674, currentAddress: "Jomson Towers, Azheekodan Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848881422.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jc_Xo9skzolkTncQD), key: "-L2jc_Xo9skzolkTncQD")
     GGgroceryItem
     DriverData(currentlatitude: 10.5195376, currentlongitude: 76.213262, currentAddress: "Post Office Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848933315.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jcmDYseOpAd2hoqbp), key: "-L2jcmDYseOpAd2hoqbp")
     GGgroceryItem
     DriverData(currentlatitude: 10.519485000000001, currentlongitude: 76.213693333333339, currentAddress: "Post Office Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515848980510.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jcxllCNcYRQEvOXyf), key: "-L2jcxllCNcYRQEvOXyf")
     GGgroceryItem
     DriverData(currentlatitude: 10.519691399999999, currentlongitude: 76.213556499999996, currentAddress: "Post Office Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515849055541.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jdF0rKLaAWS1mwC_7), key: "-L2jdF0rKLaAWS1mwC_7")
     GGgroceryItem
     DriverData(currentlatitude: 10.519598333333333, currentlongitude: 76.213508333333323, currentAddress: "Post Office Rd, Kuruppam, Veliyannur, Thrissur, Kerala 680001, India\n", locationTimestamp: 1515849057933.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L2jdFbpwc6xcp6kWvtb), key: "-L2jdFbpwc6xcp6kWvtb")
     GGgroceryItem
     DriverData(currentlatitude: 13.027461666666666, currentlongitude: 77.76338166666666, currentAddress: "Ardendale, Kannamangala, Bengaluru, Karnataka 560067, India\n", locationTimestamp: 1518289876809.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507EYBsK6WR3NUi-S6), key: "-L507EYBsK6WR3NUi-S6")
     GGgroceryItem
     DriverData(currentlatitude: 13.0288501, currentlongitude: 77.766460499999994, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518289881893.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507FLft-4dPLyP5eID), key: "-L507FLft-4dPLyP5eID")
     GGgroceryItem
     DriverData(currentlatitude: 13.028868599999999, currentlongitude: 77.766424700000002, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518289943368.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507UMT1rludvuidW2h), key: "-L507UMT1rludvuidW2h")
     GGgroceryItem
     DriverData(currentlatitude: 13.02853, currentlongitude: 77.765923333333333, currentAddress: "Value and Budget Housing Corporation Pvt Ltd, 136/2, Kannamangala Main Rd, Ardendale, Kannamangala, Bengaluru, Karnataka 560067, India\n", locationTimestamp: 1518290001840.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507hopUQvSO5KTy38o), key: "-L507hopUQvSO5KTy38o")
     GGgroceryItem
     DriverData(currentlatitude: 13.0288681, currentlongitude: 77.766429400000007, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290003935.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507i99bZ3zSHE-mHVH), key: "-L507i99bZ3zSHE-mHVH")
     GGgroceryItem
     DriverData(currentlatitude: 13.0288773, currentlongitude: 77.766415300000006, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290065061.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507x3rZ8TmfRSk3QHb), key: "-L507x3rZ8TmfRSk3QHb")
     GGgroceryItem
     DriverData(currentlatitude: 13.028751666666668, currentlongitude: 77.766226666666668, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290073593.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L507zCz_Emd5zjGXnXW), key: "-L507zCz_Emd5zjGXnXW")
     GGgroceryItem
     DriverData(currentlatitude: 13.0288769, currentlongitude: 77.766416399999997, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290126086.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L508Ayj05zWx9pze-O4), key: "-L508Ayj05zWx9pze-O4")
     GGgroceryItem
     DriverData(currentlatitude: 13.028629999999998, currentlongitude: 77.766086666666666, currentAddress: "Value and Budget Housing Corporation Pvt Ltd, 136/2, Kannamangala Main Rd, Ardendale, Kannamangala, Bengaluru, Karnataka 560067, India\n", locationTimestamp: 1518290161310.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L508Jc9yWkBO88SxUpP), key: "-L508Jc9yWkBO88SxUpP")
     GGgroceryItem
     DriverData(currentlatitude: 13.028848200000001, currentlongitude: 77.766461800000002, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290485160.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L509Z-TNFnluN8pPACU), key: "-L509Z-TNFnluN8pPACU")
     GGgroceryItem
     DriverData(currentlatitude: 13.0288416, currentlongitude: 77.766480999999999, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290545452.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L509mTrA-eFrJz3SIb0), key: "-L509mTrA-eFrJz3SIb0")
     GGgroceryItem
     DriverData(currentlatitude: 13.028841699999999, currentlongitude: 77.766480999999999, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290587034.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L509wcVhNF0Lrg-IFoU), key: "-L509wcVhNF0Lrg-IFoU")
     GGgroceryItem
     DriverData(currentlatitude: 13.029011666666667, currentlongitude: 77.766064999999998, currentAddress: "Mighty Marwel, Mighty Marwel, 560067, Shani Mahatma Temple Rd, Ardendale, Krishnarajapura, Kannamangala, Karnataka 560067, India\n", locationTimestamp: 1518290588240.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L509x0frgZJZca8fw3Z), key: "-L509x0frgZJZca8fw3Z")
     GGgroceryItem
     DriverData(currentlatitude: 12.925663333333334, currentlongitude: 77.677289999999999, currentAddress: "Syeds Plaza, Adarsh Palm Retreat, Bellandur, Bengaluru, Karnataka 560103, India\n", locationTimestamp: 1518325154653.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L52DoKIupM4TpnwuIWP), key: "-L52DoKIupM4TpnwuIWP")
     GGgroceryItem
     DriverData(currentlatitude: 12.925776600000001, currentlongitude: 77.675938900000006, currentAddress: "72/1, Outer Ring Rd, Adarsh Palm Retreat, Bellandur, Bengaluru, Karnataka 560103, India\n", locationTimestamp: 1518325158973.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L52Dp6zFdLMveDB_icD), key: "-L52Dp6zFdLMveDB_icD")
     GGgroceryItem
     DriverData(currentlatitude: 12.9257551, currentlongitude: 77.6760302, currentAddress: "72/1, Outer Ring Rd, Adarsh Palm Retreat, Bellandur, Bengaluru, Karnataka 560103, India\n", locationTimestamp: 1518325219751.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L52E2y8OGDpp4HOaowi), key: "-L52E2y8OGDpp4HOaowi")
     GGgroceryItem
     DriverData(currentlatitude: 12.92592, currentlongitude: 77.675829999999991, currentAddress: "Service Rd, HSR Layout, Bengaluru, Karnataka 560103, India\n", locationTimestamp: 1518325228010.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L52E5-YgYbN-cZB6Vul), key: "-L52E5-YgYbN-cZB6Vul")
     GGgroceryItem
     DriverData(currentlatitude: 12.9257437, currentlongitude: 77.676051999999999, currentAddress: "72/1, Outer Ring Rd, Adarsh Palm Retreat, Bellandur, Bengaluru, Karnataka 560103, India\n", locationTimestamp: 1518325280272.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L52EHfcW7IaIjqx9spH), key: "-L52EHfcW7IaIjqx9spH")
     GGgroceryItem
     DriverData(currentlatitude: 12.925623333333332, currentlongitude: 77.676413333333329, currentAddress: "Bellandur Gate Road, Adarsh Palm Retreat, Bellandur, Bengaluru, Karnataka 560103, India\n", locationTimestamp: 1518325324391.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L52ESWgEw9UMe2AwH7p), key: "-L52ESWgEw9UMe2AwH7p")
     GGgroceryItem
     DriverData(currentlatitude: 10.5614208, currentlongitude: 76.168145199999998, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518620832119.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JqjAGz836amwUuhL5), key: "-L5JqjAGz836amwUuhL5")
     GGgroceryItem
     DriverData(currentlatitude: 10.561503333333333, currentlongitude: 76.168298333333325, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518620837968.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JqkmuoO5MtLpVtm5n), key: "-L5JqkmuoO5MtLpVtm5n")
     GGgroceryItem
     DriverData(currentlatitude: 10.561509999999998, currentlongitude: 76.168211666666664, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518620900063.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jqzwje18NOCrVpXdo), key: "-L5Jqzwje18NOCrVpXdo")
     GGgroceryItem
     DriverData(currentlatitude: 10.561480599999999, currentlongitude: 76.1681399, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518620922039.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jr4Ll2XSBTvO917DK), key: "-L5Jr4Ll2XSBTvO917DK")
     GGgroceryItem
     DriverData(currentlatitude: 10.561480400000001, currentlongitude: 76.168145999999993, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518620984482.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JrJUMJLatNAuUDMJS), key: "-L5JrJUMJLatNAuUDMJS")
     GGgroceryItem
     DriverData(currentlatitude: 10.561543333333335, currentlongitude: 76.168278333333333, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518620985963.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JrJv0YwRO45vRCCob), key: "-L5JrJv0YwRO45vRCCob")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615085, currentlongitude: 76.168147099999999, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621047030.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JrYp09fcmuu9gLTo5), key: "-L5JrYp09fcmuu9gLTo5")
     GGgroceryItem
     DriverData(currentlatitude: 10.561496666666669, currentlongitude: 76.168301666666665, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621048987.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JrZESWra4AZC3ovym), key: "-L5JrZESWra4AZC3ovym")
     GGgroceryItem
     DriverData(currentlatitude: 10.5614208, currentlongitude: 76.168145199999998, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621110106.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jrn9gjX6AtewuVyaq), key: "-L5Jrn9gjX6AtewuVyaq")
     GGgroceryItem
     DriverData(currentlatitude: 10.561571666666669, currentlongitude: 76.168351666666666, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621112964.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JrnvAgqoEvgGsbugE), key: "-L5JrnvAgqoEvgGsbugE")
     GGgroceryItem
     DriverData(currentlatitude: 10.561598333333333, currentlongitude: 76.168213333333341, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621179525.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Js3AUqpUsqiX7kPl2), key: "-L5Js3AUqpUsqiX7kPl2")
     GGgroceryItem
     DriverData(currentlatitude: 10.561480899999999, currentlongitude: 76.168138099999993, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621193853.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Js6atHq-uzVYEHeAj), key: "-L5Js6atHq-uzVYEHeAj")
     GGgroceryItem
     DriverData(currentlatitude: 10.561479500000001, currentlongitude: 76.168142399999994, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621256367.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JsLrdsFXdPPBOpVh-), key: "-L5JsLrdsFXdPPBOpVh-")
     GGgroceryItem
     DriverData(currentlatitude: 10.561655, currentlongitude: 76.168385000000001, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621258948.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JsMZhvddJpD8CSqC1), key: "-L5JsMZhvddJpD8CSqC1")
     GGgroceryItem
     DriverData(currentlatitude: 10.561443300000001, currentlongitude: 76.168177999999997, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621317225.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Js_iRIrAeiipZ8X3e), key: "-L5Js_iRIrAeiipZ8X3e")
     GGgroceryItem
     DriverData(currentlatitude: 10.561489999999999, currentlongitude: 76.168300000000002, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621364381.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JslJDh0weIAzQ8qPK), key: "-L5JslJDh0weIAzQ8qPK")
     GGgroceryItem
     DriverData(currentlatitude: 10.561518, currentlongitude: 76.168141399999996, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621379473.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jsov99ZzWs_ghzFAI), key: "-L5Jsov99ZzWs_ghzFAI")
     GGgroceryItem
     DriverData(currentlatitude: 10.561704199999999, currentlongitude: 76.168148799999997, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621441105.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jt34H5smdG8yl4jHa), key: "-L5Jt34H5smdG8yl4jHa")
     GGgroceryItem
     DriverData(currentlatitude: 10.561576666666667, currentlongitude: 76.168328333333335, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621447577.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jt4YXvnRa3E33yrLy), key: "-L5Jt4YXvnRa3E33yrLy")
     GGgroceryItem
     DriverData(currentlatitude: 10.561350000000001, currentlongitude: 76.168400000000005, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621511953.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JtKKtn841l_00C4t0), key: "-L5JtKKtn841l_00C4t0")
     GGgroceryItem
     DriverData(currentlatitude: 10.5614659, currentlongitude: 76.168126900000004, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621525938.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JtNfeyq17rCXJlBHo), key: "-L5JtNfeyq17rCXJlBHo")
     GGgroceryItem
     DriverData(currentlatitude: 10.5617182, currentlongitude: 76.168172499999997, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621587452.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jtb_MXWXP662Xim60), key: "-L5Jtb_MXWXP662Xim60")
     GGgroceryItem
     DriverData(currentlatitude: 10.561534999999999, currentlongitude: 76.168343333333326, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621596263.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jtdn_40CRYYdvxjYd), key: "-L5Jtdn_40CRYYdvxjYd")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615346, currentlongitude: 76.168122499999996, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621703261.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Ju2wbK5rTfRZiyBRk), key: "-L5Ju2wbK5rTfRZiyBRk")
     GGgroceryItem
     DriverData(currentlatitude: 10.561755000000002, currentlongitude: 76.167898333333341, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621706076.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Ju3agF74gYKm-SunY), key: "-L5Ju3agF74gYKm-SunY")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615296, currentlongitude: 76.168099900000001, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621784290.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JuMdIAwVReKVOwDxm), key: "-L5JuMdIAwVReKVOwDxm")
     GGgroceryItem
     DriverData(currentlatitude: 10.56152, currentlongitude: 76.168253333333325, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621784355.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JuMiPioY_pS5TI2VM), key: "-L5JuMiPioY_pS5TI2VM")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615089, currentlongitude: 76.168128100000004, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621845448.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Juacq2Zmm8CeFj-jT), key: "-L5Juacq2Zmm8CeFj-jT")
     GGgroceryItem
     DriverData(currentlatitude: 10.561464999999998, currentlongitude: 76.16837000000001, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621846291.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JuapaJsTe-d8G1Wrd), key: "-L5JuapaJsTe-d8G1Wrd")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615323, currentlongitude: 76.1681332, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621907315.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JupfPZBx6H3XknlFg), key: "-L5JupfPZBx6H3XknlFg")
     GGgroceryItem
     DriverData(currentlatitude: 10.561548333333333, currentlongitude: 76.168295000000001, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621908315.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jupv7LEfJW9eW0Pm3), key: "-L5Jupv7LEfJW9eW0Pm3")
     GGgroceryItem
     DriverData(currentlatitude: 10.5614208, currentlongitude: 76.168145199999998, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621969383.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jv3oxKTCzmu4Sdv4J), key: "-L5Jv3oxKTCzmu4Sdv4J")
     GGgroceryItem
     DriverData(currentlatitude: 10.561526666666669, currentlongitude: 76.168241666666674, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518621970374.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jv44B_V-OZIuZx1sJ), key: "-L5Jv44B_V-OZIuZx1sJ")
     GGgroceryItem
     DriverData(currentlatitude: 10.5616036, currentlongitude: 76.168117199999998, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622042638.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JvLmicjGi1FYI8ked), key: "-L5JvLmicjGi1FYI8ked")
     GGgroceryItem
     DriverData(currentlatitude: 10.5614892, currentlongitude: 76.168143299999997, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622103826.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jv_dlYdF39g2X_Jz4), key: "-L5Jv_dlYdF39g2X_Jz4")
     GGgroceryItem
     DriverData(currentlatitude: 10.561488333333333, currentlongitude: 76.168171666666666, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622106343.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JvaG3ARbdnpS57xdd), key: "-L5JvaG3ARbdnpS57xdd")
     GGgroceryItem
     DriverData(currentlatitude: 10.561494100000001, currentlongitude: 76.168136399999995, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622167364.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jvp9U1AurDxsclEqB), key: "-L5Jvp9U1AurDxsclEqB")
     GGgroceryItem
     DriverData(currentlatitude: 10.561528333333335, currentlongitude: 76.168124999999989, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622168308.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JvpOQW3nab_p7iC2I), key: "-L5JvpOQW3nab_p7iC2I")
     GGgroceryItem
     DriverData(currentlatitude: 10.561417, currentlongitude: 76.168130899999994, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622229291.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jw3OcJNg5PbQImx6S), key: "-L5Jw3OcJNg5PbQImx6S")
     GGgroceryItem
     DriverData(currentlatitude: 10.561516666666668, currentlongitude: 76.168281666666658, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622230529.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jw3_oDYRqeXWUgv-p), key: "-L5Jw3_oDYRqeXWUgv-p")
     GGgroceryItem
     DriverData(currentlatitude: 10.561591666666667, currentlongitude: 76.168318333333346, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622293859.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JwJH4QhMVJL4itCpC), key: "-L5JwJH4QhMVJL4itCpC")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615243, currentlongitude: 76.168120599999995, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622321028.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JwPprMd91ahoR3IX3), key: "-L5JwPprMd91ahoR3IX3")
     GGgroceryItem
     DriverData(currentlatitude: 10.561473299999999, currentlongitude: 76.168134499999994, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622404166.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jwj7o4cQUTTOGmUVE), key: "-L5Jwj7o4cQUTTOGmUVE")
     GGgroceryItem
     DriverData(currentlatitude: 10.561475, currentlongitude: 76.168256666666665, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622406553.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JwjnpCQ3RTmoRzBib), key: "-L5JwjnpCQ3RTmoRzBib")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615022, currentlongitude: 76.168134800000004, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622469091.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JwyzODUFol_V45lKq), key: "-L5JwyzODUFol_V45lKq")
     GGgroceryItem
     DriverData(currentlatitude: 10.561468333333334, currentlongitude: 76.168156666666661, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622473093.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JwzyNP-aGmuzeR3wn), key: "-L5JwzyNP-aGmuzeR3wn")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615177, currentlongitude: 76.168122600000004, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622534281.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JxDtpwiyJeeb4ajbQ), key: "-L5JxDtpwiyJeeb4ajbQ")
     GGgroceryItem
     DriverData(currentlatitude: 10.561488333333333, currentlongitude: 76.168381666666662, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622537195.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JxEbjAIKHFV8DhupG), key: "-L5JxEbjAIKHFV8DhupG")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615641, currentlongitude: 76.168037299999995, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622599132.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JxTnxCtd-kAFGji_w), key: "-L5JxTnxCtd-kAFGji_w")
     GGgroceryItem
     DriverData(currentlatitude: 10.561646666666665, currentlongitude: 76.168239999999997, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622600375.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JxU68pJNv2yGZ9-Z9), key: "-L5JxU68pJNv2yGZ9-Z9")
     GGgroceryItem
     DriverData(currentlatitude: 10.561586699999999, currentlongitude: 76.168119700000005, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622707130.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jxt5de0TMhODvZYcr), key: "-L5Jxt5de0TMhODvZYcr")
     GGgroceryItem
     DriverData(currentlatitude: 10.561553333333332, currentlongitude: 76.168256666666665, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622709961.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JxtswDWsjEbNgVkkz), key: "-L5JxtswDWsjEbNgVkkz")
     GGgroceryItem
     DriverData(currentlatitude: 10.561544, currentlongitude: 76.168116699999999, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622773163.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jy8DMELEnkTr9naPx), key: "-L5Jy8DMELEnkTr9naPx")
     GGgroceryItem
     DriverData(currentlatitude: 10.561539999999999, currentlongitude: 76.168261666666666, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622779592.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jy9msZSxRDcDu2AnX), key: "-L5Jy9msZSxRDcDu2AnX")
     GGgroceryItem
     DriverData(currentlatitude: 10.561698, currentlongitude: 76.168102899999994, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622840667.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JyOn4OAtoxz4c_VRK), key: "-L5JyOn4OAtoxz4c_VRK")
     GGgroceryItem
     DriverData(currentlatitude: 10.561565, currentlongitude: 76.168328333333335, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622841603.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JyOwEif5R6IObE_3D), key: "-L5JyOwEif5R6IObE_3D")
     GGgroceryItem
     DriverData(currentlatitude: 10.561604600000001, currentlongitude: 76.168123399999999, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622905262.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JydTl9MkU-CV_63rW), key: "-L5JydTl9MkU-CV_63rW")
     GGgroceryItem
     DriverData(currentlatitude: 10.561624999999999, currentlongitude: 76.168241666666674, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622908584.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JyeHiUSQgY7GQ4yE2), key: "-L5JyeHiUSQgY7GQ4yE2")
     GGgroceryItem
     DriverData(currentlatitude: 10.561901666666666, currentlongitude: 76.167866666666669, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622984381.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JywrlIrLcniyjuUuZ), key: "-L5JywrlIrLcniyjuUuZ")
     GGgroceryItem
     DriverData(currentlatitude: 10.5615877, currentlongitude: 76.168129399999998, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518622988109.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jyxgx7RSCsPLxDWsg), key: "-L5Jyxgx7RSCsPLxDWsg")
     GGgroceryItem
     DriverData(currentlatitude: 10.561595199999999, currentlongitude: 76.168120500000001, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623050307.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JzBsfJxvQ1nWyPcsv), key: "-L5JzBsfJxvQ1nWyPcsv")
     GGgroceryItem
     DriverData(currentlatitude: 10.56179, currentlongitude: 76.168161666666677, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623051969.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JzCMbByik5j9Q4N91), key: "-L5JzCMbByik5j9Q4N91")
     GGgroceryItem
     DriverData(currentlatitude: 10.561468899999999, currentlongitude: 76.168084100000002, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623112926.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JzRFWBcwhtvfrGS0t), key: "-L5JzRFWBcwhtvfrGS0t")
     GGgroceryItem
     DriverData(currentlatitude: 10.561853333333334, currentlongitude: 76.168079999999989, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623115529.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JzRtoviWXjogb0T-e), key: "-L5JzRtoviWXjogb0T-e")
     GGgroceryItem
     DriverData(currentlatitude: 10.561533499999999, currentlongitude: 76.168137099999996, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623177083.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JzfpU1Pipk8Pd8wiC), key: "-L5JzfpU1Pipk8Pd8wiC")
     GGgroceryItem
     DriverData(currentlatitude: 10.561841666666664, currentlongitude: 76.168146666666672, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623182516.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5JzhEPtqPOws1FVgcp), key: "-L5JzhEPtqPOws1FVgcp")
     GGgroceryItem
     DriverData(currentlatitude: 10.5614702, currentlongitude: 76.1681174, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623248055.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5Jzx9oEq6xz6qI6Uar), key: "-L5Jzx9oEq6xz6qI6Uar")
     GGgroceryItem
     DriverData(currentlatitude: 10.561533300000001, currentlongitude: 76.168139300000007, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623313000.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-C0SPhyDtwKfBo5Q), key: "-L5K-C0SPhyDtwKfBo5Q")
     GGgroceryItem
     DriverData(currentlatitude: 10.561881666666666, currentlongitude: 76.168173333333328, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623314989.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-CaDo2uaGrFP4utq), key: "-L5K-CaDo2uaGrFP4utq")
     GGgroceryItem
     DriverData(currentlatitude: 10.561674099999999, currentlongitude: 76.168106699999996, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623376005.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-RWPPP2s6pzDFvYw), key: "-L5K-RWPPP2s6pzDFvYw")
     GGgroceryItem
     DriverData(currentlatitude: 10.561980000000002, currentlongitude: 76.168228333333346, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623383557.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-TJhIxetRBMOSbd0), key: "-L5K-TJhIxetRBMOSbd0")
     GGgroceryItem
     DriverData(currentlatitude: 10.5616749, currentlongitude: 76.168075599999995, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623438474.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-fPMAfSt_gwa76HD), key: "-L5K-fPMAfSt_gwa76HD")
     GGgroceryItem
     DriverData(currentlatitude: 10.56212, currentlongitude: 76.16867666666667, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623447204.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-hX8LrxHS59YHZo_), key: "-L5K-hX8LrxHS59YHZo_")
     GGgroceryItem
     DriverData(currentlatitude: 10.5618719, currentlongitude: 76.169244500000005, currentAddress: "Pura Trading Complex, Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623503079.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K-vCX4aQ2co-2FKO1), key: "-L5K-vCX4aQ2co-2FKO1")
     GGgroceryItem
     DriverData(currentlatitude: 10.562116666666668, currentlongitude: 76.168418333333335, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623521862.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K0-0G9HWOjA3HnLQV), key: "-L5K0-0G9HWOjA3HnLQV")
     GGgroceryItem
     DriverData(currentlatitude: 10.5621291, currentlongitude: 76.168965700000001, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623586298.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K0EXPWEnRZjbbYrCs), key: "-L5K0EXPWEnRZjbbYrCs")
     GGgroceryItem
     DriverData(currentlatitude: 10.561993333333332, currentlongitude: 76.16832500000001, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623600552.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K0I23dr0gnX8dpCI0), key: "-L5K0I23dr0gnX8dpCI0")
     GGgroceryItem
     DriverData(currentlatitude: 10.5619026, currentlongitude: 76.1681296, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623646743.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K0TMcBHFwujQhJlX0), key: "-L5K0TMcBHFwujQhJlX0")
     GGgroceryItem
     DriverData(currentlatitude: 10.561968333333335, currentlongitude: 76.168385000000001, currentAddress: "Address could not be determined", locationTimestamp: 1518623671327.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K0_PB0BIkYzJ7ktvT), key: "-L5K0_PB0BIkYzJ7ktvT")
     GGgroceryItem
     DriverData(currentlatitude: 10.563079099999999, currentlongitude: 76.167954300000005, currentAddress: "Address could not be determined", locationTimestamp: 1518623707873.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K0iK4MnMpflr8ZjQ1), key: "-L5K0iK4MnMpflr8ZjQ1")
     GGgroceryItem
     DriverData(currentlatitude: 10.562321666666666, currentlongitude: 76.167906666666667, currentAddress: "Address could not be determined", locationTimestamp: 1518623793219.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K129aWYdcE8pdMTyK), key: "-L5K129aWYdcE8pdMTyK")
     GGgroceryItem
     DriverData(currentlatitude: 10.562108200000001, currentlongitude: 76.168453400000004, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623902728.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K1Rg1OS4BjKfBDsFL), key: "-L5K1Rg1OS4BjKfBDsFL")
     GGgroceryItem
     DriverData(currentlatitude: 10.562213333333334, currentlongitude: 76.167778333333345, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623908903.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K1TgFsJ12K4tlUD8H), key: "-L5K1TgFsJ12K4tlUD8H")
     GGgroceryItem
     DriverData(currentlatitude: 10.5621291, currentlongitude: 76.168965700000001, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623962432.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K1fcY8cMec25LNjSn), key: "-L5K1fcY8cMec25LNjSn")
     GGgroceryItem
     DriverData(currentlatitude: 10.561929999999998, currentlongitude: 76.168873333333337, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518623972552.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K1iBK_zucrnR1b2nn), key: "-L5K1iBK_zucrnR1b2nn")
     GGgroceryItem
     DriverData(currentlatitude: 10.564350299999999, currentlongitude: 76.166961799999996, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680545, India\n", locationTimestamp: 1518624023493.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K1ucCjrV8IAfoQEzG), key: "-L5K1ucCjrV8IAfoQEzG")
     GGgroceryItem
     DriverData(currentlatitude: 10.562163333333334, currentlongitude: 76.168726666666672, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624063300.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K23LUkKcbG72PLads), key: "-L5K23LUkKcbG72PLads")
     GGgroceryItem
     DriverData(currentlatitude: 10.5626537, currentlongitude: 76.169005799999994, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624084497.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K28WPp-BTecspkI2z), key: "-L5K28WPp-BTecspkI2z")
     GGgroceryItem
     DriverData(currentlatitude: 10.5626537, currentlongitude: 76.169005799999994, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624146823.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K2NgqTHrylmME6ZUF), key: "-L5K2NgqTHrylmME6ZUF")
     GGgroceryItem
     DriverData(currentlatitude: 10.562341666666669, currentlongitude: 76.168914999999998, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624154581.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K2Pm5lbtP-wApW8Nl), key: "-L5K2Pm5lbtP-wApW8Nl")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624211231.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K2cY7mDx54zazwU11), key: "-L5K2cY7mDx54zazwU11")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624271554.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K2r3w9sTb4hWDEGWW), key: "-L5K2r3w9sTb4hWDEGWW")
     GGgroceryItem
     DriverData(currentlatitude: 10.562693333333334, currentlongitude: 76.169081666666671, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624277982.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K2skCdSv8UtzNq_eZ), key: "-L5K2skCdSv8UtzNq_eZ")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624332472.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K34wdfVF99t3ZXO1D), key: "-L5K34wdfVF99t3ZXO1D")
     GGgroceryItem
     DriverData(currentlatitude: 10.562723333333334, currentlongitude: 76.169111666666666, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624368633.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K3DumbEbGEab4aXSM), key: "-L5K3DumbEbGEab4aXSM")
     GGgroceryItem
     DriverData(currentlatitude: 10.5718554, currentlongitude: 76.165874900000006, currentAddress: "Peramangalam, Kerala, India\n", locationTimestamp: 1518624399380.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K3LM3YWEHgR2HQA1Q), key: "-L5K3LM3YWEHgR2HQA1Q")
     GGgroceryItem
     DriverData(currentlatitude: 10.562743333333334, currentlongitude: 76.169188333333338, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624493503.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K3hOjKwkWc_i7pmdq), key: "-L5K3hOjKwkWc_i7pmdq")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624509603.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K3lBZKM-WnBGWYRG5), key: "-L5K3lBZKM-WnBGWYRG5")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624569738.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K3zs4loukJd0eBAC1), key: "-L5K3zs4loukJd0eBAC1")
     GGgroceryItem
     DriverData(currentlatitude: 10.562780000000002, currentlongitude: 76.169126666666671, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624576294.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K40YvWnC-XrQVpQLb), key: "-L5K40YvWnC-XrQVpQLb")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624631291.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K4DtsFXwzmSVVZuZt), key: "-L5K4DtsFXwzmSVVZuZt")
     GGgroceryItem
     DriverData(currentlatitude: 10.56268, currentlongitude: 76.169069999999991, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624666426.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K4MYhlZdo4zpkMp7G), key: "-L5K4MYhlZdo4zpkMp7G")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624692319.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K4SnArIICh4--dQ1k), key: "-L5K4SnArIICh4--dQ1k")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624754561.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K4h04B3UcfhVQM5KV), key: "-L5K4h04B3UcfhVQM5KV")
     GGgroceryItem
     DriverData(currentlatitude: 10.562613333333335, currentlongitude: 76.169121666666655, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624758084.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K4i-QNyFtoonMks26), key: "-L5K4i-QNyFtoonMks26")
     GGgroceryItem
     DriverData(currentlatitude: 10.562645000000002, currentlongitude: 76.169129999999996, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624836817.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K50EMTJgZ-4Hp8PTo), key: "-L5K50EMTJgZ-4Hp8PTo")
     GGgroceryItem
     DriverData(currentlatitude: 10.5590662, currentlongitude: 76.171671700000005, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624841276.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K519il9XgqjG_PGu_), key: "-L5K519il9XgqjG_PGu_")
     GGgroceryItem
     DriverData(currentlatitude: 10.562829199999999, currentlongitude: 76.1692733, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624901499.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K5FwViuuag_MKEdGs), key: "-L5K5FwViuuag_MKEdGs")
     GGgroceryItem
     DriverData(currentlatitude: 10.562568333333335, currentlongitude: 76.169225000000012, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518624905988.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K5H1tcuXIzNPGAEir), key: "-L5K5H1tcuXIzNPGAEir")
     GGgroceryItem
     DriverData(currentlatitude: 10.567815700000001, currentlongitude: 76.167686399999994, currentAddress: "Peramangalam, Kerala, India\n", locationTimestamp: 1518624969829.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K5Wg4UhROdXU6HKuB), key: "-L5K5Wg4UhROdXU6HKuB")
     GGgroceryItem
     DriverData(currentlatitude: 10.562393333333334, currentlongitude: 76.169000000000011, currentAddress: "Address could not be determined", locationTimestamp: 1518625027505.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K5jSp84P7huOfzA-M), key: "-L5K5jSp84P7huOfzA-M")
     GGgroceryItem
     DriverData(currentlatitude: 10.562057299999999, currentlongitude: 76.168842600000005, currentAddress: "Address could not be determined", locationTimestamp: 1518625041630.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K5mu2JCo5LRmrkgop), key: "-L5K5mu2JCo5LRmrkgop")
     GGgroceryItem
     DriverData(currentlatitude: 10.5619026, currentlongitude: 76.1681296, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518625101428.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K60TzGw8YhFM2GrA4), key: "-L5K60TzGw8YhFM2GrA4")
     GGgroceryItem
     DriverData(currentlatitude: 10.561910000000001, currentlongitude: 76.168558333333337, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518625106529.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K61nkLTCMxsN0kHsG), key: "-L5K61nkLTCMxsN0kHsG")
     GGgroceryItem
     DriverData(currentlatitude: 10.561527, currentlongitude: 76.168088499999996, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518625167866.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K6GnBw8TMFJr3HcW2), key: "-L5K6GnBw8TMFJr3HcW2")
     GGgroceryItem
     DriverData(currentlatitude: 10.561590000000001, currentlongitude: 76.168558333333337, currentAddress: "Amala Hospital Rd, Amalanagar, Thrissur, Kerala 680555, India\n", locationTimestamp: 1518625174576.0, locationProvider: "gps", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K6IPzJ65SPXvfY_xR), key: "-L5K6IPzJ65SPXvfY_xR")
     GGgroceryItem
     DriverData(currentlatitude: 10.564350299999999, currentlongitude: 76.166961799999996, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680545, India\n", locationTimestamp: 1518625231761.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K6WJ1sZ3oiaWwqVDa), key: "-L5K6WJ1sZ3oiaWwqVDa")
     GGgroceryItem
     DriverData(currentlatitude: 10.564350299999999, currentlongitude: 76.166961799999996, currentAddress: "Thrissur- Kuttippuram Rd, Amalanagar, Thrissur, Kerala 680545, India\n", locationTimestamp: 1518625299285.0, locationProvider: "network", ref: Optional(https://moschooling-1479724747505.firebaseio.com/vehicleLocation/1066/61/Location/-L5K6lnC-nEGfNPcwkCd), key: "-L5K6lnC-nEGfNPcwkCd")
     GGgroceryItem
     
     
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

