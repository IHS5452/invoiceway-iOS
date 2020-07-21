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
extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class login: UIViewController {
  
    
    var iboNum = "";
    var password: String = "";
    var name = "";
        @IBOutlet weak var ibo: UITextField!
        @IBOutlet weak var pass: UITextField!
    
    
    @IBAction func login(_ sender: UIButton) {
        
        var ref = Database.database().reference()
              
        ref.child("users").child(self.ibo.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.password = value?["pin"] as? String ?? ""
            print("password is \(self.password)")
              })
              
        ref.child("users").child(self.ibo.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.iboNum = value?["IBONum"] as? String ?? self.ibo.text!
         
            print(self.iboNum)
        })
            ref.child("users").child(self.ibo.text!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.name = value?["name"] as? String ?? ""
             
                print(self.name)
            
                    })
              
              
            if (String(self.ibo.text!) == String(self.iboNum)) {
                  print("IBO Numbers match")
            if (self.pass.text == self.password) {
                let defaults = UserDefaults.standard
                defaults.set(self.ibo.text!, forKey: "iboNum")

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let secondVC = storyboard.instantiateViewController(identifier: "NavigationController")

                       show(secondVC, sender: self)
            

                } else {
                    let alert = UIAlertController(title: "Problem with your PIN", message: "Please make sure you typed your PIN in correctly. If it is correct, try again. If the problem continues, email starboatllc@gmail.com for support", preferredStyle: .alert)
                  
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                  
                  
                             self.present(alert, animated: true)
                    
                }
              } else {
                let alert = UIAlertController(title: "Problem with your IBO Number", message: "Please make sure you typed your IBO Number in correctly. If it is correct, try again. If the problem continues, email starboatllc@gmail.com for support. If you have not registered with us to use the app, please register first BEFORE logging in.", preferredStyle: .alert)
              
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
              
              
                         self.present(alert, animated: true)
                
              }
                    
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.setupToHideKeyboardOnTapOnView()
    
       
        let defaults = UserDefaults.standard
        let iboToken = defaults.string(forKey: "iboNum")
        ibo.text = iboToken!
        
    }


}




