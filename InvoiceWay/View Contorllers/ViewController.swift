//
//  ViewController.swift
//  AmwayPOS
//
//  Created by admin on 4/10/20.
//  Copyright © 2020 Starboat, LLC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, GADBannerViewDelegate{

    
    var hasStarted = false
       var shouldFinish = false
    var returned = false;
    var banner: GADBannerView!
    
    
    @IBOutlet weak var custNameTextField: UITextField!
    @IBOutlet weak var billView: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var menuButtonText: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var clearCurrentOrder: UIButton!
    var pickerData: [String] = [String]()
    var selection = "";
    var cart = [String]();
    var priceCart = [Int]();
    @IBOutlet weak var totalLabel: UILabel!
    var finalprice: Double = 0.00
    
    @IBOutlet weak var SKUInput: UITextField!
    @IBOutlet weak var NameSearch: UITextField!
    var ref = Database.database().reference()
    var today : String!

    
    
    @IBAction func addtoBill(_ sender: UIButton) {
        custNameTextField.isEnabled = false
        if (selection == "") || (selection == "Select a catagory") {
            let alert = UIAlertController(title: "Please select a catagory", message: "Make sure you select eihter Beauty, Home, nutrition, or Personal. If this is an error, please contact starboatllc@gmail.com with screenshots and an explanation of what happened.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        } else if (SKUInput.text!.isEmpty) {
            let alert = UIAlertController(title: "No SKU entered", message: "You did not enter a SKU. If this is an error, please contact starboatllc@gmail.com with screenshots and an explanation of what happened.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
//        } else if (SKUInput.text! == "") {
//            let alert = UIAlertController(title: "No SKU found", message: "Make sure you enter a SKU from an Amway Product. If this is an error, please contact starboatllc@gmail.com to have us add the item in our database.", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//
//
//            self.present(alert, animated: true)
//        }
        } else if (SKUInput.text!.contains("-") || SKUInput.text!.contains(" ") || SKUInput.text!.contains("_")) {
            let alert = UIAlertController(title: "Invalid characters", message: "Make sure you enter a SKU WITHOUT dashes, underscores, or spaces. If this is an error, please contact starboatllc@gmail.com to have us add the item in our database.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        } else {
            
        
        
        ref.child("amway_products").child(selection).child(SKUInput.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary

            if (value == nil) {
                let alert = UIAlertController(title: "No SKU found", message: "Make sure you enter a SKU from an Amway Product. If this is an error, please contact starboatllc@gmail.com to have us add the item in our database.", preferredStyle: .alert)
              
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
              
              
                         self.present(alert, animated: true)
            } else {
                
            
            
            var itemName = value?["itemName"] ?? "No item found"
                var price = value?["price"] ?? 0.00
            
            
            if let price2 = Int(price as! String) {
                self.priceCart.append(price2)
                let price3 = self.priceCart.reduce(0, +)
                let price2 = Double(price3)
                self.totalLabel.text = "Total: $\(price2)"
                self.finalprice = price2
                print("Price is \(price2)")
                print(self.finalprice)
                
                            }

            
            
            
            var SKU = value?["SKU"] ?? "000000"
            var combindedStrings = "$\(price) - (\(itemName)) - \(SKU)"
            self.cart.append(combindedStrings)
            self.billView.reloadData()
            self.SKUInput.text = ""
            self.view.endEditing(true)
            
        
            
            }
                    })
        }
        
    }
 
    @IBOutlet var leading: NSLayoutConstraint!
    @IBOutlet var trailing: NSLayoutConstraint!
    
    var menuOut = false
    
    @IBAction func checkoutClicked(_ sender: UIButton) {
        if (cart.isEmpty) {
            let alert = UIAlertController(title: "No items entered", message: "You did not enter any items into the cart. If this is an error, please contact starboatllc@gmail.com with screenshots and an explanation of what happened.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }else {
            
       
        
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        if (token == ""){
            let alert = UIAlertController(title: "Error", message: "Please login first", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }else {
            var i = 0
           
            
            today = getTodayString()

            for item in cart {
                
                ref.child("users/\(String(describing: token!))/customers/\(custNameTextField.text!)/orders/cart on \(today!)/\(i)").setValue(item)

                i+=1
            }
            

            
            let vc = storyboard!.instantiateViewController(withIdentifier: "checkout") as! checkoutController
            let nc = UINavigationController(rootViewController: vc)
            vc.name = custNameTextField.text!
                vc.cart = self.cart
            vc.price = self.finalprice
            self.present(nc, animated: true, completion: nil)
           
            
            SKUInput.text! = ""
            cart.removeAll()
            priceCart.removeAll()
            self.billView.reloadData()
            totalLabel.text! = "Total: $0.00"
            custNameTextField.isEnabled = true
            custNameTextField.text! = ""
            picker.selectRow(0, inComponent: 0, animated: true)

        }
        }
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        banner = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(banner)
   banner.adUnitID = "ca-app-pub-1934606145749562/1593655919"
   banner.rootViewController = self
        banner.load(GADRequest())
//        bannerView.delegate = self
        //addBannerViewToView(bannerView)

//            SKUInput.text! = ""
//        cart.removeAll()
//        priceCart.removeAll()
//        self.billView.reloadData()
//        totalLabel.text! = "Total: $0.00"
//        picker.selectRow(0, inComponent: 0, animated: true)
           
            
        
        
        self.custNameTextField.delegate = self

        
        billView.dataSource = self
        billView.delegate = self
        self.picker.delegate = self
          self.picker.dataSource = self
        self.billView.reloadData()


        var centerNavigationController: UINavigationController!
        var centerViewController: ViewController!

    
    
        
       
        
      
    pickerData = ["Select a catagory","Beauty", "Home", "Nutrition", "Personal Care"]

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = billView.dequeueReusableCell(withIdentifier: "cell")!
        
        let text = cart[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selection = pickerData[row] as String
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(priceCart[indexPath.row])
            priceCart.remove(at: indexPath.row)
            cart.remove(at: indexPath.row)
            let price2 = self.priceCart.reduce(0, +)
            self.totalLabel.text = "Total: $\(price2)"
            print("New price is \(price2)")
            billView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
   
 
    var menuHidden = false

    @IBAction func showMenu(_ sender: UIBarButtonItem) {

        if (menuHidden == false) {
            //menuButtonText.setTitle("HIDE MENU", for: .normal)
            
            UIView.animate(withDuration: 0.5) {
                
                self.menuView.frame.origin.x = 0
                
            }
            
            menuView.isHidden = false
            menuHidden = true
        } else {
           //menuButtonText.setTitle("SHOW MENU", for: .normal)
            UIView.animate(withDuration: 0.5) {
                
                self.menuView.frame.origin.x = -195
                
            }
            menuHidden = false


        }
        
    }
 
    
    @IBAction func clearOrder(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.menuView.frame.origin.x = -195
            
        }
        SKUInput.text! = ""
        cart.removeAll()
        priceCart.removeAll()
        self.billView.reloadData()
        totalLabel.text! = "Total: $0.00"
        picker.selectRow(0, inComponent: 0, animated: true)
    
        

        
    }
    
 
    
    
    @IBAction func goToLoginPage(_ sender: UIButton) {
        
    }
    


//class popup {
//    var title: String
//    var mesage: String
//    var opt1: String
//
//    init(title: String, mesage: String, opt1: String) {
//        let alert = UIAlertController(title: self.title, message: self.title, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: opt1, style: .default, handler: nil))
//        //alert.addAction(UIAlertAction(title: opt2, style: .cancel, handler: nil))
//
//    }
//
//
//}

func getTodayString() -> String{

                let date = Date()
                let calender = Calendar.current
                let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

                let year = components.year
                let month = components.month
                let day = components.day
                let hour = components.hour
                let minute = components.minute
                let second = components.second

                let today_string = String(month!) + "-" + String(day!) + "-" + String(year!) + " at " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)

                return today_string

            }
    
    @IBAction func viewPastOrdersClicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        
        if (token == ""){
            let alert = UIAlertController(title: "Error", message: "Please login or create an account first", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }else{
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! RetreveIBOReciepts
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        if (token == ""){
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "login") as! login
            let nc = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true, completion: nil)
        }else{
        
            let alert = UIAlertController(title: "Error", message: "You are already logged in", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
    }
        
    
    //start ad code
    
    // In this case, we instantiate the banner with desired ad size.
      
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
     
    
    
    
}
    
    

