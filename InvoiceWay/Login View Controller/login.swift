//
//  searchSKU.swift
//  AmwayPOS
//
//  Created by admin on 4/10/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit
import FirebaseAuth


class login: UIViewController {
  
    
    var iboNum = "";
    var password: String = "";
    var name = "";
    var em = "";
        @IBOutlet weak var ibo: UITextField!
        @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction func login(_ sender: UIButton) {
        
        var ref = Database.database().reference()

        
        
        
     
              
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {

            
            Auth.auth().signIn(withEmail: self.email.text!, password: self.pass.text!) { (authResult, err) in
                print(err)
                if (err != nil) {
                    let alert = UIAlertController(title: "Problem with your Email, password, or IBO Number", message: "Please make sure you typed your email, password, or IBO number correctly. If it is correct, try again. If the problem continues, email starboatllc@gmail.com for support. If you have not registered with us to use the app, please register first BEFORE logging in. Error: \(err)", preferredStyle: .alert)
            
                                                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
                                    self.present(alert, animated: true)
                } else {
                    let defaults = UserDefaults.standard

                    ref.child("users").child(self.ibo.text!).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                                            let value = snapshot.value as? NSDictionary
                        defaults.set(value?["IBONum"] as? String ?? self.ibo.text!, forKey: "iboNum")

                                            print(value?["IBONum"] as? String ?? self.ibo.text!)
                    
                                                })
                                 
                                        self.dismiss(animated: true, completion: nil)
                                        }
                                    
                                
        
                    
    }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.setupToHideKeyboardOnTapOnView()
    
       
        let defaults = UserDefaults.standard
        let iboToken = defaults.string(forKey: "iboNum")
        let emailToken = defaults.string(forKey: "email")

        ibo.text = iboToken!
        email.text = emailToken!
        
 
              
        
    }


}




