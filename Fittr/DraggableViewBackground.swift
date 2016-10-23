//
//  DraggableViewBackground.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import MapKit

class DraggableViewBackground: UIView, DragableDelegateView, CLLocationManagerDelegate {
    

    var allCards: [DraggableView]!
    
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var didCalldelegate: Bool!;
    var userDefaults = UserDefaults.standard;
    var json:JSON!;
    
   
    
    // Delegate method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
//        exampleCardLabels = ["first", "second", "third", "fourth", "last"]
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0

    }
    
    func Setup(my_json: JSON)
    {
        self.json = my_json;
        self.loadCards()

    }
    
    func loadCards()
    {
        if json.count > 0
        {
            let CardsLoadCap = json.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : json.count
            for i in 0 ..< json.count
            {
                var draggableView = self.createDraggableView(index: i)
                allCards.append(draggableView)
                
                if i < CardsLoadCap
                {
                    loadedCards.append(draggableView)
                }                
            }
            
            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
        
    }
    
    func createDraggableView(index: Int)->DraggableView
    {
        var draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT))
        draggableView.name.text = (((self.json.arrayValue)[index]).dictionaryValue)["name"]?.stringValue
        draggableView.weight.text = (((self.json.arrayValue)[index]).dictionaryValue)["weight"]?.stringValue
        draggableView.favWorkout.text = (((self.json.arrayValue)[index]).dictionaryValue)["favouriteWorkout"]?.stringValue
        draggableView.myID = (((self.json.arrayValue)[index]).dictionaryValue)["userid"]?.stringValue


        draggableView.delegate = self
        return draggableView
    }
    
    func setupView()
    {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        
    }
    
    func cardSwipedLeft(view: UIView) {
        loadedCards.remove(at: 0)
        if cardsLoadedIndex < allCards.count
        {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
            
        }
        
        
    }
    
    func cardSwipedRight(view: UIView) {
        let likeid = loadedCards[0].myID
        userDefaults.set(likeid, forKey: "swipeRight")
        loadedCards.remove(at: 0)
        if cardsLoadedIndex < allCards.count
        {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
        }
            var url = "http://35.161.109.99:4900/like"
            var parameter = [
                "userid" : userDefaults.string(forKey: "userid")!,
                "likeid" : userDefaults.string(forKey: "swipeRight")!
            ]
            let headers = [
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            
            Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .responseJSON(completionHandler: { (checkin) in
                print(checkin)
                if let result = checkin.result.value {
                    let jsonDict = result as! NSDictionary
                    if let boolVal = jsonDict["value"] {
                        let stringBoolVal = boolVal as! String
                        print(stringBoolVal)
                        if stringBoolVal == "true"{
                            let alertController = UIAlertController(title: "Match found!", message: "You have found a gym partner, GO LIFT!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "Cool", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.window?.rootViewController?.present(alertController, animated: true, completion: nil);
                        }
                        else
                        {
                            if self.cardsLoadedIndex < self.allCards.count
                            {
                                self.insertSubview(self.loadedCards[self.MAX_BUFFER_SIZE - 1], belowSubview: self.loadedCards[self.MAX_BUFFER_SIZE - 2])
                            }
                        }
                        
                    }
                }
                
                
            })
            
        }
       
        
    
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


