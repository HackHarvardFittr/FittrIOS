//
//  DraggableViewBackground.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Foundation

class DraggableViewBackground: UIView, DragableDelegateView {
    
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!
    
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        exampleCardLabels = ["first", "second", "third", "fourth", "last"]
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
        
        
    }
    
    func loadCards()
    {
        if exampleCardLabels.count > 0
        {
            let CardsLoadCap = exampleCardLabels.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : exampleCardLabels.count
            for i in 0 ..< exampleCardLabels.count
            {
                var draggableView = self.createDraggableView(index: i)
                allCards.append(draggableView)
                
                if i < CardsLoadCap
                {
                    loadedCards.append(draggableView)
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
                
            }
        }
        
    }
    
    func createDraggableView(index: Int)->DraggableView
    {
        var draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT))
        draggableView.information.text = exampleCardLabels[index]
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
        loadedCards.remove(at: 0)
        if cardsLoadedIndex < allCards.count
        {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
            
        }
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
