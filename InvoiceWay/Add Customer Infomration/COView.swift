import UIKit
import FirebaseAuth
import Foundation
import Firebase
import FirebaseDatabase
import UIKit


 

class COView: UIViewController {
    
    var iboNum = "";
    var password: String = "";
    var name = "";
    var em = "";
        @IBOutlet weak var customerNumber: UITextField!
    @IBOutlet weak var username: UITextField!
    var ref: DatabaseReference! = Database.database().reference()



    
    @IBAction func completeOrder(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "iboNum")
        
        ref.child("users/\(String(describing: token!))/customers/\(name)/webCustNumber").setValue(customerNumber.text)
        
        ref.child("users/\(String(describing: token!))/customers/\(name)/webUsername").setValue(username.text)
        
        
        let alert = UIAlertController(title: "Complete", message: "Task complete. You may view this information later when you need to order the products. If the customer is paying by card, please contact them when ordering their products.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        

        self.present(alert, animated: true)
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
        
        
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)

    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        
        self.setupToHideKeyboardOnTapOnView()
            
 
         
                      
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
