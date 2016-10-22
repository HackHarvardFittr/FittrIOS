//
//  LandingPageViewController.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LandingPageViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var staticBTN: UIButton!
    @IBAction func newPartnerButton(_ sender: AnyObject) {
        var competitionController = CompetitionViewController()
        self.navigationController?.pushViewController(competitionController, animated: true)
    }
    @IBAction func staticDetailButton(_ sender: AnyObject) {
    }
    
    
    func setupGif()
    {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staticBTN.frame = CGRect(x: 87, y: 233, width: 200, height: 200)
        staticBTN.layer.cornerRadius = 0.5 * staticBTN.bounds.size.width
        staticBTN.clipsToBounds = true
        // Do any additional setup after loading the view.
        title = "Chootiya"
        
        let gifImage = UIImage.gifWithURL("http://i.imgur.com/gjaYulp.gif")
        backgroundView.image = gifImage;
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
