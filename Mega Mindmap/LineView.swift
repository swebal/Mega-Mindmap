//
//  LineView.swift
//  Mega Mindmap
//
//  Created by Markus Karlsson on 2019-04-10.
//  Copyright © 2019 The App Factory AB. All rights reserved.
//

import UIKit

class LineView: UIView {

    private var fromView: MegaView?
    private var toView: MegaView?
    
    // MARK: Init
    
    init(from: MegaView, to: MegaView) {
        fromView = from
        toView = to
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Render
    
    func updateFrame() {
        self.frame = fromView!.frame.union(toView!.frame)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 2.0
        fromView?.viewColor?.setStroke()
        let origin = fromView!.center - self.frame.origin
        let destination = toView!.center - self.frame.origin
        let halfOfViewWidth = (destination.x - origin.x) * 0.5
        path.move(to: origin)
        path.addCurve(to: destination, controlPoint1: origin.offset(halfOfViewWidth, 0), controlPoint2: destination.offset(-halfOfViewWidth, 0))
        path.stroke()
    }
}

// MARK: Extend operand - for CGPoint

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y);
}

extension CGRect {
    
    func atLeast(_ minValue: CGFloat) -> CGRect {
        return self.insetBy(dx: (self.size.width - max(self.size.width, minValue)),
                            dy: (self.size.height - max(self.size.height, minValue)))
    }
    
}

extension CGPoint {
    
    func offset(_ dx: CGFloat, _ dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}
