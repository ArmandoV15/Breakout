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
    @IBOutlet var loginButton: UIButton!
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "home1Segue"{
                if let homeVC = segue.destination as? HomePageViewController{
                    let email = emailTextField.text
                    homeVC.emailOptional = email
                }
            }
        }
    }
    
    
//    @IBAction func loginButtonPressed(_ sender: UIButton) {
//        let error = validateTextFields()
//
//        if error != nil{
//            displayError(error!)
//        }else{
//            let email = emailTextField.text!
//            let password = passwordTextField.text!
//
//            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//                if error != nil{
//                    self.errorLabel.text = error!.localizedDescription
//                    self.errorLabel.alpha = 1
//                }else{
//                        self.transitionHome()
//                }
//            }
//
//        }
//
//    }
    
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
    
    func transitionHome(){
        let homeVC = storyboard?.instantiateViewController(identifier: "homeVC") as? HomePageViewController
        
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
}
