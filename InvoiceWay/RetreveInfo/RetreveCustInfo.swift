//
//  RetreveCustInfo.swift
//  AmwayPOS
//
//  Created by Ian Schrauth on 6/28/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class RetreveCustInfo: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var name = ""
    var email = ""
    var custaddress = ""
    var cart = [String]()
    var purchaseDate = ""
    
    @IBOutlet weak var custName: UILabel!
    @IBOutlet weak var custEmail: UILabel!
    @IBOutlet weak var custShipAdd: UILabel!
    @IBOutlet weak var purchased: UITableView!
    var ref = Database.database().reference()


    
    
    @IBAction func showWebInfo(_ sender: UIButton) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "WebInfo") as! retreveWebInfo
                   let nc = UINavigationController(rootViewController: vc)
        vc.name = custName.text!

                   self.present(nc, animated: true, completion: nil)
                
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        custName.text! = name
        
        email = ""
        custaddress = ""
        self.cart.removeAll()
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")

        ref.child("users").child(token!).child("customers").child(name.uppercased()).child("orders").child(purchaseDate).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
//                    let snap = child as! DataSnapshot
//                    let song = snap.key
                self.cart.append((child as AnyObject).value)

            }
            self.purchased.reloadData()

            print(self.purchased)

        })
        print(name)
        ref.child("users").child(token!).child("customers").child(name).observeSingleEvent(of: .value, with: { [self] snapshot in
            for child in snapshot.children {
                let value = snapshot.value as? NSDictionary

                var email = value?["email"] ?? "NO EMAIL ON FILE"
                var address = value?["address"] ?? "NO ADDRESS ON FILE"
                var name = value?["fullName"] ?? "NULL"

                self.custEmail.text! = email as! String
                self.custShipAdd.text! = address as! String
            }


        

        })


        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recCell = purchased.dequeueReusableCell(withIdentifier: "pCell")!
        
        let text = cart[indexPath.row]
        
        recCell.textLabel?.text = text
        
        return recCell
    }
}

