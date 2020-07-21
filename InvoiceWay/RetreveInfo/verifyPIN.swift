//
//  verifyPIN.swift
//  AmwayPOS
//
//  Created by Ian Schrauth on 6/28/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class verifyPIN: UIViewController {
 
    var name = ""
    var pin = ""
    @IBOutlet weak var PINInput: UITextField!
    @IBOutlet weak var iboNum: UILabel!
    
    @IBAction func verify(_ sender: UIButton) {
        if (self.pin == PINInput.text) {
            let vc = storyboard!.instantiateViewController(withIdentifier: "card") as! retreveCardInfo
            let nc = UINavigationController(rootViewController: vc)
            vc.name = self.name
            self.present(nc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Wrong PIN", message: "Please try again.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupToHideKeyboardOnTapOnView()
                //Looks for single or multiple taps.
                    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

                    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
                    //tap.cancelsTouchesInView = false

                    view.addGestureRecognizer(tap)
        var ref = Database.database().reference()
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        
        ref.child("users").child(token!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.pin = value?["pin"] as? String ?? ""
            
            self.iboNum.text = token!

        
        })
        
    }
    


@objc override func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
}

}

