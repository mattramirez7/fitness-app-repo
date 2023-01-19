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
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var userWeight: UILabel!
    @IBOutlet weak var weightTxtField: UITextField!
    @IBOutlet weak var weightStepper: UIStepper!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    
    var db = DBManager()
    var users:[User] = []
    var currentUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTxtField.delegate = self
        weightTxtField.delegate = self
        
        ageTxtField.isHidden = true
        weightTxtField.isHidden = true
        ageStepper.isHidden = true
        weightStepper.isHidden = true
        
        loadProfileInfo()
        
        db.insert(id: 1, name: GIDSignIn.sharedInstance.currentUser?.profile?.name ?? "defaultName", email: GIDSignIn.sharedInstance.currentUser?.profile?.email ?? "defaultEmail")
        
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
        ageTxtField.isHidden = false
        weightTxtField.isHidden = false
        ageStepper.isHidden = false
        weightStepper.isHidden = false
        ageTxtField.text = "\( String(describing: currentUser!.age!))"
        weightTxtField.text = "\(String(describing: currentUser!.weight!))"
        ageStepper.value = Double(currentUser?.age ?? 0)
        weightStepper.value = currentUser?.weight ?? 0.0
        
    }
    
    @IBAction func saveProfileEdits(_ sender: Any) {
        db.update(id: currentUser!.id, age: Int(ageTxtField.text!) , weight: Double(weightTxtField.text!))
        
        ageTxtField.isHidden = true
        weightTxtField.isHidden = true
        ageStepper.isHidden = true
        weightStepper.isHidden = true
        
        loadProfileInfo()
        
    }
    
    @IBAction func editAge(_ sender: Any) {
        ageTxtField.text = "\(Int(ageStepper.value))"
    }
    
    @IBAction func editWeight(_ sender: Any) {
        weightTxtField.text = "\(weightStepper.value)"
    }
    
    func loadProfileInfo() {
        users = db.read(id: 1)
        currentUser = users[0]
        
        userName.text = ("Name: " + (GIDSignIn.sharedInstance.currentUser?.profile?.name ?? ""))
        emailAddress.text = ("Email: " + (GIDSignIn.sharedInstance.currentUser?.profile?.email ?? ""))
        if currentUser?.age != nil {
            userAge.text = "Age: \(String(describing: currentUser!.age!))"
        }
        if currentUser?.weight != nil {
            userWeight.text = "Weight: \(String(describing: currentUser!.weight!))"
        }

        profilePicture.load(url: (GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 320))!)
        profilePicture.makeRounded()
    }
}

extension ProfileViewController: UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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



