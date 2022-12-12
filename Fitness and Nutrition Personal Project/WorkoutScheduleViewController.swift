//
//  WorkoutScheduleViewController.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 12/11/22.
//

import UIKit

class WorkoutScheduleViewController: UIViewController {

    @IBOutlet weak var calendarUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "en_US")
        calendarView.fontDesign = .rounded
        calendarView.visibleDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2022, month: 6, day: 6)
        
        let fromDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2022, month: 1, day: 1)
        let toDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2022, month: 12, day: 31)

        guard let fromDate = fromDateComponents.date, let toDate = toDateComponents.date else {
            return
        }

        let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
        calendarView.availableDateRange = calendarViewDateRange
        
        calendarView.frame = calendarUIView.bounds;
    
        calendarUIView.addSubview(calendarView)

        
        // Do any additional setup after loading the view.
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