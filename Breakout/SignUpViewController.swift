//
//  SignUpViewController.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 11/25/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextFeild: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
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
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["firstname":firstName, "lastname":lastName, "email":email, "username": username, "password":password]) { (error) in
                        if error != nil{
                            self.displayError("Something went wrong!")
                        }
                    }
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
