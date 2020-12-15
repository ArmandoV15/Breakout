//
//  HomePageViewController.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 11/25/20.
//

import UIKit

class HomePageViewController: UIViewController {

    var emailOptional: String? = nil
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var playGameButton: UIButton!
    @IBOutlet var statsButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in Home")
        // Do any additional setup after loading the view.
        Styling.styleFillButton(playGameButton)
        Styling.styleFillButton(statsButton)
        Styling.styleFillButton(logOutButton)
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
            if identifier == "statsSegue"{
                if let statsVC = segue.destination as? PlayerStatsViewController{
                    let email = emailOptional
                    statsVC.emailOptional = email
                }
            }
        }
    }
    
    @IBAction func playerStatsPushed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "statsSegue", sender: self)
    }
    
    @IBAction func unwindFromStats(_ segue: UIStoryboardSegue){
    }
    
    @IBAction func unwindFromGame(_ segue: UIStoryboardSegue){
    }
}
