//
//  LaunchScreenViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 11/5/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var parsleyLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide logo.
        parsleyLogo.alpha = 0
        
        // Add accessibility label.
        parsleyLogo.accessibilityLabel = "Parsley Logo"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Fire initial animations.
        animateLogo()
        
        // Segue to navigation view controller.
        segueToNextViewController(segueID: Constants.Segues.navigationController, delay: 3.0)
    }
    
    func animateLogo() {
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            
            // Set logo alpha.
            self.parsleyLogo.alpha = 1
      
        }, completion: { [self]_ in
            clickParsley()
        })
    }
    
    func clickParsley() {
        parsleyLogo.center.y -= 2
        parsleyLogo.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        parsleyLogo.alpha = 0.8
        
        // Animate back to original position.
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {

            // Transform y position.
            self.parsleyLogo.center.y += 2
            
            // Return original state.
            self.parsleyLogo.transform = CGAffineTransform.identity
            self.parsleyLogo.alpha = 1

        }, completion: nil)
    }
}
