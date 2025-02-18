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

class Register: UIViewController {
  
   
    
    var iboNum = ""
    @IBOutlet weak var falName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var amwayIBO: UITextField!
    @IBOutlet weak var pin: UITextField!
    @IBOutlet weak var finihsRegButton: UIButton!
    var ref: DatabaseReference! = Database.database().reference()
   
      
   
    

    @IBAction func finishRegister(_ sender: UIButton) {
        if (amwayIBO.text! == "") {
            let alert = UIAlertController(title: "ERROR", message: "IBO number input blank. Please enter your IBO Number.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        } else  if (falName.text! == "") {
                   let alert = UIAlertController(title: "ERROR", message: "Name input blank. Please enter your first and last name.", preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            

                            self.present(alert, animated: true)
               } else  if (email.text! == "") {
                          let alert = UIAlertController(title: "ERROR", message: "email input blank. Please enter your email.", preferredStyle: .alert)

                                   alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                   

                                   self.present(alert, animated: true)
                      } else  if (pin.text! == "") {
                                 let alert = UIAlertController(title: "ERROR", message: "PIN number input blank. Please enter your unique PIN Number.", preferredStyle: .alert)

                                          alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                          

                                          self.present(alert, animated: true)
        } else {
            
        
        
            
            
            Auth.auth().createUser(withEmail: email.text!, password: pin.text!) {
                authResult, error in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: "Error creating user. Error: \(error)", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    

                    self.present(alert, animated: true)
                } else {
                    self.ref.child("users/\(String(describing: self.amwayIBO.text!))/IBONum").setValue(self.amwayIBO.text!)
                    
                        self.ref.child("users/\(String(describing: self.amwayIBO.text!))/email").setValue(self.email.text!)
                    
                        self.ref.child("users/\(String(describing: self.amwayIBO.text!))/fullName").setValue(self.falName.text!)
                          
                           let defaults = UserDefaults.standard
                    defaults.set(self.amwayIBO.text!, forKey: "iboNum")
                           defaults.set(self.falName.text!, forKey: "name")
                           defaults.set(self.email.text!, forKey: "email")

//                           let alert = UIAlertController(title: "Sucess", message: "User created. Remember your email and password. You will be redirected to the login screen", preferredStyle: .alert)
//
//                           alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//
//
//                           self.present(alert, animated: true)
                    
                    Auth.auth().signIn(withEmail: self.email.text!, password: self.pin.text!) { result, err in
                        guard err == nil else {
                            let defaults = UserDefaults.standard
                            defaults.set(self.amwayIBO.text!, forKey: "iboNum")

                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                    }
                    

                           
                }
                
                
                
    }
        
        
        
       

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
        
                                   let alert = UIAlertController(title: "Reminder", message: "InvoiceWay and Starboat, LLC are NOT assosiated with Amway Corp. You must be an IBO with Amway to recicve an IBO Number.", preferredStyle: .alert)
        
                                   alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        
                                   self.present(alert, animated: true)
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        if ( token! != "") {
            let alert = UIAlertController(title: "User already created", message: "User already created. You will be redirected to the loging screen", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
            let iboToken = defaults.string(forKey: "iboNum")
            let nameToken = defaults.string(forKey: "name")
            let emailToken = defaults.string(forKey: "email")
            falName.text = nameToken!
            email.text = emailToken!
            amwayIBO.text = iboToken!
            
            falName.isEnabled = false
            email.isEnabled = false
            amwayIBO.isEnabled = false
            pin.isEnabled = false
            finihsRegButton.isEnabled = false
            
        }
        
    }
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}




