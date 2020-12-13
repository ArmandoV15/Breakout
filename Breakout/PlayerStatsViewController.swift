//
//  PlayerStatsViewController.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 12/12/20.
//

import UIKit

class PlayerStatsViewController: UIViewController {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Styling.styleFillButton(homeButton)
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
}
