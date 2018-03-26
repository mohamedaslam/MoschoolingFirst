//MIT License
//
//Copyright (c) 2018 Shankar BS
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//  CustomCollectionViewCell.swift
//  DemoProject
//
//  Created by Shankar B S on 17/02/18.
//  Copyright © 2018 shankar.bs. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var MarkingTimeLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    var cellImageName:String?
    class var CustomCell : CustomCollectionViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCollectionViewCell", owner: self, options: nil)?.last
        return cell as! CustomCollectionViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.red
        self.MarkingTimeLabel.layer.cornerRadius = 10
        self.MarkingTimeLabel.clipsToBounds = true

        
    }
    
    func updateCellWithImage(name:String,status:String) {
        self.cellImageName = name
        self.MarkingTimeLabel.text = name
        print(status)
        print("Statusss")
        if(status == "STUDENT_PRESENT"){
        self.MarkingTimeLabel.backgroundColor = UIColor.green
       
        self.MarkingTimeLabel.backgroundColor = UIColor(red: 117/255.0, green: 223/255.0, blue: 174/255.0, alpha: 1.0)
        }else{
        self.MarkingTimeLabel.backgroundColor = UIColor.red

        }
        
        //self.cellImageView.image = UIImage(named: name)
        self.backgroundColor = UIColor.clear
    }

}
