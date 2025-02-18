//
//  RetreveIBOReciepts.swift
//  AmwayPOS
//
//  Created by Ian Schrauth on 6/28/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class retreveWebInfo: UIViewController  {
    
    

    @IBOutlet weak var custUsername: UITextField!
    @IBOutlet weak var custNum: UITextField!

    var name = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()

        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")

        ref.child("users").child(token!).child("customers").child(name.uppercased()).observeSingleEvent(of: .value, with: { [self] snapshot in
                let value = snapshot.value as? NSDictionary

                var WN = value?["webCustNumber"] ?? "NO NUMBER ON FILE"
                var WU = value?["webUsername"] ?? "NO USERNAME ON FILE"

                self.custNum.text! = WN as! String
                self.custUsername.text! = WU as! String
            
        

        })

        
        
    }
}
