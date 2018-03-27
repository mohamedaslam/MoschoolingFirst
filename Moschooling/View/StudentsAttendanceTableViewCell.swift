//
//  StudentsAttendanceTableViewCell.swift
//  Moschooling
//
//  Created by Aslam on 3/14/18.
//  Copyright © 2018 Moschooling. All rights reserved.
//

import UIKit

class StudentsAttendanceTableViewCell: UITableViewCell {

    @IBOutlet weak var weekdayslabel: UILabel!
    @IBOutlet weak var daylabel: UILabel!
    @IBOutlet weak var AttendanceTimingCOllectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension StudentsAttendanceTableViewCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return 2
        return (section == 0) ? 2 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            //make sure the identifier of your cell for first section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentAttendanceTimeCollectionViewCell", for: indexPath) as! StudentAttendanceTimeCollectionViewCell
            
            return cell
        }else{
            //make sure the identifier of your cell for second section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentAttendanceTimeCollectionViewCell", for: indexPath) as! StudentAttendanceTimeCollectionViewCell
            
            return cell
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentAttendanceTimeCollectionViewCell", for: indexPath) as! StudentAttendanceTimeCollectionViewCell
//        
//        return cell
    }
    
}

extension StudentsAttendanceTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
