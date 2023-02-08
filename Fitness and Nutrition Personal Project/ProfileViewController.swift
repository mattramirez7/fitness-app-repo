//
//  ProfileViewController.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 10/5/22.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var userWeight: UILabel!
    @IBOutlet weak var weightTxtField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var cancelEditBtn: UIButton!
    @IBOutlet weak var saveEditsBtn: UIButton!
    @IBOutlet weak var splitCollectionView: UICollectionView!
    @IBOutlet weak var splitDayStepper: UIStepper!
    @IBOutlet weak var workoutSplitDayLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    
    var db = DBManager()
    var users:[User] = []
    var currentUser:User?
    var splitDays = 0
    var editBtnTapped:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageTxtField.delegate = self
        weightTxtField.delegate = self
        splitCollectionView.delegate = self
        splitCollectionView.dataSource = self
        
        [ageTxtField, weightTxtField, cancelEditBtn, saveEditsBtn, splitDayStepper].forEach { $0.isHidden = true }
        
        
        loadProfile()
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()

        if let titleViewController = self.presentingViewController as? TitleViewController {
            titleViewController.isSignedIn()
        }
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        userAge.text = "Age: "
        userWeight.text = "Weight: "
        
        [ageTxtField, weightTxtField, cancelEditBtn, saveEditsBtn, splitDayStepper].forEach { $0.isHidden = false }
        editBtn.isHidden = true
        
        ageTxtField.text = "\(Int((currentUser?.age)!))"
        weightTxtField.text = "\(Int((currentUser?.weight)!))"
        splitDayStepper.value = Double(splitDays)
        editBtnTapped = true
        
        splitCollectionView.reloadData()
    }
    
    @IBAction func updateSplitDays(_ sender: Any) {
        workoutSplitDayLabel.text = "Workout Split: \(Int(splitDayStepper.value)) Day"
       
        splitCollectionView.reloadData()
    }
    
    @IBAction func saveProfileEdits(_ sender: Any) {
        
        var savedSplit:[String] = []
        
        for index in splitCollectionView.indexPathsForVisibleItems {
            let cell = splitCollectionView.cellForItem(at: index) as! SplitCollectionViewCell
            let splitText = cell.editSplitTextField.text ?? "N/A"
            savedSplit.append(splitText)
        }
        
        db.update(id: currentUser!.id, age: Int(ageTxtField.text!) , weight: Double(weightTxtField.text!), split: savedSplit)
        
        [ageTxtField, weightTxtField, cancelEditBtn, saveEditsBtn, splitDayStepper].forEach { $0.isHidden = true }
        editBtn.isHidden = false
        editBtnTapped = false
        
        splitDays = Int(splitDayStepper.value)
        
        loadProfile()
        splitCollectionView.reloadData()
    }
    
    @IBAction func cancelProfileEdits(_ sender: Any) {
        [ageTxtField, weightTxtField, cancelEditBtn, saveEditsBtn, splitDayStepper].forEach { $0.isHidden = true }
        editBtn.isHidden = false
        editBtnTapped = false
        
        splitDayStepper.value = Double(splitDays)
        workoutSplitDayLabel.text = "Workout Split: \(splitDays) Day"
        
        loadProfile()
        splitCollectionView.reloadData()
        
    }
    
    func loadProfile() {
        let allUsers = db.read()
        for user in allUsers {
            if user.email == GIDSignIn.sharedInstance.currentUser?.profile?.email {
                currentUser = user
                break
            }
        }
        if currentUser == nil {
            print("Couldn't find user in database.")
        }
        userName.text = (GIDSignIn.sharedInstance.currentUser?.profile?.name ?? "")
        emailAddress.text = ("Email: " + (GIDSignIn.sharedInstance.currentUser?.profile?.email ?? ""))
        if currentUser?.age != nil {
            userAge.text = "Age: \(Int((currentUser?.age)!))"
        }
        if currentUser?.weight != nil {
            userWeight.text = "Weight: \(Int((currentUser?.weight)!))"
        }
        
        let userSplit = currentUser?.split?.components(separatedBy: ",") ?? []
        splitDays = userSplit.count > 0 ? userSplit.count : 3
        workoutSplitDayLabel.text = "Workout Split: \(splitDays) Day"
        splitDayStepper.value = Double(splitDays)
        
        profilePicture.load(url: (GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 320))!)
        profilePicture.makeRounded()
    }
}


extension ProfileViewController: UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        toolbar.setItems([flexSpace, doneBtn], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneEditing() {
        view.endEditing(true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let leftInset = (Int(splitCollectionView.frame.width) - 55 * Int(splitDayStepper.value)) / 2
        let rightInset = (Int(splitCollectionView.frame.width) - 55 * Int(splitDayStepper.value)) / 2
        splitCollectionView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(leftInset), bottom: 0, right: CGFloat(rightInset))
        splitCollectionView.layer.cornerRadius = 2
        splitCollectionView.layer.borderWidth = 3
        splitCollectionView.layer.borderColor = UIColor(red: 0.498, green: 0.051, blue: 0.008, alpha: 1.0).cgColor
        
        
        return Int(splitDayStepper.value)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = splitCollectionView.dequeueReusableCell(withReuseIdentifier: "splitCell", for: indexPath) as! SplitCollectionViewCell
        
        
        cell.splitCellLabel.text = currentUser?.split?.components(separatedBy: ",")[indexPath.row]
        
        cell.backgroundColor = UIColor.systemGray2
        cell.editSplitTextField.isHidden = !editBtnTapped
        cell.editSplitTextField.text = ""

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}


extension UIImageView {
    
    func load(url: URL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    
    func makeRounded() {
        
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}


