//
//  SignUpViewController.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 11/25/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class SignUpViewController: UIViewController {

    var ref: DatabaseReference!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextFeild: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
        Styling.styleFillButton(signUpButton)
        Styling.styleHollowButton(cancelButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "signUpToHome"{
                if let homeVC = segue.destination as? HomePageViewController{
                    let email = emailTextField.text!
                    homeVC.emailOptional = email
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let error = validateTextFields()
        
        if error != nil{
            displayError(error!)
        }else{
            let firstName = firstNameTextField.text!
            let lastName = lastNameTextField.text!
            let email = emailTextField.text!
            let username = usernameTextField.text!
            let password = passwordTextFeild.text!
            
            Auth.auth().createUser(withEmail: email, password: password){ (result, err) in
                if err != nil {
                    self.displayError("Error creating user")
                }else{
                    let uid = Auth.auth().currentUser?.uid
                    self.ref.child("users").child(uid!).setValue(["firstName": firstName, "lastName": lastName, "email": email, "username": username, "password": password, "points": 0])
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                }
            }
        }
        
    }
    
    func validateTextFields() -> String?{
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || usernameTextField.text == "" || passwordTextFeild.text == ""{
            return "Please fill in all text fields!!"
        }
        return nil
    }
    
    func displayError(_ error: String){
        errorLabel.text = error
        errorLabel.alpha = 1
    }
}
