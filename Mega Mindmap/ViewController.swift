//
//  ViewController.swift
//  Mega Mindmap
//
//  Created by Markus Karlsson on 2019-04-10.
//  Copyright © 2019 The App Factory AB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, MegaViewDelegate {

    var megaScrollView: UIScrollView?
    var contentView: UIView?
    var fromSelectedView: MegaView?
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        megaScrollView = UIScrollView(frame: view.bounds)
        let contentSize: CGFloat = 1000
        megaScrollView!.contentSize = CGSize(width: contentSize, height: contentSize)
        megaScrollView!.contentOffset = CGPoint(x: contentSize/2-view.frame.size.width/2,
                                               y: contentSize/2-view.frame.size.height/2)
        megaScrollView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        megaScrollView!.delegate = self
        contentView = UIView(frame: CGRect(x: 0, y: 0,
                                           width: contentSize,
                                           height: contentSize))
        contentView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:))))
        megaScrollView!.addSubview(contentView!)
        megaScrollView!.maximumZoomScale = 2.0
        megaScrollView!.minimumZoomScale = 0.5
        view.addSubview(megaScrollView!)
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    // MARK: Gestures
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        if fromSelectedView != nil {
            fromSelectedView?.selected = false
            fromSelectedView = nil
        } else {
            let mview = MegaView(at: gesture.location(in: contentView))
            mview.delegate = self
            contentView!.addSubview(mview)
        }
    }
    
    // MARK: MegaViewDelegate
    
    func didEdit(view: MegaView) {
        // Show alert view with text input and edit views label
        let textInput = UIAlertController(title: "Edit text", message: nil, preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = view.label.text
        }
        textInput.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            let textField = textInput.textFields![0] as UITextField
            view.label.text = textField.text
            view.update()
        }))
        self.present(textInput, animated: true, completion: nil)
    }
    
    func didSelect(view: MegaView) {
        // Check if 2 mega views are selected - create line between them!
        if fromSelectedView != nil {
            if fromSelectedView == view {
                fromSelectedView!.delete()
            } else {
                let line = LineView(from: fromSelectedView!, to: view)
                contentView!.insertSubview(line, at: 0)
                fromSelectedView?.lines.append(line)
                view.lines.append(line)
                line.updateFrame()
                fromSelectedView?.selected = false
            }
            fromSelectedView = nil
        } else {
            view.selected = true
            fromSelectedView = view
        }
    }
}

