//
//  signup-2.swift
//  finale1
//
//  Created by Yichen.li on 12/01/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit

class signup_2: UIViewController, UITextFieldDelegate{
    var artboard = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size));
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnamePH: UILabel!
    
    @IBOutlet weak var firstnamePH: UILabel!
    
    @IBOutlet weak var finishOutlet: UIButton!
    @IBAction func finish(sender: UIButton) {
        if checkIfValid2(){
            //change currentUser stat, and save in background
            var currentUser = PFUser.currentUser()
            if currentUser != nil {
                currentUser["trueName"] = (firstnameTF.text! + " " + lastnameTF.text!)
                currentUser.saveEventually()
                
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarID")
                self.showViewController(vc as! UIViewController, sender: vc)
            } else {
                // Show the signup or login screen
            }
        }
    }
    @IBOutlet weak var ErrorMs: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lastnameTF.delegate = self
        firstnameTF.delegate = self
        
        
        //button color config
        finishOutlet.backgroundColor = UIColor(red: CGFloat(74.0/255.0), green: CGFloat(144.0/255.0), blue: CGFloat(226.0/255.0), alpha: CGFloat(0.3))
        finishOutlet.layer.borderWidth = 1
        finishOutlet.layer.borderColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(216.0/255.0), blue: CGFloat(216.0/255.0), alpha: CGFloat(0.2)).CGColor
        
        
        self.view.addSubview(self.artboard)
        //draw
        var artwork = drawings()
        //white lines
        artboard.image = artwork.drawLinesInit(lastnameTF, line2For: firstnameTF);
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch (textField.restorationIdentifier!){
        case "lastnameResId":
            lastnamePH.hidden = true
        case "firstnameResId":
            firstnamePH.hidden = true
        default:
            println("BE:PH hidden failed");
        }
    }
    
    
    func textFieldDidEndEditing(textView: UITextField) {
        switch (textView.restorationIdentifier!){
        case "lastnameResId":
            lastnamePH.hidden = count(textView.text) != 0
        case "firstnameResId":
            firstnamePH.hidden = count(textView.text) != 0
        default:
            println("EE:PH hidden failed");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkIfValid2() -> Bool{
        
        var lastname_V = lastnameTF.text!
        var firstname_V = firstnameTF.text!
        //a​ != ​nil​ ? ​a​! : ​b
        //check if all right
        //for uniID, we can check the range of the number after u
        //
        var artwork = drawings()
        ErrorMs.hidden = true
        ErrorMs.text = ""
        firstnameTF.backgroundColor = nil
        lastnameTF.backgroundColor = nil
        
        if lastname_V == "" || firstname_V == "" {
            ErrorMs.hidden = false
            if lastname_V == "" {
                artboard.image = artwork.errorLine(firstnameTF, errorLineFor: lastnameTF)
                ErrorMs.text = "Error: You can't leave last name empty"
            }else{
                artboard.image = artwork.errorLine(lastnameTF, errorLineFor: firstnameTF)
                ErrorMs.text = "Error: You can't leave first name empty"
            }
            return false
        }else{
            return true
        }
    }

}
