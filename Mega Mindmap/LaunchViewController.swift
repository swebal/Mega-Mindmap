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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let titleLabel = view.viewWithTag(100) as? UILabel {
            var colorfade: CGFloat = 1.0
            let steps = 15
            for i in 1...steps {
                colorfade -= 1.0/CGFloat(steps)
                let label = UILabel(frame: titleLabel.frame)
                label.text = titleLabel.text
                label.font = titleLabel.font
                label.textColor = UIColor(white: 1.0, alpha: colorfade)
                view.insertSubview(label, at: 0)
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        label.frame = label.frame.offsetBy(dx: 0, dy: -1 * label.frame.size.height * CGFloat(i))
                    })
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
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
