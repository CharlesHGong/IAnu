//
//  eventTVC.swift
//  finale1
//
//  Created by Yichen.li on 22/01/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import UIKit


class eventTVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var tableview2: UITableView!
    
    @IBOutlet weak var segControl2: UISegmentedControl!
    
    @IBAction func segControlAction2(sender: UISegmentedControl) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedEventSeg = segControl2.selectedSegmentIndex
        tCMI2.updateList(picSt())
        tableview2.reloadData()
    }
    
    var allEventForCoreStorage:NSMutableArray = []
    
//    // soring buttuon tart
//    var sortedName = true;
//    @IBAction func sortByName(sender: UIButton) {
//        if sortedName == true  {
//            tCMI2.allEvents.sort() {$0.name.capitalizedString < $1.name.capitalizedString};
//            sortedName = false;
//            sortedSize = true;     //reset
//            sortedJoined = true    //reset
//            sortedDate = true;     //reset
//        }
//        else {
//            tCMI2.allEvents.sort() {$0.name.capitalizedString > $1.name.capitalizedString};
//            sortedName = true;
//        }
//        tableview2.reloadData()
//    }
//    var sortedSize = true;
//    @IBAction func sortBySize(sender: UIButton) {
//        if sortedSize == true  {
//            tCMI2.allEvents.sort() {$0.joined > $1.joined};
//            sortedSize = false;
//            sortedName = true;     //reset
//            sortedDate = true;     //reset
//            sortedJoined = true    //reset
//        }
//        else {
//            tCMI2.allEvents.sort() {$0.joined < $1.joined};
//            sortedSize = true;
//        }
//        
//        tableview2.reloadData()
//    }
//    var sortedJoined = true;
//    @IBAction func sortByJoined(sender: UIButton) {
//        if sortedJoined == true  {
//            tCMI2.allEvents.sort() {$0.joinState > $1.joinState};
//            sortedJoined = false;
//            sortedDate = true;     //reset
//            sortedName = true;     //reset
//            sortedSize = true      //reset
//        }
//        else {
//            tCMI1.tableItems.sort() {$0.joinState < $1.joinState};
//            sortedJoined = true;
//        }
//        
//        tableview2.reloadData()
//    }
//    var sortedDate = true;
//    @IBAction func sortedByDate(sender: UIButton) {
//        if sortedDate == true  {
//            //            tCMI1.tableItems.sort() {$0.timeStart > $1.timeStart};
//            sortedDate = false;
//            sortedJoined = true;   //reset
//            sortedSize = true;     //reset
//            sortedName = true      //reset
//        }
//        else {
//            //            tCMI1.tableItems.sort() {$0.date < $1.date};
//            sortedDate = true;
//        }
//        
//        tableview2.reloadData()
//    }
//    //sorting buttuon ends
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (NSUserDefaults.standardUserDefaults().objectForKey("allEventCoreData") == nil){
            println("eventTVC's virgin sex")
            setPicState(false)
            getAllEventList()  //this is for first time
        }else{
            println("eventTVC's several sex")
            tCMI2.updateList(picSt())
            tCMI2.reorder("name", orderOf: ">") //reorder the temporary stored list
            //viewcontroller will automaticlly call reloadData()
        }
        
        var nib = UINib(nibName: "eventTableViewCell", bundle: nil)
        tableview2.registerNib(nib, forCellReuseIdentifier: "eventCell")
//pull to refresh start
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableview2.addSubview(refreshControl)
        //pull to refresh ends
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        segControl2.selectedSegmentIndex = delegate.selectedEventSeg
        
    }
    override func viewDidAppear(animated: Bool) {
        //set tab
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedTab = 1
    }
    
// refresh function start
    func refresh(sender:AnyObject)
    {
        getAllEventList()
    }
//refresh function ends

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //default stored by name
    //all stored in local storage
    func getAllEventList(){
        PFCloud.callFunctionInBackground("currentEventList", withParameters: [:]){
            (result: AnyObject!, error: NSError!) -> Void in
            var pictureCounter = 0
            var pictureList:NSMutableArray = []
            self.allEventForCoreStorage = []
            if error == nil {
                
                var rawArray = result as! NSArray
                var allKeys = rawArray[0].allKeys as! [NSString]
                for var index = 0; index < rawArray.count; ++index{
                    var thatObj = rawArray[index] as! PFObject
                    var allEventForCoreStorageItem:NSMutableDictionary = [:]
                    for key in (allKeys as! [String]){
                        if (key == "eventPicture"){
                            self.setPicState(false) //so if picture is no downloaded successfully, it will not load pic
                            //store picture
                            let eventPicture = thatObj[key] as! PFFile
                            eventPicture.getDataInBackgroundWithBlock {
                                (imageData: NSData!, error: NSError!) -> Void in
                                if error == nil {
                                    pictureList.addObject((imageData as NSData))
                                    if (pictureList.count == rawArray.count) {
                                        //if all pic stored, save the list to picture core data
                                        NSUserDefaults.standardUserDefaults().setObject(pictureList, forKey: "allEventPicCoreData")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        //and then update.
                                        self.setPicState(true)
                                        tCMI2.updateList(self.picSt())
                                        self.tableview2.reloadData()
                                    }
                                }else{
                                    println(error)
                                }
                            }
                            
                        }else if (key == "participants"){
                            //do nothing
                        }else{
                            allEventForCoreStorageItem.setValue(thatObj.valueForKey(key), forKey: key)
                        }
                    }
                    allEventForCoreStorageItem.setValue(thatObj.objectId, forKey: "eventId")
                    self.allEventForCoreStorage.addObject(allEventForCoreStorageItem)
                }
                NSUserDefaults.standardUserDefaults().setObject(self.allEventForCoreStorage, forKey: "allEventCoreData")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                tCMI2.updateList(self.picSt())
                self.refreshControl.endRefreshing()
                self.tableview2.reloadData()
            }else{
                println(error.description)
                println("damnit")
            }
        }
        PFUser.currentUser().fetch()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segControl2.selectedSegmentIndex{
        case 0:
            return tCMI2.myEvents.count
        case 1:
            return tCMI2.allEvents.count
        default:
            return 0
        }
    }
    
    //create a certain cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("cellforRowAtindexPath")
        var selectedSeg = self.segControl2.selectedSegmentIndex
        var cell = self.tableview2.dequeueReusableCellWithIdentifier("eventCell") as! eventTableViewCell
        var datItem = eventTableItem()
        switch selectedSeg{
        case 0:
            datItem = tCMI2.myEvents[indexPath.row]
        case 1:
            datItem = tCMI2.allEvents[indexPath.row]
        default:
            println("tableView cellforrowat indexpath went wrong")
        }
        var timeInput = "timeInput"//(datItem.timeStart + "~" + datItem.timeEnd)
        var joinOMaxInput = (String(datItem.joined) + "/" + String(datItem.capacity))
        //extract from the list
        cell.loadItem(titleIn: datItem.name, imageDt: datItem.picture, descriptionIn: datItem.desc, joinStateIn: datItem.joinState, timeIn: timeInput, addressIn: datItem.address, joinOMax: joinOMaxInput)
        return cell
    }
    
    
    //table selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didselect")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //save selected row for detail page to index
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedRow = indexPath.row
        
        //goto detail page
        let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("eventDetailVC")
        self.showViewController(vc as! UIViewController, sender: vc)
    }
    
    
    
    func setPicState(picState: Bool){
        NSUserDefaults.standardUserDefaults().setObject(picState, forKey: "allEventPicStat")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func picSt() -> Bool{
        var returnVal:Bool = NSUserDefaults.standardUserDefaults().objectForKey("allEventPicStat") as! Bool
        return returnVal
    }
}
