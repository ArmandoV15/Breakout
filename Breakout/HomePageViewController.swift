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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in Home")
        print(emailOptional!)
        // Do any additional setup after loading the view.
        Styling.styleFillButton(playGameButton)
        Styling.styleFillButton(statsButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playerStatsPushed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "statsSegue", sender: self)
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue){
    }
}
