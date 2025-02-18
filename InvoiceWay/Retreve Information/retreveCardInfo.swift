//
//  retreveCardInfo.swift
//  AmwayPOS
//
//  Created by Ian Schrauth on 6/28/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
class retreveCardInfo: UIViewController {
 
    var name = ""
    
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var cardNumberTL: UILabel!
    @IBOutlet weak var cvvNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        var ref: DatabaseReference! = Database.database().reference()

        
        ref.child("users").child(token!).child("customers").child(name).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let value = snapshot.value as? NSDictionary

                let cardNumber = value?["cardNum"] ?? "NO CARD ON FILE"
                let cvv = value?["CVV"] ?? "000"
                let exp = value?["EXP"] ?? "0000"

                self.cardNumberTL.text! = cardNumber as! String
                self.expDate.text! = exp as! String
                self.cvvNum.text! = cvv as! String
            }


        

        })
    }
    
}
