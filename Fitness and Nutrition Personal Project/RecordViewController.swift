//
//  RecordViewController.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 12/16/22.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var currentDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatDate()
    
    }
    
    
    func formatDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        let date = Date()
        currentDate.text = formatter.string(from: date).uppercased()
        currentDate.textColor = UIColor(red: 0.498, green: 0.051, blue: 0.008, alpha: 1.0)
        
        dateView.backgroundColor = .white
        dateView.layer.cornerRadius = 10
        dateView.layer.borderWidth = 5
        dateView.layer.borderColor = UIColor.black.cgColor
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
