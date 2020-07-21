//
//  shippingInfoController.swift
//  AmwayPOS
//
//  Created by Ian Schrauth on 6/29/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import UIKit
import FirebaseDatabase

class shippingInfoController: UIViewController {
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var cardNum: UITextField!
    @IBOutlet weak var CVV: UITextField!
    @IBOutlet weak var EXP: UITextField!
    
    var name = ""
 
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
                //Looks for single or multiple taps.
                    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

                    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
                    //tap.cancelsTouchesInView = false

                    view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func completePressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        
        ref.child("users/\(String(describing: token!))/customers/\(name)/address").setValue("\(address1.text!),\(address2.text!),\(city.text!),\(state.text!)\(zip.text!)")
        ref.child("users/\(String(describing: token!))/customers/\(name)/cardNum").setValue("\(cardNum.text!)")
        ref.child("users/\(String(describing: token!))/customers/\(name)/CVV").setValue("\(CVV.text!)")
        ref.child("users/\(String(describing: token!))/customers/\(name)/EXP").setValue("\(EXP.text!)")
        let alert = UIAlertController(title: "Complete", message: "Task complete. You may view this information later when you need to order the products.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        

        self.present(alert, animated: true)
        
    }
    
    
    
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}
