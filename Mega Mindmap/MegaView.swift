//
//  MegaView.swift
//  Mega Mindmap
//
//  Created by Markus Karlsson on 2019-04-10.
//  Copyright © 2019 The App Factory AB. All rights reserved.
//

import UIKit

protocol MegaViewDelegate {
    func didEdit(view: MegaView)
    func didSelect(view: MegaView)
}

class MegaView: UIView {
    
    var delegate: MegaViewDelegate?
    var lines = [LineView]()
    var label = UILabel()
    private var viewColor: UIColor?
    
    // MARK: Init
    
    init(at: CGPoint) {
        let size: CGFloat = 80
        let frame = CGRect(x: at.x-size/2,
                           y: at.y-size/2,
                           width: size,
                           height: size)
        super.init(frame: frame)
        label.frame = self.bounds
        label.text = "Text"
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        self.layer.cornerRadius = size/2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.random()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        tap.require(toFail: doubleTap)
        addGestureRecognizer(tap)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(gesture:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Gestures
    
    @objc func didDoubleTap(gesture:UITapGestureRecognizer) {
        delegate?.didEdit(view: self)
    }
    
    @objc func didTap(gesture:UITapGestureRecognizer) {
        delegate?.didSelect(view: self)
    }
    
    @objc func didPan(gesture:UIPanGestureRecognizer) {
        if gesture.state == .changed {
            // TODO: Move view and render line views
            self.center = gesture.location(in: self.superview)
            for line in lines {
                line.updateFrame()
            }
        }
    }
    
    // MARK: Select
    
    func select() {
        viewColor = self.backgroundColor
        self.backgroundColor = UIColor.yellow
    }
    
    func deselect() {
        self.backgroundColor = viewColor
    }
    
    // MARK: Delete
    
    func delete() {
        for line in lines {
            line.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(256))/255.0
        let randomGreen = CGFloat(arc4random_uniform(256))/255.0
        let randomBlue = CGFloat(arc4random_uniform(256))/255.0
        return UIColor(displayP3Red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}
