//
//  ChooseUserViewController.swift
//  TracMe
//
//  Created by Archit Rathi on 3/10/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import Firebase

class ChooseUserViewController: UIViewController {
    
    
    @IBOutlet weak var trackerLabel: UILabel!
    @IBOutlet weak var trackingLabel: UILabel!
    @IBOutlet weak var trackuserButton: UIButton!
    @IBOutlet weak var requestuserButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    var scared = true;
    var myEmail :String!
    var trackingEmail: String?
    let ref = Firebase(url: "https://vivid-torch-4452.firebaseio.com/")
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackUser()
        
        trackuserButton.layer.cornerRadius = 5;
        requestuserButton.layer.cornerRadius = 5;
        searchButton.layer.cornerRadius = 5;
        
        let notificationCenter = NSNotificationCenter.defaultCenter();
        notificationCenter.addObserver(self, selector: "appMovedToBackground", name: UIApplicationWillResignActiveNotification, object: nil);

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(scared){
            
            let chooseMap = segue.destinationViewController as! ChooseMapViewController
            chooseMap.myEmail = myEmail
        }
        else{
            let track = segue.destinationViewController as! TrackFriendViewController
            track.myEmail = myEmail
            track.trackingEmail = trackingEmail
        }
       
        
        
    }
    

    @IBAction func search(sender: AnyObject) {
        ref.observeEventType(.Value, withBlock: { snapshot in
            var s = snapshot.value as! NSDictionary
    
            var t  = self.searchBar.text;
            self.trackingEmail = t
            t = t!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            var newEmail = self.myEmail!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            
            var hopperRef = self.ref.childByAppendingPath(t)
            var tracker = ["tracker": s[newEmail]![newEmail]!!]
            
            hopperRef.updateChildValues(tracker)
            
            var trackerRef = self.ref.childByAppendingPath(newEmail)
            var tracking = ["tracking":s[t!]![t!]!!]
            trackerRef.updateChildValues(tracking)
            self.trackingLabel.text = self.searchBar.text;
            
            }, withCancelBlock: { error in
                print(error.description)
        })    }
    
    func appMovedToBackground() {
        myEmail = myEmail.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var r = Firebase(url: "https://vivid-torch-4452.firebaseio.com/"+myEmail);
        
        r.observeEventType(.ChildAdded, withBlock: { snapshot in
            
        })
    }
    
    
    func trackUser(){
        myEmail = myEmail!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var carlos = Firebase(url: "https://vivid-torch-4452.firebaseio.com/"+myEmail+"/tracker/email");
        var s = "";
        var b = false;
        carlos.observeEventType(.Value, withBlock: { snapshot in
            if(!(snapshot.value is NSNull)){
            s = snapshot.value as! String;
            b = true;
            }
            
            if(b){
                self.trackerLabel.text = s;
            }
            else{
                self.trackerLabel.text = "No User Found"
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
        

    }
    
    
    @IBAction func trackUserButton(sender: AnyObject) {
        myEmail = myEmail!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var carlos =  Firebase(url: "https://vivid-torch-4452.firebaseio.com/"+myEmail+"/tracker")
        
        var exists = false;
        carlos.observeEventType(.Value, withBlock: { snap in
            if snap.value is NSNull {
                print("not there");
                exists = true;
            }
            
        })
        
        if(!exists){
            scared = false;
            self.performSegueWithIdentifier("trackFriendSegue", sender: nil)
        }
    }
    
}
