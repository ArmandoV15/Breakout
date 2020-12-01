//
//  LoginViewController.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 11/25/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginPressed(_ sender: UIButton) {
        let empty = validateTextFields()
        if empty != nil{
            displayError(empty!)
            errorLabel.alpha = 1
        }else{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil{
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }else{
                    self.displayError("Wrong username or password")
                }
            }
        }
    }
    
    
    func validateTextFields() -> String?{
        if emailTextField.text == "" || passwordTextField.text == ""{
            return "Please fill in all text fields!!"
        }
        return nil
    }
    
    func displayError(_ error: String){
        errorLabel.text = error
        errorLabel.alpha = 1
    }
}
