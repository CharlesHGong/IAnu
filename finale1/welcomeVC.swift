//
//  welcomeVC.swift
//  finale1
//
//  Created by Yichen.li on 11/03/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit

class welcomeVC: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var login: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signup.layer.cornerRadius = 0
        signup.layer.borderWidth = 1.5
        signup.layer.borderColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(216.0/255.0), blue: CGFloat(216.0/255.0), alpha: CGFloat(0.2)).CGColor
        login.layer.cornerRadius = 0
        login.layer.borderWidth = 1.5
        login.layer.borderColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(216.0/255.0), blue: CGFloat(216.0/255.0), alpha: CGFloat(0.2)).CGColor
        
        
        var myString:NSString = "University is a universe with shiny stars"
        var itemString1 = NSMutableAttributedString()
        itemString1 = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Chalkduster", size: 22.62)!])
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(126.0/255.0), green: CGFloat(211.0/255.0), blue: CGFloat(33.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:0,length:10))
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(90.0/255.0), green: CGFloat(163.0/255.0), blue: CGFloat(232.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:11,length:2))
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(248.0/255.0), green: CGFloat(231.0/255.0), blue: CGFloat(28.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:14,length:1))
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(157.0/255.0), green: CGFloat(107.0/255.0), blue: CGFloat(55.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:16,length:8))
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(92.0/255.0), green: CGFloat(230.0/255.0), blue: CGFloat(205.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:25,length:4))
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(219.0/255.0), green: CGFloat(32.0/255.0), blue: CGFloat(35.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:30,length:5))
        itemString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: CGFloat(163.0/255.0), green: CGFloat(62.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0)), range: NSRange(location:36,length:5))
        
        myString = "People are brought together by Events"
        var itemString2 = NSMutableAttributedString()
        itemString2 = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Chalkduster", size: 18.1)!])
        itemString2.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length: myString.length))

        myString = "Why not join the crowd and enlighten yourself"
        var itemString3 = NSMutableAttributedString()
        itemString3 = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Chalkduster", size: 18.1)!])
        itemString3.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:myString.length))
        
        
        
        
        //rm
        let item1 = RMParallaxItem(image: UIImage(named: "item1")!, text: itemString1)
        let item2 = RMParallaxItem(image: UIImage(named: "item2")!, text: itemString2)
        let item3 = RMParallaxItem(image: UIImage(named: "item3")!, text: itemString3)
        
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3], motion: false)
        rmParallaxViewController.completionHandler = {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
