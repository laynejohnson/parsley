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
        
        parsleyLogo.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
        
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
