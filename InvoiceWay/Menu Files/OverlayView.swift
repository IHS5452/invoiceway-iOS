import UIKit
import FirebaseAuth
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
 

class OverlayView: UIViewController {
    
    var iboNum = "";
    var password: String = "";
    var name = "";
    var em = "";
        @IBOutlet weak var ibo: UITextField!
        @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    var ref: DatabaseReference! = Database.database().reference()

    
    
    
    @IBAction func login_clicked(_ sender: UIButton) {
        
        var ref = Database.database().reference()

        ref.child("users").child(ibo.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var email = value?["email"] ?? "null@email.com"
            print(email)
            if ("\(email)" != self.email.text!) {
                print("does not match")
                let alert = UIAlertController(title: "Problem with your IBO Number", message: "Please make sure you typed your IBO number is correct. If it is correct, try again. If the problem continues, email starboatllc@gmail.com for support. If you have not registered with us to use the app, please register first BEFORE logging in", preferredStyle: .alert)
        
                  alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
            } else {
                
            
        
        
     
              
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("it matches")
            
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
        
       
        
        
        
    })
    }

    @IBAction func logout_clicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let defaults = UserDefaults.standard
            defaults.set("", forKey: "iboNum")
            defaults.set("", forKey: "name")
            defaults.set("", forKey: "email")
            let alert = UIAlertController(title: "Sucess", message: "Logout sucesfull. Please login to create an order.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
            self.dismiss(animated: true, completion: nil)

              

        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Error", message: "Error logging out. Please try again. Error: \(signOutError)", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        }
        
        
    }
    
    
    
    
    @IBAction func create_account(_ sender: UIButton) {
    
        if (ibo.text! == "") {
            let alert = UIAlertController(title: "ERROR", message: "IBO number input blank. Please enter your IBO Number.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            

            self.present(alert, animated: true)
        } else if (email.text! == "") {
                          let alert = UIAlertController(title: "ERROR", message: "email input blank. Please enter your email.", preferredStyle: .alert)

                                   alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                   

                                   self.present(alert, animated: true)
                      } else  if (pass.text! == "") {
                                 let alert = UIAlertController(title: "ERROR", message: "PIN number input blank. Please enter your unique PIN Number.", preferredStyle: .alert)

                                          alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                          

                                          self.present(alert, animated: true)
        } else {
            
        
        
            
            
            Auth.auth().createUser(withEmail: email.text!, password: pass.text!) {
                authResult, error in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: "Error creating user. Error: \(error)", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    

                    self.present(alert, animated: true)
                } else {
                    self.ref.child("users/\(String(describing: self.ibo.text!))/IBONum").setValue(self.ibo.text!)
                    
                        self.ref.child("users/\(String(describing: self.ibo.text!))/email").setValue(self.email.text!)
                    
                       
                          
                           let defaults = UserDefaults.standard
                    defaults.set(self.ibo.text!, forKey: "iboNum")
                           defaults.set(self.email.text!, forKey: "email")

                    
                    Auth.auth().signIn(withEmail: self.email.text!, password: self.pass.text!) { result, err in
                        guard err == nil else {
                            let defaults = UserDefaults.standard
                            defaults.set(self.ibo.text!, forKey: "iboNum")

                            return

                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                    

                           
                }
                
                
                
    }
        
        
        
       

        }
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var caAccount: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subscribeButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Auth.auth().currentUser?.uid == nil){


        }else{
            loginButton.isEnabled = false
            caAccount.isEnabled = false
    }
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)

    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        
        self.setupToHideKeyboardOnTapOnView()
            
               
                let defaults = UserDefaults.standard
                let iboToken = defaults.string(forKey: "iboNum")
                let emailToken = defaults.string(forKey: "email")

        
        if ((iboToken?.isEmpty) != nil) {
            
        }else {
            ibo.text = iboToken!

        }
        if ((emailToken?.isEmpty) != nil) {
            
        }else {
            email.text = emailToken!

        }
                
         
                      
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
