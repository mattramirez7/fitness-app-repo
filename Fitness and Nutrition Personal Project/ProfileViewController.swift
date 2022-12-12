//
//  ProfileViewController.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 10/5/22.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.image = UIImage(named: "Matt")
        profilePicture.makeRounded()
        username.text = "Matt"
    }
    
    @IBAction func addProfilePicBtnClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profilePicture.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }

    }
    







extension UIImageView {
    
    func makeRounded() {
        
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}


