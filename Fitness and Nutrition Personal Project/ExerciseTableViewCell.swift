//
//  ExerciseTableViewCell.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 12/18/22.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var exerciseView: UIView!
    @IBOutlet weak var exercisename: UILabel!
    @IBOutlet weak var muscleGroup: UILabel!
    @IBOutlet weak var exerciseType: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
