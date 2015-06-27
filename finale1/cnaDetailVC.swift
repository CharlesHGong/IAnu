//
//  detailPageVC.swift
//  finale1
//
//  Created by Yichen.li on 7/01/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit

class cnaDetailVC: UIViewController,PayPalPaymentDelegate {
    var config = PayPalConfiguration()
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var cnaName: UILabel!
    @IBOutlet weak var cnaTitle: UINavigationItem!
    @IBOutlet weak var uniNOrgType: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var membershipFee: UILabel!
    @IBOutlet weak var membershipFor: UILabel!
    @IBOutlet weak var detailDescription: UITextView!
    @IBOutlet weak var uniLabel: UILabel!
    
    @IBAction func Join(sender: UIButton) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var datRow = delegate.selectedRow as Int
        
        //get value from storage
        var datList:NSArray? = NSUserDefaults.standardUserDefaults().objectForKey("cnaCoreData") as? NSArray
        var datCna: NSMutableDictionary = [:]
        if datList != nil {
            datCna = datList![datRow] as! NSMutableDictionary
        }
        var msFeeInt = datCna.objectForKey("membershipFee") as! Int
        if (msFeeInt == 0){
            
        }
        
        //if fee = free
        //Add him to that cna
        
        if msFeeInt != 0 {
            let amount = NSDecimalNumber(integer: msFeeInt)
            var payment = PayPalPayment()
            payment.amount = amount
            payment.currencyCode = "AUD"
            payment.shortDescription = "Swift payment"
            
            if (!payment.processable) {
                println("You messed up!")
            } else {
                println("THis works")
                var paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
                self.presentViewController(paymentViewController, animated: false, completion: nil)
            }
        }else{
            //add him to member, modified the join state, update the userinfo in cloud, and update the list
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var datRow = delegate.selectedRow as Int
        
        //get value from temp list
        var datCna: cnaTableItem = tCMI1.tableItems[datRow]
        
        //linking works
        cnaName.text = datCna.name
        profilePhoto.image = UIImage(data: datCna.picture)
        cnaTitle.title = datCna.name
        var displayTags = ""
        //for item in (datCna.orgTag as NSArray){displayTags += ((item as String) + ",")}
        //var finalString:String = displayTags.substringWithRange(Range<String.Index>(start: advance(displayTags.startIndex, 0), end: advance(displayTags.endIndex, -1)))
        tags.text = displayTags
        var msFee = String(datCna.mFee as Int)
        membershipFee.text = "Membership Fee: \(msFee)"
        var msFor = datCna.mFor as String
        
        switch msFor{
        case "year":
            membershipFor.text = "For: One Year"
        case "semester":
            membershipFor.text = "For: One Semester"
        case "lifetime":
            membershipFee.text = "For: Lifetime"
        default:
            println("display msFor goes wrong")
        }
        
        
        detailDescription.text = datCna.descrip
        uniLabel.text = "ANU"
        
        //paypal preparation
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction :"my-client-id-for-Production", PayPalEnvironmentSandbox : "my-client-id-for-Sandbox"])
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentNoNetwork)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //paypal protocols
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
