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
    @IBOutlet weak var profilePicture: UIImageView!
    
    var db = DBManager()
    var users = Array<User>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfileInfo()
        
        //db.insert(id: 1, name: userName.text!, age: 21, email: emailAddress.text!)
        
        users = db.read()
        print(users)
        print(db.dbPath)
    }
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()

        if let titleViewController = self.presentingViewController as? TitleViewController {
            titleViewController.isSignedIn()
        }
        
        self.dismiss(animated: true)
        
    }
    
    func loadProfileInfo() {
        userName.text = GIDSignIn.sharedInstance.currentUser?.profile?.name
        emailAddress.text = GIDSignIn.sharedInstance.currentUser?.profile?.email
        profilePicture.load(url: (GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 320))!)
        profilePicture.makeRounded()
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


