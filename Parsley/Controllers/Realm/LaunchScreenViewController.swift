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

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide parsley logo.
        parsleyLogo.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animateLogo()
        
        performSegue(withIdentifier: Constants.Segues.todoLists, sender: self)

    }
    
    func animateLogo() {
        
        UIView.animate(withDuration: 2.0, delay: 0.50, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [], animations: {
            self.parsleyLogo.alpha = 1
        }, completion: nil)
    }
}
