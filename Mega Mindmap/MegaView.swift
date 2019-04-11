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
    var viewColor: UIColor?
    
    // MARK: Select
    
    private var _selected: Bool = false
    
    // Public variable (read-only)
    var selected: Bool {
        get {
            return _selected
        }
        set (state) {
            if _selected != state {
                _selected = state
                setNeedsDisplay()
            }
        }
    }
    
    // Set minimum and maximum width (minimum width == height)
    
    let viewheight: CGFloat = 80
    let minWidth: CGFloat = 80
    let maxWidth: CGFloat = 240
    let padding: CGFloat = 16
    
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
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(label)
        viewColor = UIColor.random()
        backgroundColor = UIColor.clear
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        tap.require(toFail: doubleTap)
        addGestureRecognizer(tap)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(gesture:))))
        update()
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
        } else if gesture.state == .began {
            superview?.bringSubviewToFront(self)
        }
    }
    
    // MARK: Delete
    
    func delete() {
        for line in lines {
            line.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    func update() {
        // Calculate frame for text and call draw
        let textSize = label.sizeThatFits(CGSize(width: maxWidth-2*padding, height: viewheight-2*padding))
        let width = max(minWidth, textSize.width + 2 * padding)
        label.frame = CGRect(x: padding, y: padding, width: width-2*padding, height: viewheight-2*padding)
        frame = CGRect(x: center.x-width/2, y: frame.origin.y, width: width, height: viewheight)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // TODO: Draw rounded corner rect behind label
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .topRight], cornerRadii: CGSize(width: viewheight/2, height: viewheight/2))
        _selected ? UIColor.yellow.setFill() : viewColor?.setFill()
        path.fill()
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
