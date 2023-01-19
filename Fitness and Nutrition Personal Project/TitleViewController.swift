//
//  ViewController.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 10/5/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn 

class TitleViewController: UIViewController {
    
    @IBOutlet weak var googleSignInView: GIDSignInButton!
    
    @IBOutlet weak var welcomeMessage: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if (GIDSignIn.sharedInstance.currentUser != nil) {
//            GIDSignIn.sharedInstance.signOut()
//        }
        
        isSignedIn()
    }
    
    
    func isSignedIn() {
        if (GIDSignIn.sharedInstance.currentUser == nil) {
            googleSignInView.isHidden = false
            welcomeLabel.isHidden = true
            welcomeMessage.isHidden = true

        } else {
            googleSignInView.isHidden = true
            
            let user = GIDSignIn.sharedInstance.currentUser!.profile?.givenName ?? "default name"
            
            welcomeLabel.text = "Welcome, \(user)"
            welcomeLabel.textColor = UIColor(red: 0.498, green: 0.051, blue: 0.008, alpha: 1.0)
            welcomeMessage.layer.borderWidth = 5
            welcomeMessage.layer.borderColor = UIColor.black.cgColor
            welcomeMessage.alpha = 0
            welcomeMessage.layer.cornerRadius = 10
            welcomeLabel.alpha = 0
            welcomeLabel.isHidden = false
            welcomeMessage.isHidden = false
            
            UIView.animate(withDuration: 1.5) {
                self.welcomeLabel.alpha = 1
                self.welcomeMessage.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.performSegue(withIdentifier: "userSignedIn", sender: self)
            }
            
        }
        
    }
    
    
    
    @IBAction func signIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            // If sign in succeeded, display the app's main content View.
            self.isSignedIn()
                
            
          }
    }

}

