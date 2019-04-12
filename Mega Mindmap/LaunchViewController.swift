//
//  LaunchViewController.swift
//  Mega Mindmap
//
//  Created by Markus Karlsson on 2019-04-12.
//  Copyright © 2019 The App Factory AB. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Remove old views
        for view in view.subviews {
            if view.tag != 100 {
                view.removeFromSuperview()
            }
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Create new views
        if let titleLabel = view.viewWithTag(100) as? UILabel {
            var colorfade: CGFloat = 1.0
            let steps = 50
            let offset = (view.frame.size.height - titleLabel.frame.size.height)/CGFloat(steps)
            for i in 1...steps {
                colorfade -= 1.0/CGFloat(steps)
                let label = UILabel(frame: titleLabel.frame)
                label.text = titleLabel.text
                label.font = titleLabel.font
                label.textColor = UIColor(hue: colorfade, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                view.insertSubview(label, at: 0)
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        label.frame = label.frame.offsetBy(dx: 0, dy: -1 * offset * CGFloat(i))
                        label.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/Double(steps))*CGFloat(i), 0, 0, 10)
                    })
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let label = UILabel(frame: titleLabel.frame)
                label.center = self.view.center
                label.text = titleLabel.text
                label.font = titleLabel.font
                label.textColor = UIColor.white
                label.alpha = 0.0
                self.view.addSubview(label)
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        label.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
                        label.alpha = 1.0
                    })
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                self.performSegue(withIdentifier: "launchToMindmapsSegue", sender: nil)
            }
        }
        
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
