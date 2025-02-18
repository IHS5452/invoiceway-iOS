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
import FirebaseAuth


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UITextFieldDelegate, GADBannerViewDelegate{

    
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
    var cart = [String]();
    var priceCart = [Int]();
    @IBOutlet weak var totalLabel: UILabel!
    var finalprice: Double = 0.00
    
    @IBOutlet weak var SKUInput: UITextField!
    @IBOutlet weak var NameSearch: UITextField!
    var ref = Database.database().reference()
    var today : String!

    
    
    @IBAction func addtoBill(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        
        if (token == ""){
            let alert = UIAlertController(title: "Error", message: "Please login or create an account first", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }else if (SKUInput.text!.isEmpty) {
            let alert = UIAlertController(title: "No SKU entered", message: "You did not enter a SKU. If this is an error, please contact starboatllc@gmail.com with screenshots and an explanation of what happened.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        } else if (custNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            let alert = UIAlertController(title: "No name entered", message: "Make sure you enter a name for your customer. If this is an error, please contact starboatllc@gmail.com with screenshots.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))


            self.present(alert, animated: true)
        } else if (SKUInput.text!.contains("-") || SKUInput.text!.contains(" ") || SKUInput.text!.contains("_")) {
            let alert = UIAlertController(title: "Invalid characters", message: "Make sure you enter a SKU WITHOUT dashes, underscores, or spaces. If this is an error, please contact starboatllc@gmail.com to have us add the item in our database.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        } else {
   
            custNameTextField.isEnabled = false

        
        ref.child("amway_products").child(SKUInput.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary

            if (value == nil) {
                print(self.SKUInput.text!)
                let alert = UIAlertController(title: "No SKU found", message: "Make sure you enter a SKU from an Amway Product. If this is an error, please contact starboatllc@gmail.com to have us add the item in our database.", preferredStyle: .alert)
              
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
              
              
                         self.present(alert, animated: true)
            } else {
                
                print(self.SKUInput.text!)

            
            var itemName = value?["itemName"] ?? "No item found"
                var price = value?["price"] ?? 0.00
                var catagory = value?["catagory"] ?? "No catagory found"
            
            
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
            var combindedStrings = "$\(price) - (\(itemName)) - \(SKU): \(catagory)"
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
       
            var i = 0
           
            
            today = getTodayString()

            for item in cart {
                
                ref.child("users/\(String(describing: token!))/customers/\(custNameTextField.text!.uppercased())/orders/cart on \(today!)/\(i)").setValue(item)

                i+=1
            }
            

            
            let vc = storyboard!.instantiateViewController(withIdentifier: "checkout") as! checkoutController
            let nc = UINavigationController(rootViewController: vc)
            vc.name = custNameTextField.text!.uppercased()
                vc.cart = self.cart
            vc.price = self.finalprice
            self.present(nc, animated: true) {
                self.SKUInput.text! = ""
                self.cart.removeAll()
                self.priceCart.removeAll()
                self.billView.reloadData()
                self.totalLabel.text! = "Total: $0.00"
                self.custNameTextField.isEnabled = true
                self.custNameTextField.text! = ""

            }
           
            
        

        
        }
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        banner = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(banner)
   banner.adUnitID = "ca-app-pub-9400593844053407/9414830831"
   banner.rootViewController = self
        banner.load(GADRequest())
//        bannerView.delegate = self
        //addBannerViewToView(bannerView)
        
     
        
        
        self.custNameTextField.delegate = self

        
        billView.dataSource = self
        billView.delegate = self
        
        
        //SKUInput.text! = ""
        cart.removeAll()
        priceCart.removeAll()
        self.billView.reloadData()
        //totalLabel.text! = "Total: $0.00"

        var centerNavigationController: UINavigationController!
        var centerViewController: ViewController!

    
    
        
       
        
      

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
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        print(token)
        
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
 
    
    @IBAction func clearOrder(_ sender: UIBarItem) {
        
        
        SKUInput.text! = ""
        cart.removeAll()
        priceCart.removeAll()
        self.billView.reloadData()
        totalLabel.text! = "Total: $0.00"
    
        

        
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
    
    @IBAction func viewPastOrdersClicked(_ sender: UIBarItem) {
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
       
        
        print(Auth.auth().currentUser?.uid)
        showMiracle()
    }
        
          
        
        
        
        
    

      
    

    @IBAction func logout_clickec(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            let defaults = UserDefaults.standard
            defaults.set("", forKey: "iboNum")
            defaults.set("", forKey: "name")
            defaults.set("", forKey: "email")
            let alert = UIAlertController(title: "Sucess", message: "Logout sucesfull. Please login to create an order.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true) {
                UIView.animate(withDuration: 0.5) {
                    
                    self.menuView.frame.origin.x = -195
                    
                }
                self.SKUInput.text! = ""
                self.cart.removeAll()
                self.priceCart.removeAll()
                self.billView.reloadData()
                self.totalLabel.text! = "Total: $0.00"
                self.picker.selectRow(0, inComponent: 0, animated: true)
                self.custNameTextField.text! = ""
                
            }

        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Error", message: "Error logging out. Please try again. Error: \(signOutError)", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }
        
        
        
    }
    
    
    //start ad code
    
    // In this case, we instantiate the banner with desired ad size.
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
     
    

    
    @IBAction func onButton(_ sender: Any) {
        showMiracle()
    }
    
    @objc func showMiracle() {
        let slideVC = OverlayView()
            slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
    

    

