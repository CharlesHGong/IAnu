//
//  tViewController2.swift
//  finale1
//
//  Created by Yichen.li on 30/12/2014.
//  Copyright (c) 2014 libra34567. All rights reserved.
//


import UIKit
import Foundation
import AVFoundation
import LocalAuthentication
class qrVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    //QR scanner setup
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var cnaButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 56))
    var eventButton:UIButton = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.width, y: 0, width: UIScreen.mainScreen().bounds.width, height: 56))
    
    //for qrcode
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var myQR: UILabel!
    @IBAction func torch(sender: UIButton) {
        //toggleFlash()
        hideCam()
    }
    @IBOutlet weak var switchOutlet: UIButton!
    @IBAction func switchBtn(sender: UIButton) {
        if (imageView.image == nil) {   //go to QR
            self.session.stopRunning()
            layer!.hidden = true
            //myQR.hidden = false
            //labelOnBlur.hidden = true
            
            var currentUser = PFUser.currentUser()
            if currentUser != nil {
                imageView.image = {
                    CGSize(width: self.imageView.bounds.width, height: self.imageView.bounds.height)
                    var qrCode = QRCode("EndUr:\(currentUser.objectId)")!
                    qrCode.size = self.imageView.bounds.size
                    return qrCode.image
                    }()
                switchOutlet.setImage(UIImage(named: "camera"), forState: .Normal);
            }
        }else{  // go to camera
            imageView.image = nil
            //myQR.hidden = true
            switchOutlet.setImage(UIImage(named: "account"), forState: .Normal)
            self.setupCamera()
        }
    }
    
    @IBAction func signout(sender: UIButton) {
        PFUser.logOut()
        let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("loginID")
        self.showViewController(vc as! UIViewController, sender: vc)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //self.title = "QRscan"
        //make that imageview
        //let imageView = UIImageView(frame:CGRectMake(10, 140, 300, 300))
        //self.view.addSubview(imageView)
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            imageView.image = {
                CGSize(width: 375, height: 375)
                var qrCode = QRCode("EndUr:\(currentUser.objectId)")!
                qrCode.size = self.imageView.bounds.size
                return qrCode.image
                }()
            switchOutlet.setTitle("Scan", forState: UIControlState.Normal)
        } else {
            // Show the signup or login screen
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //labelOnBlur.hidden = true
        
    }
    override func viewDidDisappear(animated: Bool) {
        self.session.stopRunning()
    }
    
    
    
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if (error != nil) {
            println(error?.code)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(0, 0,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height-49); //49 is the height of the tabbar
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    func hideCam(){
        session.stopRunning()
        layer!.hidden = true;
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        var stringValue:String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        scanResponse(stringValue!, uniIn: "ANU", cnaName: "CreAge")
        
        //alert!!!
        //var alertView = UIAlertView()
        //alertView.delegate=self
        //alertView.title = "QRCode"
        //alertView.message = "scanned info:\(stringValue)"
        //alertView.addButtonWithTitle("confirm")
        //alertView.show()
    }
    //maybe only add reference of the user in users to community class, and as there member?, so that the ID can be the same
    
    
    
    func scanResponse(scanResult: String, uniIn: String, cnaName: String) {
        var first6Chars = ""
        if count(scanResult) >= 6 {
            first6Chars = scanResult.substringToIndex(advance(scanResult.startIndex, 6))
        }
        //check if url
//        if var scannedUrl = NSURL(string: scanResult) {
//            println("horray for valid url!")
//            UIApplication.sharedApplication().openURL(scannedUrl)
//            
        if (first6Chars == "EndUr:"){
            //if user
            var userIDIn = scanResult.substringWithRange(Range<String.Index>(start: advance(scanResult.startIndex, 6), end: advance(scanResult.endIndex, 0))) //"llo, playgroun"
            PFCloud.callFunctionInBackground("scanRenewMembership", withParameters: ["ID": userIDIn, "uni": uniIn, "cnaName": cnaName]){
                (result: AnyObject!, error: NSError!) -> Void in
                println(result)
                if error == nil {
                    var resultVal = result as! String
                    if (resultVal == "new"){   //new member
                        self.alertWindow("Succeed!", messageIn: "New Member Added", actionTitle: "Got it")
                    }else if (resultVal == "renew"){ //member ship renewed
                        self.alertWindow("Succeed", messageIn: "Membership Renewed", actionTitle: "Got it")
                    }
                }else{
                    println("damn")
                }
            }
        }else if (first6Chars == "Group:"){
            //if cna
            var cnaName1 = scanResult.substringWithRange(Range<String.Index>(start: advance(scanResult.startIndex, 6), end: advance(scanResult.endIndex, 0)))
            //find which cna is it
            for (index1,cna) in enumerate(tCMI1.tableItems){
                if (cna.name ==  cnaName1){
                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.selectedRow = index1
                    break
                }
            }
            
            //save the current tab index before going to the detail page
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.selectedTab = 2
            
            //go to that cna detail page
            let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("cnaDetailVC")
            self.showViewController(vc as! UIViewController, sender: vc)
        }else if (first6Chars == "Event:"){
            //if event
            //go to event detail page
            var eventName1 = scanResult.substringWithRange(Range<String.Index>(start: advance(scanResult.startIndex, 6), end: advance(scanResult.endIndex, 0)))
            for (index2,event) in enumerate(tCMI2.allEvents){
                if (event.name ==  eventName1){
                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.selectedRow = index2
                    break
                }
            }
            //go to that cna detail page
            let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("eventDetailVC")
            self.showViewController(vc as! UIViewController, sender: vc)
            
        }else if (first6Chars == "_Rstt:"){
            //go to restaruant detail page
        }else if (first6Chars == "RsttE:"){   //rstt events
            //got to rstt event
        }else{
            self.alertWindow("Unknown Info", messageIn: scanResult, actionTitle: "Got it")
        }
    }
    
    
    func alertWindow(titleIn: String, messageIn: String, actionTitle: String){
        let alertController = UIAlertController(title: titleIn, message: messageIn, preferredStyle: UIAlertControllerStyle.Alert)
        //alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Got it", style: .Default, handler: { (action: UIAlertAction!) in
            self.setupCamera();
        }));
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
            } else {
                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }
    }
}


