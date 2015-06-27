//
//  testVC.swift
//  finale1
//
//  Created by Yichen.li on 18/01/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit


class testVC: UIViewController {
    @IBOutlet weak var testLabel: UILabel!

    @IBAction func getDate(sender: UIButton) {
        var date = ""
        PFCloud.callFunctionInBackground("allEventList", withParameters: [:]){
            (result: AnyObject!, error: NSError!) -> Void in
            if (result == nil){
                println("asdasdasd")
            }else{
                var array1 = result as! NSArray
                let jsDate = array1[1]["date"]
                
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "HH"// "dd-MM-yyyy"
                var date = dateFormater.stringFromDate(jsDate as! NSDate)
                self.testLabel.text = date
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var trueName: UITextField!
    @IBOutlet weak var uniID: UITextField!
    @IBAction func addAsMember(sender: UIButton) {
        //HUDController.sharedController.contentView = HUDContentView.ProgressView()
        //HUDController.sharedController.show()
        PFCloud.callFunctionInBackground("webAddMember", withParameters: ["holdClass":"ANU_CreAge","membershipFor":"6", "username":username.text, "trueName": trueName.text, "uniID":uniID.text]){
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
          //      HUDController.sharedController.hide(afterDelay: 0)
            }else{
//                HUDController.sharedController.hide(afterDelay: 0)
//                HUDController.sharedController.contentView = HUDContentView.TextView(text: "fail")
//                HUDController.sharedController.show()
//                HUDController.sharedController.hide(afterDelay: 1)
            }
        }
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
