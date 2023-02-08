//
//  WorkoutScheduleViewController.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 12/11/22.
//

import UIKit


class WorkoutScheduleViewController: UIViewController {

    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var currentDataViewed: UILabel!
    
    @IBOutlet weak var searchInput: UITextField!
    
    var currentDate: Date = Date()
    var selectedDate: Date = Date()
    var exerciseNames : NSArray?
    var exerciseTypes : NSArray?
    var muscleGroups : NSArray?
    var instructions : NSArray?
    var equipment : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        exerciseTableView.layer.cornerRadius = 10
        exerciseTableView.layer.borderWidth = 2
        exerciseTableView.layer.borderColor = UIColor.systemGray2.cgColor
        
        weekCollectionView.layer.cornerRadius = 2
        weekCollectionView.layer.borderWidth = 3
        weekCollectionView.layer.borderColor = UIColor(red: 0.498, green: 0.051, blue: 0.008, alpha: 1.0).cgColor
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDataViewed.text = formatter.string(from: selectedDate).uppercased()

        
        setWeek()
        makeRequest()
        
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        let calendar = Calendar.current
        currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        selectedDate = calendar.date(byAdding: .day, value: 7, to: selectedDate)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDataViewed.text = formatter.string(from: selectedDate).uppercased()
        
        setWeek()
    }
    
    @IBAction func previousWeek(_ sender: Any) {
        let calendar = Calendar.current
        currentDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
        selectedDate = calendar.date(byAdding: .day, value: -7, to: selectedDate)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDataViewed.text = formatter.string(from: selectedDate).uppercased()
        
        setWeek()
    }
    
    @IBAction func search(_ sender: Any) {
        makeRequest()
    }
    
    func makeRequest() {
        searchInput.resignFirstResponder()
        let url = URL(string: "https://api.api-ninjas.com/v1/exercises?muscle="+searchInput.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        var request = URLRequest(url: url)
        request.setValue("8PSR0mwN7BhdBKZJdezM6Q==C6uyDAC4yCdia9a4", forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }

            do {

                let data = try JSONSerialization.jsonObject(with: data) as! NSArray

                DispatchQueue.main.async {
                    self.exerciseNames = (data.value(forKey: "name") as! NSArray)
                    self.exerciseTypes = (data.value(forKey: "type") as! NSArray)
                    self.equipment = (data.value(forKey: "equipment") as! NSArray)
                    self.muscleGroups = (data.value(forKey: "muscle") as! NSArray)
                    self.instructions = (data.value(forKey: "instructions") as! NSArray)
                    self.exerciseTableView.reloadData()
                }

            }catch {
                print("error")
            }
        }
        task.resume()
    }
    
    
    func setWeek() {
        let calendar = Calendar.current

        let beginWeekDate = calendar.date(byAdding: .day, value: -3, to: currentDate)!

        let endWeekDate = calendar.date(byAdding: .day, value: 3, to: currentDate)!

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        monthLabel.text = formatter.string(from: beginWeekDate).uppercased() + " - " + formatter.string(from: endWeekDate).uppercased()
        
        

    }

}


extension WorkoutScheduleViewController : UITableViewDelegate, UITableViewDataSource ,  UICollectionViewDelegate, UICollectionViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseNames?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell
        
        let exerciseName = self.exerciseNames![indexPath.row]
        let exerciseType = self.exerciseTypes![indexPath.row]
        let muscleGroup = self.muscleGroups![indexPath.row]
        // let equipment = self.equipment![indexPath.row]
        // let instruction = self.instructions![indexPath.row]
        
        cell.exercisename.text = (exerciseName as! String)
        cell.exerciseType.text = (exerciseType as! String)
        cell.muscleGroup.text = (muscleGroup as! String)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeekCollectionViewCell
        
        let todaysDate = Calendar.current.date(byAdding: .day, value: indexPath.row - Calendar.current.component(.weekday, from: Date()) + 1, to: Date())!
        
        let formatter = DateFormatter()
        
        // Highlight selected day of the week. Default current date
        formatter.dateFormat = "MMM dd"
        if(formatter.string(from: todaysDate) == formatter.string(from: selectedDate)) {
            cell.backgroundColor = UIColor.lightText
        } else {
            cell.backgroundColor = UIColor.systemGray2
        }
        
        formatter.dateFormat = "EEE"
        let dayOfWeek = formatter.string(from: todaysDate)
        cell.dayLabel.text = dayOfWeek
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Client selected a day of the week to be viewed
        selectedDate = Calendar.current.date(byAdding: .day, value: indexPath.row - Calendar.current.component(.weekday, from: Date()) + 1, to: Date())!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDataViewed.text = formatter.string(from: selectedDate).uppercased()

        
        weekCollectionView.reloadData()
    }

}




