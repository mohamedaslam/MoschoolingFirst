//
//  AssignmentTableViewCell.swift
//  MoschoollingApp
//
//  Created by Mohammed Aslam on 15/12/17.
//  Copyright © 2017 Moschoolling. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var taskTittleLabel: UILabel!
    @IBOutlet weak var TeacherNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
