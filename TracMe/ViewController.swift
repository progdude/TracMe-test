//
//  ViewController.swift
//  TracMe
//
//  Created by Archit Rathi on 3/8/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    var signInn:Bool = false;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //view.backgroundColor = UIColor.flatWhiteColor()
        signIn.layer.cornerRadius = 5
        signUp.layer.cornerRadius = 5
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.titleLabel.frame.origin.y -= self.view.bounds.height;
        image.frame.origin.y -= view.bounds.height
        signUp.frame.origin.y += view.bounds.height;
        signIn.frame.origin.y += view.bounds.height;
        emailLabel.frame.origin.y += view.bounds.height;
        passwordLabel.frame.origin.y += view.bounds.height;
        email.frame.origin.y += view.bounds.height;
        password.frame.origin.y += view.bounds.height
        slideIn();
        rotateImageView();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    private func slideIn(){
        UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.titleLabel.frame.origin.y += self.view.bounds.height;
            self.image.frame.origin.y += self.view.bounds.height;
            self.signIn.frame.origin.y -= self.view.bounds.height;
            self.signUp.frame.origin.y -= self.view.bounds.height;
            self.emailLabel.frame.origin.y -= self.view.bounds.height;
            self.passwordLabel.frame.origin.y -= self.view.bounds.height;
            self.password.frame.origin.y -= self.view.bounds.height;
            self.email.frame.origin.y -= self.view.bounds.height;
            
            self.view.layoutIfNeeded()
            }, completion: nil);
    }
    

    
    private func rotateImageView() {
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.image.transform = CGAffineTransformRotate(self.image.transform, CGFloat(M_PI_2))
            }) { (finished) -> Void in
                if finished {
                    self.rotateImageView()
                }
        }
    }
    

    @IBAction func signIn(sender: AnyObject) {
        
        signInn = true;

        setupNotificationSettings();
        let ref = Firebase(url: "https://vivid-torch-4452.firebaseio.com/")
        
        ref.authUser(self.email.text, password: self.password.text) {
            error, authData in
            if (error != nil) {
                // an error occurred while attempting login
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        print("Handle invalid user")
                    case .InvalidEmail:
                        print("Handle invalid email")
                    case .InvalidPassword:
                        print("Handle invalid password")
                    default:
                        print("Handle default situation")
                    }
                }
            }
            else {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
        
    }
    
    func setupNotificationSettings() {
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
        localNotification.alertBody = "Someone Wants You To Track Them"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(signInn){
        let toSendEmail = self.email.text
        
        let chooseUserViewController = segue.destinationViewController as! ChooseUserViewController
        chooseUserViewController.myEmail = toSendEmail
        }
    }

}

