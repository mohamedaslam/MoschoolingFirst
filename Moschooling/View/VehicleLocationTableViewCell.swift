//
//  VehicleLocationTableViewCell.swift
//  MoschoollingApp
//
//  Created by Mohammed Aslam on 19/01/18.
//  Copyright © 2018 Moschoolling. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON
class VehicleLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var LongituteLabel: UILabel!
    @IBOutlet weak var latituteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
