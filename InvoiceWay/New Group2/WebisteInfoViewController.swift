//
//  WebisteInfoViewController.swift
//  InvoiceWay
//
//  Created by Ian Schrauth on 3/13/21.
//  Copyright © 2021 Ian Schrauth. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class WebsiteInfoViewController: UIViewController  {
    
    var name = ""
    @IBOutlet weak var customerNumber: UITextField!
    @IBOutlet weak var username: UITextField!
    
    var ref: DatabaseReference! = Database.database().reference()

    
    @IBAction func completeOrder(_ sender: UIButton) {

        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        ref.child("users/\(String(describing: token!))/customers/\(name)/webCustNumber").setValue(customerNumber.text)
        
        ref.child("users/\(String(describing: token!))/customers/\(name)/webUsername").setValue(username.text)
        
        
        let alert = UIAlertController(title: "Complete", message: "Task complete. You may view this information later when you need to order the products. If the customer is paying by card, please contact them when ordering their products.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        

        self.present(alert, animated: true) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

        }
    }
    
      override func viewDidLoad() {
          super.viewDidLoad()
        
      }
    
}
