//
//  Extensions.swift
//  Parsley
//
//  Created by Layne Johnson on 11/16/21.
//

import Foundation
import UIKit

// Delay segue.
extension NSObject {
    
    public func delayForSeconds(delay: Double, completion: @escaping() -> ()) {
        let timer = DispatchTime.now() + delay
        
        DispatchQueue.main.asyncAfter(deadline: timer) {
            completion()
        }
    }
}

// Segue.
extension UIViewController {
    func segueToNextViewController(segueID: String, delay: Double) {
        delayForSeconds(delay: delay) {
            self.performSegue(withIdentifier: segueID, sender: nil)
        }
    }
}
