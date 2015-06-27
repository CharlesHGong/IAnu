//
//  tViewController1.swift
//  finale1
//
//  Created by Yichen.li on 22/12/2014.
//  Copyright (c) 2014 libra34567. All rights reserved.
//

//talbeview
//https://www.weheartswift.com/swifting-around/
//switch view programmably
//http://stackoverflow.com/questions/24336581/programmatically-switching-views-swift
//menu
//https://github.com/evnaz/ENSwiftSideMenu



import UIKit

class cnaTVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func segContolAction(sender: UISegmentedControl) {
        var selectedSeg = segControl.selectedSegmentIndex
        tCMI1.updateList(selectedSeg, pictureGot: picSt(selectedSeg))
        tableView.reloadData()
    }
    @IBOutlet var tableView: UITableView!
//    @IBAction func refresh(sender: UIButton) {
//        println("refresh")
//        switch segControl.selectedSegmentIndex{
//        case 0:
//            getCnaList();   // the default order is always name
//        case 1:
//            getRsttList();  //getXXList will update the tableitems, and then reload the table
//        default:
//            println("refresh went wrong");
//        }
//    }
    
//    @IBAction func sortByName(sender: UIButton) {
//        tCMI1.reorder("name", orderOf: ">")
//        tableView.reloadData()
//    }
//    @IBAction func sortBySize(sender: UIButton) {
//        tCMI1.reorder("size", orderOf: ">")
//        tableView.reloadData()
//    }
//    @IBAction func sortByJoined(sender: UIButton) {
//        tCMI1.reorder("joined", orderOf: ">")
//        tableView.reloadData()
//    }
    
    
    
    // soring buttuon tart
    var sortedName = true;
    @IBAction func sortByName(sender: UIButton) {
        if sortedName == true  {
            tCMI1.tableItems.sort() {$0.name.capitalizedString < $1.name.capitalizedString};
            sortedName = false;
            sortedSize = true;     //reset
            sortedJoined = true    //reset
            sortedDate = true;     //reset
        }
        else {
            tCMI1.tableItems.sort() {$0.name.capitalizedString > $1.name.capitalizedString};
            sortedName = true;
        }
        tableView.reloadData()
    }
    var sortedSize = true;
    @IBAction func sortBySize(sender: UIButton) {
        if sortedSize == true  {
            tCMI1.tableItems.sort() {$0.size > $1.size};
            sortedSize = false;
            sortedName = true;     //reset
            sortedDate = true;     //reset
            sortedJoined = true    //reset
        }
        else {
            tCMI1.tableItems.sort() {$0.size < $1.size};
            sortedSize = true;
        }
        
        tableView.reloadData()
    }
    
    var sortedJoined = true;
    @IBAction func sortByJoined(sender: UIButton) {
        if sortedJoined == true  {
            tCMI1.tableItems.sort() {$0.joinState > $1.joinState};
            sortedJoined = false;
            sortedDate = true;     //reset
            sortedName = true;     //reset
            sortedSize = true      //reset
        }
        else {
            tCMI1.tableItems.sort() {$0.joinState < $1.joinState};
            sortedJoined = true;
        }
        
        tableView.reloadData()
    }
    var sortedDate = true;
    @IBAction func sortedByDate(sender: UIButton) {
        if sortedDate == true  {
            //            tCMI1.tableItems.sort() {$0.timeStart > $1.timeStart};
            sortedDate = false;
            sortedJoined = true;   //reset
            sortedSize = true;     //reset
            sortedName = true      //reset
        }
        else {
            //            tCMI1.tableItems.sort() {$0.date < $1.date};
            sortedDate = true;
        }
        
        tableView.reloadData()
    }
    //sorting buttuon ends
    

    
    
    
    
    
    
    
    
    
    
    var cnaForCoreStorage:NSMutableArray = []
    var rsttForCoreStorage:NSMutableArray = []
    
    override func viewWillAppear(animated: Bool) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.tabBarController?.selectedIndex = delegate.selectedTab
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if (NSUserDefaults.standardUserDefaults().objectForKey("cnaCoreData") == nil){
            println("cnaTVC's virgin sex")
            //so when segAction trigger load, it will not load pic at its virgin sex
            setPicState(0, picState: false)
            setPicState(1, picState: false)
            getCnaList()  //this is for first time
        }else{
            println("cnaTVC's several sex")
            tCMI1.updateList(0, pictureGot: picSt(0))
            tCMI1.reorder("name", orderOf: ">") //reorder the temporary stored list
            //viewcontroller will automaticlly call reloadData()
        }
        
        //register the cell //intial with cna
        var nib = UINib(nibName: "cnaTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cnaCell")
        
        
        
//pull to refresh start
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
//pull to refresh ends
    }
    
    override func viewDidAppear(animated: Bool) {
        //set tab
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedTab = 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("warning")
    }
    
    
    // refresh function start
    func refresh(sender:AnyObject)
    {
            getCnaList();
    }
    //refresh function ends
    
    
    
    // UITableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("#OfRowInSection")
        return tCMI1.tableItems.count
    }
    //create a certain cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("cellforRowAtindexPath")
        //var selectedSeg = self.segControl.selectedSegmentIndex
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cnaCell") as! cnaTableViewCell
        
        //extract from the list
        var thatItem = tCMI1.tableItems[indexPath.row]
        cell.loadItem(titleIn: thatItem.name, imageDt: thatItem.picture, joinStateIn: thatItem.joinState, sizeIn: thatItem.size)
        return cell
    }
    //table selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didselect")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //save selected row for detail page to index
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedRow = indexPath.row
        
        //to detail page
        let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("cnaDetailVC")
        self.showViewController(vc as! UIViewController, sender: vc)
    }

    //store PFCloud items into persistant storage
    //update the tableItems
    //reload table
    //when pictures all loaded. 
    //update the tableitems again
    //reload table
    func getCnaList(){
        println("getCnaList")
        //PFFunction take time, and the outer function will finsih the rest first
        PFCloud.callFunctionInBackground("sortedCnaList", withParameters: [:]){
            (result: AnyObject!, error: NSError!) -> Void in
            self.cnaForCoreStorage = []
            if error == nil {
                //result structure, list of [object]
                var pictureDict:NSMutableDictionary = [:]
                var rawArray = result as! NSArray
                var allKeys: [NSString] = rawArray[0].allKeys as! [NSString]
                for var index = 0; index < rawArray.count; ++index{
                    //these two must be here since NSArray addobject as reference
                    var thatObj: PFObject = rawArray[index] as! PFObject
                    var cnaForCoreStorageItem:NSMutableDictionary = [:]
                    for key in allKeys{
                        if (key == "profilePhoto"){
                            self.setPicState(0,  picState: false)
                            //so if picture is no downloaded successfully, it will not load pic
                            
                            let profilePhoto = thatObj[key as String] as! PFFile
                            profilePhoto.getDataInBackgroundWithBlock {
                                (imageData: NSData!, error: NSError!) -> Void in
                                if error == nil {
                                    pictureDict[(thatObj.valueForKey("username") as! String)] = imageData as NSData
                                    if (pictureDict.count == rawArray.count) {  // all picture stored
                                        //save the list to picture core data
                                        NSUserDefaults.standardUserDefaults().setObject(pictureDict, forKey: "cnaPicCoreData")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        //and then update.
                                        self.setPicState(0, picState: true)
                                        tCMI1.updateList(0, pictureGot: self.picSt(0))
                                        self.tableView.reloadData()
                                    }
                                }else{
                                    println(error)
                                }
                            }
                        }else{
                            cnaForCoreStorageItem.setValue(thatObj.valueForKey(key as String), forKey: key as String)
                        }
                    }
                    self.cnaForCoreStorage.addObject(cnaForCoreStorageItem)
                }
                NSUserDefaults.standardUserDefaults().setObject(self.cnaForCoreStorage, forKey: "cnaCoreData")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                tCMI1.updateList(0,pictureGot: self.picSt(0))  //this need to be done within PF function, so it will only update when the persistant storage is refreshed.
                self.refreshControl.endRefreshing()
                self.tableView.reloadData() //to refresh the tablevivew to display,
            }else{
                println(error.description)
                println("damnit")
            }
        }
        println("end of getCnaList")
    }
    func getRsttList(){};
    


    
    
    
    func setPicState(selectedSeg: Int, picState: Bool){
        var forKey = String()
        switch selectedSeg{
        case 0:
            forKey = "cnaPicStat"
        case 1:
            forKey = "rsttPicStat"
        default:
            println("set pic stat went wrong")
        }
        NSUserDefaults.standardUserDefaults().setObject(picState, forKey: forKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    func picSt(selectedSeg: Int) -> Bool{
        var returnVal = Bool()
        switch selectedSeg{
        case 0:
            returnVal = NSUserDefaults.standardUserDefaults().objectForKey("cnaPicStat") as! Bool
        case 1:
            returnVal = NSUserDefaults.standardUserDefaults().objectForKey("rsttPicStat") as! Bool
        default:
            println("sth wrong with the get picstat")
        }
        return returnVal
    }
    
}
