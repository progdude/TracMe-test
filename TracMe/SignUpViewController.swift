//
//  SignUpViewController.swift
//  TracMe
//
//  Created by Archit Rathi on 3/8/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var sign: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sign.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func stopKeypad(sender: AnyObject) {
        view.endEditing(true);
    }

    @IBAction func sign_up(sender: AnyObject) {
        let ref = Firebase(url: "https://vivid-torch-4452.firebaseio.com/")
        ref.createUser(email.text, password: password.text,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    print(error);
                } else {
                    var user = ["email": self.email.text! as String, "password": self.password.text! as String, "number": self.number.text! as String];

                    
                    var t  = self.email.text;
                    t = t!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)

                    var users = [t! as String: user]
                    ref.childByAppendingPath(t!).setValue(users)
                    
                    self.performSegueWithIdentifier("signupSegue", sender: nil);

                }
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
            let toSendEmail = self.email.text
            
            let chooseUserViewController = segue.destinationViewController as! ChooseUserViewController
            chooseUserViewController.myEmail = toSendEmail
        
    }
}



