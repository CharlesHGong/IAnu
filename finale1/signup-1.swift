//
//  suViewController.swift
//  finale1
//
//  Created by Yichen.li on 18/12/2014.
//  Copyright (c) 2014 libra34567. All rights reserved.
//
//pass data bt viewcontrollers
//http://jamesleist.com/ios-swift-passing-data-between-viewcontrollers/
/*
var svc = UIStoryboardSegue().destinationViewController as p1ViewController;
svc.toPass = uniidTF.text
*/


import UIKit


class suViewController: UIViewController, UITextFieldDelegate{
    
    
    var artboard = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size));
    
    
    
    
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var uniidTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernamePH: UILabel!
    @IBOutlet weak var uniidPH: UILabel!
    @IBOutlet weak var pwdPH: UILabel!
    @IBOutlet weak var ErrorMs: UILabel!
    
    func checkIfValid() -> Bool{
        var uniID_V = uniidTF.text!
        var pwd_V = pwdTF.text!
        var username_V = usernameTF.text!
        //a​ != ​nil​ ? ​a​! : ​b
        //check if all right
        //for uniID, we can check the range of the number after u
        ErrorMs.hidden = true
        ErrorMs.text = ""
        
        var artwork = drawings()
        
        if username_V == "" {
            ErrorMs.hidden = false
            if username_V == "" {
                artboard.image = artwork.errorLine(uniidTF, line2For: pwdTF, errorLineFor: usernameTF);
                ErrorMs.text = "Error: You can't leave username empty"
            }
            return false
        }else if  ((uniID_V == "") ? true : count(uniID_V) != 8) { //|| ErrorMs.text[0] != "u"
            artboard.image = artwork.errorLine(usernameTF, line2For: pwdTF, errorLineFor: uniidTF)
            ErrorMs.hidden = false
            if count(uniID_V) == 0 {
                ErrorMs.text = "Error: You can't leave Uni-ID empty"
            }else{
                ErrorMs.text = "Error: Invalid Uni-ID"
            }
            return false
        }else if (pwd_V == "" ? true : count(pwd_V) < 8) {
            artboard.image = artwork.errorLine(usernameTF, line2For: uniidTF, errorLineFor: pwdTF)
            ErrorMs.hidden = false
            if pwd_V == "" {
                ErrorMs.text = "Error: You can't leave password empty"
            }else if (count(pwd_V) < 8){
                ErrorMs.text = "Error: You password must not be shorter than 8"
            }
            return false
        }else{
            return true
        }
    }
    
    @IBAction func signup(sender: UIButton) {
        if checkIfValid() {
            userSignup(uniIDIn: uniidTF.text!, pwdIn: pwdTF.text!, userNameIn: (usernameTF.text!), accessibilityIn: 0)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        uniidTF.delegate = self
        pwdTF.delegate = self
        
        //button color config
        backOutlet.backgroundColor = UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(0.16))
        backOutlet.layer.shadowColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.5)).CGColor
        backOutlet.layer.shadowOffset = CGSize(width: 0, height: 2)
        backOutlet.layer.shadowRadius = CGFloat(3.0)
        
        
        
        signupOutlet.backgroundColor = UIColor(red: CGFloat(74.0/255.0), green: CGFloat(144.0/255.0), blue: CGFloat(226.0/255.0), alpha: CGFloat(0.3))
        signupOutlet.layer.shadowColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.5)).CGColor
        signupOutlet.layer.shadowOffset = CGSize(width: 0, height: 2)
        signupOutlet.layer.shadowRadius = CGFloat(4.0)
        
        
        
        
        self.view.addSubview(self.artboard)
        //draw
        var artwork = drawings()
        //white lines
        artboard.image = artwork.drawLinesInit(usernameTF, line2For: uniidTF, line3For: pwdTF);
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch (textField.restorationIdentifier!){
        case "usernameResId":
            usernamePH.hidden = true
        case "uniidResId":
            uniidPH.hidden = true
        case "pwdResId":
            pwdPH.hidden = true
        default:
            println("BE:PH hidden failed");
        }
    }
    
    func textFieldDidEndEditing(textView: UITextField) {
        switch (textView.restorationIdentifier!){
        case "usernameResId":
            usernamePH.hidden = count(textView.text) != 0
        case "uniidResId":
            uniidPH.hidden = count(textView.text) != 0
        case "pwdResId":
            pwdPH.hidden = count(textView.text) != 0
        default:
            println("EE:PH hidden failed");
        }
    }
    
    
   
    class drawings {
        var size = UIScreen.mainScreen().bounds.size
        func drawLinesInit(line1For: UITextField, line2For: UITextField, line3For: UITextField) -> UIImage {
            // Setup our context
            let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
            let opaque = false
            let scale: CGFloat = 0
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            let context = UIGraphicsGetCurrentContext()
            
            // Setup complete, do drawing here
            CGContextSetStrokeColorWithColor(context, UIColor(red: CGFloat(1), green: CGFloat(1), blue: (1), alpha: CGFloat(1.0)).CGColor)
            CGContextSetLineWidth(context, 0.7)
            CGContextBeginPath(context)
            //line1
            CGContextMoveToPoint(context, line1For.frame.minX, line1For.frame.maxY);
            CGContextAddLineToPoint(context, line1For.frame.maxX, line1For.frame.maxY);
            //line2
            CGContextMoveToPoint(context, line2For.frame.minX, line2For.frame.maxY);
            CGContextAddLineToPoint(context, line2For.frame.maxX, line2For.frame.maxY);
            //line2
            CGContextMoveToPoint(context, line3For.frame.minX, line3For.frame.maxY);
            CGContextAddLineToPoint(context, line3For.frame.maxX, line3For.frame.maxY);
            
            //shadow
            CGContextSetShadowWithColor(context, CGSize(width: 0, height: 2), CGFloat(4.0), UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: (0.0), alpha: CGFloat(0.5)).CGColor);
            //endline
            CGContextStrokePath(context);
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        
        func errorLine(line1For:UITextField, line2For:UITextField, errorLineFor:UITextField) -> UIImage {
            // Setup our context
            let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
            let opaque = false
            let scale: CGFloat = 0
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            let context = UIGraphicsGetCurrentContext()
            
            
            
            //normal line
            // Setup complete, do drawing here
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            CGContextSetLineWidth(context, 0.7)
            CGContextBeginPath(context)
            //line1
            CGContextMoveToPoint(context, line1For.frame.minX, line1For.frame.maxY);
            CGContextAddLineToPoint(context, line1For.frame.maxX, line1For.frame.maxY);
            //line2
            CGContextMoveToPoint(context, line2For.frame.minX, line2For.frame.maxY);
            CGContextAddLineToPoint(context, line2For.frame.maxX, line2For.frame.maxY);
            //shadow
            CGContextSetShadowWithColor(context, CGSize(width: 0, height: 2), CGFloat(4.0), UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: (0.0), alpha: CGFloat(0.5)).CGColor);
            //endline
            CGContextStrokePath(context);
            
            
            
            //error line
            // Setup complete, do drawing here
            CGContextSetStrokeColorWithColor(context, UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(0.8)).CGColor)
            CGContextSetLineWidth(context, 0.7)
            CGContextBeginPath(context)
            //line3
            CGContextMoveToPoint(context, errorLineFor.frame.minX, errorLineFor.frame.maxY);
            CGContextAddLineToPoint(context, errorLineFor.frame.maxX, errorLineFor.frame.maxY);
            //shadow
            CGContextSetShadowWithColor(context, CGSize(width: 0, height: 3), CGFloat(4.0), UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(1.0)).CGColor);
            //endline
            CGContextStrokePath(context);
            
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func userSignup(#uniIDIn:String,pwdIn: String,userNameIn: String,accessibilityIn: Int){
        var user = PFUser()

        ErrorMs.hidden = true
        ErrorMs.text = ""
        user.username = userNameIn
        user["accessibility"] = accessibilityIn
        user["userType"] = "endUser"
        user.password = pwdIn
        user["uniID"] = uniIDIn
        user.email = uniIDIn + "@anu.edu.au"
        
        
        
        //HUDController.sharedController.contentView = HUDContentView.ProgressView()
        //HUDController.sharedController.show()
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError!) -> Void in
            if error == nil {
                //login here
                PFUser.logInWithUsernameInBackground(user.username, password:user.password) {
                    (user: PFUser!, error: NSError!) -> Void in
                    if user != nil {
                        //HUDController.sharedController.hide(afterDelay: 0)
                        //next page
                        let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("signup_2")
                        self.showViewController(vc as! UIViewController, sender: vc)
                    } else {
                        //HUDController.sharedController.hide(afterDelay: 0)
                        //HUDController.sharedController.contentView = HUDContentView.SubtitleView(subtitle: "Login Fail", image: HUDAssets.crossImage)
                        //HUDController.sharedController.show()
                        //HUDController.sharedController.hide(afterDelay: 2.0)
                    }
                }
            } else {
                let errorString:AnyObject? = error.userInfo
                self.ErrorMs.hidden = false
                var errorSub = "Sign-up Fail"
                //HUDController.sharedController.contentView = HUDContentView.SubtitleView(subtitle: errorSub, image: HUDAssets.crossImage)
                //HUDController.sharedController.show()
                //HUDController.sharedController.hide(afterDelay: 2.0)
                // Show the errorString somewhere and let the user try again.
            }
        }
    }
}