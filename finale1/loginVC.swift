//
//  login.swift
//  finale1
//
//  Created by Yichen.li on 14/01/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit

class login: UIViewController, UITextFieldDelegate {
    var artboard = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size));
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernamePH: UILabel!
    @IBOutlet weak var pwdPH: UILabel!
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    
    
    @IBAction func login(sender: UIButton) {
        //login here
        //HUDController.sharedController.contentView = HUDContentView.ProgressView()
        //HUDController.sharedController.show()
        PFUser.logInWithUsernameInBackground(usernameTF.text, password:passwordTF.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                //HUDController.sharedController.hide(afterDelay: 0)
                //next page
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarID")
                self.showViewController(vc as! UIViewController, sender: vc)
            } else {
                //HUDController.sharedController.hide(afterDelay: 0)
                //HUDController.sharedController.contentView = HUDContentView.SubtitleView(subtitle: "Login Fail", image: HUDAssets.crossImage)
                //HUDController.sharedController.show()
                //HUDController.sharedController.hide(afterDelay: 1.5)
            }
        }
    }
    @IBAction func forgotPwd(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
        
        
        //button color config
        backOutlet.backgroundColor = UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(0.16))
        backOutlet.layer.shadowColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.5)).CGColor
        backOutlet.layer.shadowOffset = CGSize(width: 0, height: 2)
        backOutlet.layer.shadowRadius = CGFloat(3.0)
        
        
        loginOutlet.backgroundColor = UIColor(red: CGFloat(74.0/255.0), green: CGFloat(144.0/255.0), blue: CGFloat(226.0/255.0), alpha: CGFloat(0.3))
        loginOutlet.layer.borderWidth = 1
        loginOutlet.layer.borderColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(216.0/255.0), blue: CGFloat(216.0/255.0), alpha: CGFloat(0.2)).CGColor
        
        
        self.view.addSubview(self.artboard)
        //draw
        var artwork = drawings()
        //white lines
        artboard.image = artwork.drawLinesInit(usernameTF, line2For: passwordTF);
    }
    
    
    
    class drawings {
        var size = UIScreen.mainScreen().bounds.size
        func drawLinesInit(line1For: UITextField, line2For: UITextField) -> UIImage {
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
            
            //shadow
            CGContextSetShadowWithColor(context, CGSize(width: 0, height: 2), CGFloat(4.0), UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: (0.0), alpha: CGFloat(0.5)).CGColor);
            //endline
            CGContextStrokePath(context);
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        
        func errorLine(line1For:UITextField, errorLineFor:UITextField) -> UIImage {
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
            //shadow
            CGContextSetShadowWithColor(context, CGSize(width: 0, height: 2), CGFloat(4.0), UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: (0.0), alpha: CGFloat(0.5)).CGColor);
            //endline
            CGContextStrokePath(context);
            
            
            //error line
            // Setup complete, do drawing here
            CGContextSetStrokeColorWithColor(context, UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(0.8)).CGColor)
            CGContextSetLineWidth(context, 0.7)
            CGContextBeginPath(context)
            //error line
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
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch (textField.restorationIdentifier!){
        case "usernameResId":
            usernamePH.hidden = true
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
        case "pwdResId":
            pwdPH.hidden = count(textView.text) != 0
        default:
            println("EE:PH hidden failed");
        }
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

}
