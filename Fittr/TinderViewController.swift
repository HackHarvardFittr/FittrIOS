//
//  TinderViewController.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import SwiftyJSON

class TinderViewController: UIViewController {
    var json:JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func Setup(my_json: JSON)
    {
        self.json = my_json;
        print(self.json)
        var draggableViewBackground = DraggableViewBackground(frame: self.view.frame);
        draggableViewBackground.Setup(my_json: self.json)
        self.view.addSubview(draggableViewBackground)
        
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
