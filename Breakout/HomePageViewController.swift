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
    @IBOutlet var levelsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in Home")
        // Do any additional setup after loading the view.
        Styling.styleFillButton(playGameButton)
        Styling.styleFillButton(levelsButton)
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
