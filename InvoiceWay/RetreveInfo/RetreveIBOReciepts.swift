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

class RetreveIBOReciepts: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var custName: UITextField!
    @IBOutlet weak var recieptView: UITableView!
    var reciepts = [String]()

    
    
    @IBAction func searchClicked(_ sender: UIButton) {
        let ref = Database.database().reference()

        if (custName.text!.isEmpty) {
            let alert = UIAlertController(title: "No name entered", message: "You did not enter a name. If this is an error, please contact starboatllc@gmail.com with screenshots and an explanation of what happened.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))


            self.present(alert, animated: true)
        } else {
            
            self.reciepts.removeAll()
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")

            ref.child("users").child(token!).child("customers").child(custName.text!.uppercased()).child("orders").observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
//                    let snap = child as! DataSnapshot
//                    let song = snap.key
                    self.reciepts.append((child as AnyObject).key)

                }
                self.recieptView.reloadData()

                print(self.reciepts)

            })


     }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reciepts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recCell = recieptView.dequeueReusableCell(withIdentifier: "rCell")!
        
        let text = reciepts[indexPath.row]
        
        recCell.textLabel?.text = text
        
        return recCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard!.instantiateViewController(withIdentifier: "orderInfo") as! RetreveCustInfo
        let nc = UINavigationController(rootViewController: vc)
        vc.name = custName.text!
        vc.purchaseDate = reciepts[indexPath.row]
        self.present(nc, animated: true, completion: nil)


    }
}
