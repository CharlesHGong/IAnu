//
//  eventDetailVC.swift
//  finale1
//
//  Created by Yichen.li on 19/01/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit
import EventKit



class eventDetailVC: UIViewController,PayPalPaymentDelegate {
    
    //paypal
    var config = PayPalConfiguration()
    let newEnvironment = "live"
    var acceptCreditCards: Bool = true
    var environment:String = "live"
    
    
    
    @IBOutlet weak var eventTitle: UINavigationItem!
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var joined: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var holdBy: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var joinButton: UIButton!
    
    @IBAction func join(sender: UIButton) {
        var datEvent = getDatEvent()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        let date:NSDate = dateFormatter.dateFromString("2015-06-28 15:36:00 +1000")!
        

        //if join, prompt for pay and price, then if yes, go to paypal if paypal yes, then setstatus.
        //if paynow, prompt for pay and price, samo
        //if Joined, no reaction.
        
        switch (joinButton.titleLabel!.text!){
        case "Join":
            areYouSure(datEvent.fee, eventIdIn: datEvent.eventID, userIdIn: PFUser.currentUser().objectId)
        case "Pay Now":
            payAlert(datEvent.fee, eventIdIn: datEvent.eventID, userIdIn: PFUser.currentUser().objectId)
        case "Set reminder":
            let todoItem = TodoItem(eventName: datEvent.name, eventDate: date, eventStartTime: date, eventLocation: datEvent.address, UUID: "1111")
            TodoList.sharedInstance.addItem(todoItem)
            
            
//            println("reminder not done yet!")
//            var eventStore : EKEventStore = EKEventStore()
//            // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
//            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
//                granted, error in
//                if (granted) && (error == nil) {
//                    println("granted \(granted)")
//                    println("error  \(error)")
//                    
//                    var event:EKEvent = EKEvent(eventStore: eventStore)
//                    event.title = "Test Title"
//                    event.startDate = NSDate()
//                    event.endDate = NSDate()
//                    event.notes = "This is a note"
//                    event.calendar = eventStore.defaultCalendarForNewEvents
//                    eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
//                    println("Saved Event")
//                }
//            })
        default:
            println("datJoinButton")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        var datEvent = getDatEvent()
        
        //all the linking works
        eventName.text = datEvent.name
        eventPic.image = UIImage(data:datEvent.picture)
        eventTitle.title = datEvent.name
        capacity.text = String(datEvent.capacity)
        joined.text = String(datEvent.joined)
        date.text = "21-1-2015"
        time.text = "9pm-11pm"
        if datEvent.fee == 0 {
            fee.text = "Fee:     Free"
            fee.textColor = UIColor(red: CGFloat(126.0/255.0), green: CGFloat(211.0/255.0), blue: CGFloat(33.0/255.0), alpha: CGFloat(1.0));
        }else{
            fee.text = "Fee:     AUD\(String(datEvent.fee))"
            //fee.textColor = UIColor(red: CGFloat(208/255), green: CGFloat(2/255), blue: CGFloat(27/255), alpha: CGFloat(0.8))
            fee.textColor = UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(0.8))
        }
        location.text = datEvent.address
        holdBy.text = datEvent.holdBy
        eventDescription.text = datEvent.desc
        
        //set notification
        
        
        //Paypal 
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction :"AQR4oJSzSoOjoYJljJmTnOabtpDnMWTa6qBWdRfPMeflFvizgfQKLzqeijZuXjP0lWiLtV_5BZVwkzRB", PayPalEnvironmentSandbox : "my-client-id-for-Sandbox"])
        PayPalMobile.preconnectWithEnvironment(environment)
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "IUNI.Ltd."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0] as! String
        // paypal

    }
    
    override func viewWillAppear(animated: Bool) {
        var datEvent = getDatEvent()
        var events = PFUser.currentUser().objectForKey("events") as! NSArray
        for (index1, event) in enumerate(events){
            if ((event[0] as! String) == (datEvent.eventID as String)){
                
                switch (event[1] as! String){
                case "Notpaid":
                    println("")
                case "Paid":
                    println("in paid")
                    self.joinButton.setTitle("Set reminder", forState:UIControlState.Normal)
                    self.joinButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    self.joinButton.backgroundColor = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(239.0/255.0), blue: CGFloat(22.0/255.0), alpha: CGFloat(255.0/255.0))
                case "Past":
                    println("past event")
                default:
                    println("")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func areYouSure(fee: Int, eventIdIn:String, userIdIn:String){
        let alertController = UIAlertController(title: "", message: "The attendance fee for this event is \(toString(fee))AUD, do you want to join?",preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Join", style: .Default, handler: {(action: UIAlertAction!) in
            if (fee == 0){
                self.paying(fee, eventId: eventIdIn, userId: userIdIn);
            }else{
                self.payAlert(fee, eventIdIn: eventIdIn, userIdIn: userIdIn);
            };
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{(action: UIAlertAction!) in}))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func test(){
        let alertController = UIAlertView.alloc()
    }
    
    func payAlert(feeIn: Int, eventIdIn: String, userIdIn:String){
        let alertController = UIAlertController(title: "Pay Now", message: "Would you like to go to paypal now？", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Pay", style: .Default, handler: {
            (action:UIAlertAction!) in
            self.paying(feeIn, eventId: eventIdIn, userId: userIdIn)
            }))
        alertController.addAction(UIAlertAction(title: "Later", style: .Default, handler:{
            (action:UIAlertAction!) in
            self.alertMessage("You will need to either pay in this app or later during the event");
            println("Back to last page, but set it to applied");
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertMessage(messageIn: String){
        let alertController = UIAlertController(title: "", message: messageIn, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(action: UIAlertAction!) in
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func paying(fee:Int, eventId: String, userId:String){
        //free
        if (fee == 0){
            PFCloud.callFunctionInBackground("setUserEventStatus", withParameters: ["eventId":eventId, "userId":userId, "newStatus":"Paid"]){
                (result: AnyObject!, error: NSError!) -> Void in
                if (error == nil){
                    println("reminder me")
                    self.alertMessage("Joined")
                    self.joinButton.setTitle("Set reminder", forState:UIControlState.Normal)
                    self.joinButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    self.joinButton.backgroundColor = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(239.0/255.0), blue: CGFloat(22.0/255.0), alpha: CGFloat(255.0/255.0))
                    //update local
                    PFUser.currentUser().fetch()
                }else{}
            }
        }else{
            //go to payapl, if payed, setstatus
            Paypal(fee)
        }
    }
    
    
    
    
    
    // MARK: Single Payment
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    
    func Paypal(feeInt:Int) {
        
        
        
        // Remove our last completed payment, just for demo purposes.
        resultText = ""
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        let fee = NSDecimalNumber (string:String(feeInt));
        
        var item1 = PayPalItem(name: "Attendence fee for events", withQuantity: 1, withPrice: fee, withCurrency: "AUD", withSku: "Hip-0037")
        let items = [item1]
        let subtotal = PayPalItem.totalPriceForItems(items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0")
        let tax = NSDecimalNumber(string: "0")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "AUD", shortDescription: "iUni", intent: .Sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            println("Payment not processalbe: \(payment)")
        }
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
        // cancelled
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            // send completed confirmaion to your server
            var datEvent = self.getDatEvent()
            PFCloud.callFunctionInBackground("setUserEventStatus", withParameters: ["eventId":datEvent.eventID, "userId":PFUser.currentUser().objectId, "newStatus":"Paid"]){
                (result: AnyObject!, error: NSError!) -> Void in
                if (error == nil){
                    self.alertMessage("Joined")
                    self.joinButton.setTitle("Set reminder", forState:UIControlState.Normal)
                    self.joinButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    self.joinButton.backgroundColor = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(239.0/255.0), blue: CGFloat(22.0/255.0), alpha: CGFloat(255.0/255.0))
                    //update local
                    PFUser.currentUser().fetch()
                }else{}
            }
        })
    }
    
    // Paypal ends
    
    
    func getDatEvent() -> eventTableItem{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var datRow = delegate.selectedRow as Int
        var datSeg = delegate.selectedEventSeg as Int
        var datEvent = eventTableItem()
        switch datSeg{
        case 0:
            datEvent = tCMI2.myEvents[datRow]
        case 1:
            datEvent = tCMI2.allEvents[datRow]
        default:
            println("getDatEvent wrong")
        }
        return datEvent
    }

    
}



