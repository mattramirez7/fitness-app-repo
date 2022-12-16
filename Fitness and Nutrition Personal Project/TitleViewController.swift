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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            
            print("user: \(user)")
            print("email: \(emailAddress)")
            print("fullName: \(fullName)")
            print("givenName: \(givenName)")
            print("familyName: \(familyName)")
            print("profilePicUrl: \(profilePicUrl)")
            // If sign in succeeded, display the app's main content View.
          }
    }

}

