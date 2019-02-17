//
//  SecondViewController.swift
//  Treehacks

//  Create by @gerashabanets.
//  Created by Katie Mishra on 2/16/19.
//  Copyright © 2019 Katie Mishra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

//extension for spacing
extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.45) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

class HomeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    //variables
    var coinNumber: CLong = 0
    var currLevel: Int = 0
    
    //for the progress bar
    let MAXDIST: Float = 100.0
    var currDist: Float = 0.0
    var loaded = false

    //@IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var profilePic: UIImageView!
    
    //Purple headers
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var phoneNumberHeader: UILabel!
    @IBOutlet weak var progressHeader: UILabel!
    
    
    @IBOutlet weak var nameVal: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var currlvl: UILabel!
    @IBOutlet weak var nextlvl: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var coinLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ajdusting spacing for purple headers
        nameHeader.addCharacterSpacing()
        phoneNumberHeader.addCharacterSpacing()
        progressHeader.addCharacterSpacing()
        

        //RETRIEVING DATA AND SETTING LABELS
        let ref: DatabaseReference = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid //BUG!

        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            self.nameVal.text = "\(value?["firstName"] as? String ?? "") \(value?["lastName"] as? String ?? "")"
            self.nameVal.addCharacterSpacing()
            
            self.phoneNum.text = value?["parentsNumber"] as? String ?? ""
            self.phoneNum.addCharacterSpacing()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        //PROGRESS BAR
       // self.progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2)
        
        //IMAGE SELECTION
        //***implement
        
        
    }
    
    //ADVANCE LENGTH OF BAR
    func advance(_ sender: Bool) {
        currDist = 0
        progressBar.setProgress(currDist, animated: false)
        perform(#selector(updateProgress), with: nil, afterDelay: 0.1)

        currDist = currDist + 0.01
        perform(#selector(updateProgress), with: nil, afterDelay: 0.001)
    }
    
    //ADVANCE LENGTH OF BAR
    @objc func updateProgress() {
        currDist = currDist + 0.01
        progressBar.progress = currDist/MAXDIST
        
        if currDist < (Float)(coinNumber % 100) {
            perform(#selector(updateProgress), with: nil, afterDelay: 0.0001)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let ref: DatabaseReference = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            //self.currLevel = value?["Level"] as? Int ?? 1
            self.coinNumber = value?["numCoins"] as? Int ?? 0
            self.currlvl.text = "Level \(self.coinNumber / 100 + 1)"
            self.currlvl.addCharacterSpacing()
            self.nextlvl.text = "Level \(self.coinNumber / 100 + 2)"
            self.nextlvl.addCharacterSpacing()
            self.coinLabel.text = "\(self.coinNumber)"
            self.coinLabel.addCharacterSpacing()
            //self.coinNumber = 75
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        loaded = true
        advance(loaded)
    }
    
    
    
    
    
    
    
    
    /*
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        profilePic.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //@ACTIONS
    @IBAction func ChangeProfilePic(_ sender: UITapGestureRecognizer) {
       // nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
 
 */
    
}

