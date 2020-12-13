//
//  PlayerStatsViewController.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 12/12/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PlayerStatsViewController: UIViewController {
    
    var emailOptional: String? = nil
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Styling.styleFillButton(homeButton)
        print(emailOptional!)
        getStats()
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
    
    func getStats(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let username = dictionary?["username"] as? String ?? ""
            let score = dictionary?["points"] as? Int ?? 1
            self.userNameLabel.text = username
            self.scoreLabel.text = "Total Points: \(score)"
            print(uid ?? "")
        }
    }
}
