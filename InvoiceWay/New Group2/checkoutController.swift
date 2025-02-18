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

class checkoutController: UIViewController {
  
   var name = ""
    var cart = [String]();
    var listOfItems = ""
    var price = 0.00
    @IBOutlet weak var cashGiven: UITextField!
    var inputedPrice = 0.00

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var orderedItems: UITextView!
    @IBOutlet weak var email: UITextField!
    
    var ref: DatabaseReference! = Database.database().reference()
   
      
    
    @IBAction func Ship(_ sender: UIBarButtonItem) {
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        ref.child("users/\(String(describing: token!))/customers/\(name)/email").setValue("\(email!.text!)")
       
        
let vc = storyboard!.instantiateViewController(withIdentifier: "shipping") as! shippingInfoController
           let nc = UINavigationController(rootViewController: vc)
        vc.name = self.name
           self.present(nc, animated: true, completion: nil)
        
        
    }
    @IBAction func PWC(_ sender: UIBarButtonItem) {
        print("clicked")
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        
        
        if (!cashGiven.text!.isEmpty) {
            ref.child("users/\(String(describing: token!))/customers/\(name)/address").setValue("\(email!.text?.uppercased() ?? "NO EMAIL RECORDED")")

            inputedPrice = Double(cashGiven!.text!)!
            let alert = UIAlertController(title: "Success", message: "Their change is \(inputedPrice-self.price)", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.destructive, handler: {
                    action in

    //            self.navigationController?.dismiss(animated: true, completion: nil)
//                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                let nc = UINavigationController(rootViewController: vc)
//
//                self.navigationController?.dismiss(animated: true) {
//                    vc.returned = true
//                    vc.viewDidLoad()
//
//                }
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let nc = UINavigationController(rootViewController: vc)
               
                self.dismiss(animated: true, completion: nil)
                
                
                }))
            self.present(alert, animated: true)

        } else {
            
            
            let alert = UIAlertController(title: "No cash entered", message: "You did not enter the cash amount you were given. If this is an error, please contact starboatllc@gmail.com with screenshots and an explanation of what happened.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }
        
     
        
//        let alert = UIAlertController(title: "Success", message: "Their change is \(inputedPrice-self.price)", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
//
//            let viewControllerYouWantToPresent = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
//            self.present(viewControllerYouWantToPresent!, animated: true, completion: nil)
//
//            }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)


//        let alert2 = UIAlertController(title: "Change", message: "Their change is \(self.price - inputedPrice)", preferredStyle: .alert)
//
//
//        alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//
//
//        self.present(alert2, animated: true)
//        navigationController?.popViewController(animated: true)

        
//        dismiss(animated: true, completion: nil)
        
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.setupToHideKeyboardOnTapOnView()
        //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        
         nameLable.text = name
        
        var i = 0
        var j = 1
        for item in cart {
            
            listOfItems = listOfItems + "\(j)) " + cart[i] + "\n"
            i+=1
            j+=1
        }
        orderedItems.text = listOfItems
        
    }
    
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}




