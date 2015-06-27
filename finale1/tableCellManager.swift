//http://www.csdn123.com/html/topnews201408/58/2858.htm


//explaination for PFFunction
//1. update from server, and store into UserDefault
//2. update the temporary stored tableItems. using updateList which use storedCnaLen()
//3. call tableView.reload() to reload the updated tableItems List  //which will then call #OfRowInSection to load the items one by one


import UIKit

var tCMI1: tableCellManager1 = tableCellManager1()
var tCMI2: tableCellManager2 = tableCellManager2()

class tableCellManager1: NSObject {
    var tableItems = [cnaTableItem]()
    
    //update the whole list, depends on which is seg selceted
    func updateList(selectedSegment: Int, pictureGot: Bool){
        tableItems = []
        for i in 0..<storedTableitemsLen(selectedSegment){
            tableItems.append(storedTableDetail(i, selectedSegmentN: selectedSegment, pictureGot: pictureGot))
        }
    }
    
    
    
    
    func recnaTableItem(sortBy: String){
        if (sortBy == "name"){
            func byTableName(n1: cnaTableItem, n2: cnaTableItem) -> Bool {
               return  n1.name > n2.name;
                            }
            sorted(tableItems, byTableName)
        }else if (sortBy == "joinState"){
            func byTableJoin(n1: cnaTableItem, n2: cnaTableItem) -> Bool{
                if (n1.joinState == n2.joinState){
                    return true;
                }else if(n1.joinState == "Joined"){
                    return true;
                }else if(n1.joinState == "applied"){
                    if (n1.joinState == "Null"){
                        return true;
                    }else{
                        return false;
                    }
                }else{
                    return false;
                }
            }
            sorted(tableItems, byTableJoin);
        }else if (sortBy == "size"){
            func byTableSize(n1: cnaTableItem, n2: cnaTableItem) -> Bool {
                return (n1.size < n2.size);
            }
            sorted(tableItems, byTableSize);
            for item in tableItems {
                println(item.name)
            }
        }else if (sortBy == "fee"){
            func byTableFee(n1: cnaTableItem, n2: cnaTableItem) -> Bool {
                return n1.mFee < n2.mFee;
            }
            sorted(tableItems, byTableFee);
        }
    }
    
    func reorder(sortBy: String, orderOf: String){
        recnaTableItem(sortBy);
//        for item in tableItems {
//            println(item.name)
//        }
//        if (orderOf == "<"){
//            recnaTableItem(sortBy);
//        }else{
//            recnaTableItem(sortBy);
//            for item in tableItems {
//                println(item.name)
//            }
//            tableItems.reverse();
//        }
    }
    
    func storedTableitemsLen(selectedSegment: Int) -> Int {
        
        var datList:NSArray?
        
        switch selectedSegment{
        case 0://cna
            datList = NSUserDefaults.standardUserDefaults().objectForKey("cnaCoreData") as? NSArray
        case 1:
            datList = NSUserDefaults.standardUserDefaults().objectForKey("rsttCoreData") as? NSArray
        default:
            datList = []
        }
        
        if datList != nil {
            return datList!.count
        }else{
            return 0
        }
    }
    
    func storedTableDetail(index: Int, selectedSegmentN:Int, pictureGot:Bool) -> cnaTableItem {
        var datList: NSArray = []
        var tableItemInst = cnaTableItem()
        switch selectedSegmentN{
        case 0://cna
            datList = NSUserDefaults.standardUserDefaults().objectForKey("cnaCoreData") as! NSArray
            var returnTitle = datList[index]["username"] as!String
            var returnImageDt = NSData()
            if pictureGot {
                returnImageDt = (NSUserDefaults.standardUserDefaults().objectForKey("cnaPicCoreData") as! [String: NSData])[returnTitle] as NSData!
            }
            println(1)
            var returnSize = datList[index]["size"] as! Int
            println(2)
            var returnJoinState = "Null"//datList[index]["joinState"] as String
            println(3)
            var returnDescrip = datList[index]["pubDescrip"] as! String
            println(4)
            var returnUni = datList[index]["uni"] as! String
            println(5)
            var returnMFor = datList[index]["membershipFor"] as! String
            println(6)
            var returnMFee = datList[index]["membershipFee"] as! Int
            println(7)
            var returnTag = []//datList[index]["orgTag"] as NSMutableArray
            println(8)
            var returnHoldClass = datList[index]["holdClass"] as! String
            println(9)
            tableItemInst = cnaTableItem(name: returnTitle, picture: returnImageDt, joinState: returnJoinState, size: returnSize, descrip: returnDescrip, uni: returnUni, mFor: returnMFor, mFee: returnMFee, orgTag: returnTag, holdClass: returnHoldClass)
        default:
            println("sth wrong with storedTableDetail");
        }
        return tableItemInst
    }
    
}



class tableCellManager2: NSObject {
    var allEvents = [eventTableItem]()
    var myEvents = [eventTableItem]()
    
    //will auto generate the tCMI3 list when updating the list
    func updateList(pictureGot: Bool){
        allEvents = []
        myEvents = []
        //the holdClass list of my communities
        var myHoldClasses:[String] = []
        for item in tCMI1.tableItems{
            if (item.joinState == "Paid"){
                myHoldClasses.append(item.holdClass)
            }
        }
        for i in 0..<storedTableitemsLen(){
            var itemDetail = storedTableDetail(i, pictureGot: pictureGot)
            
            //real code here
//            for holdClass in myHoldClasses{
//                if (itemDetail.holdBy == "ANU_CreAge"){
//                    myEvents.append(itemDetail)
//                }
//            }
            //end of real code
            
            //e.g.
            if (itemDetail.holdBy == "ANU_CreAge"){
                myEvents.append(itemDetail)
            }
            //end of example
            
            
            allEvents.append(itemDetail)
        }
    }
    //reorder
    func reEventTableItem(sortBy: String){
        if (sortBy == "name"){
            func byTableName(n1: eventTableItem, n2: eventTableItem) -> Bool {
                func byName(n1: String, n2: String) -> Bool {return n1 < n2;}
                return byName(n1.name, n2.name);
            }
            sorted(allEvents, byTableName)
        }else if (sortBy == "joinState"){
            func byTableJoin(n1: eventTableItem, n2: eventTableItem) -> Bool{
                if (n1.joinState == n2.joinState){
                    return true;
                }else if(n1.joinState == "Joined"){
                    return true;
                }else if(n1.joinState == "applied"){
                    if (n1.joinState == "Null"){
                        return true;
                    }else{
                        return false;
                    }
                }else{
                    return false;
                }
            }
            sorted(allEvents, byTableJoin);
        }else if (sortBy == "size"){
            func byTableSize(n1: eventTableItem, n2: eventTableItem) -> Bool {
                return (n1.capacity - n1.capacity) < (n2.capacity - n2.capacity);
            }
            sorted(allEvents, byTableSize);
        }else if (sortBy == "fee"){
            func byTableFee(n1: eventTableItem, n2: eventTableItem) -> Bool {
                return n1.fee < n2.fee;
            }
            sorted(allEvents, byTableFee);
        }
    }

    //reorder 2?
    func reorder(sortBy: String, orderOf: String){
        if (orderOf == "<"){
            reEventTableItem(sortBy);
        }else{
            reEventTableItem(sortBy);
            allEvents.reverse();
        }

    }
    
    func storedTableitemsLen() -> Int {
        var datList:NSArray? = []
        datList = NSUserDefaults.standardUserDefaults().objectForKey("allEventCoreData") as? NSArray
        return datList!.count
    }
    
    //index of the
    func storedTableDetail(index: Int, pictureGot:Bool) -> eventTableItem {
        var datList: NSArray = []
        var tableItemInst = eventTableItem()
        
        datList = NSUserDefaults.standardUserDefaults().objectForKey("allEventCoreData") as! NSArray
        var returnTitle = datList[index]["eventName"] as! String
        var returnImageDt = NSData()
        if pictureGot {
            returnImageDt = (NSUserDefaults.standardUserDefaults().objectForKey("allEventPicCoreData") as! [NSData])[index] as NSData
        }
        var returnJoined = datList[index]["joined"] as! Int
        var returnCapacity = datList[index]["capacity"] as! Int
        var returnJoinState = "Null"//datList[index]["joinState"] as String
        var returnDescrip = datList[index]["pubDescrip"] as! String
        var returnDate = datList[index]["date"] as! NSDate
        var returnFee = datList[index]["fee"] as! Int
        var returnTimeS = datList[index]["timeStart"] as! NSDate
        var returnTimeE = datList[index]["timeEnd"] as! NSDate
        var returnAddress = datList[index]["location"] as! String
        var returnHoldBy = datList[index]["hostBy"] as! String
        var returnEventID = datList[index]["eventId"] as! String
        tableItemInst = eventTableItem(eventID: returnEventID, name: returnTitle, capacity: returnCapacity, joined: returnJoined, date: returnDate, timeStart: returnTimeS, timeEnd: returnTimeE, fee: returnFee, address: returnAddress, holdBy: returnHoldBy, desc: returnDescrip, picture: returnImageDt, joinState: returnJoinState)
        
        return tableItemInst
    }
    
}

struct cnaTableItem {
    var name = "Un-Named" //CNA: C&A name
    var picture = NSData()      //same as above
    var joinState = "Null" //either "Paid"/"Notpaid"/"Null"
    var size = 0  //CNA: "Int"
    var descrip = "undescribed"
    var uni = "Un-defined"
    var mFor = "Un-defined"
    var mFee = 0
    var orgTag = []
    var holdClass = "Un-defined"
}

struct eventTableItem {
    var eventID = "Un-Known"
    var name = "Un-Named" //event name
    var capacity = 0
    var joined = 0
    var date = NSDate()
    var timeStart = NSDate()
    var timeEnd = NSDate()
    var fee = 0
    var address = ""
    var holdBy = ""
    var desc = "Un-Described"
    var picture = NSData()
    var joinState = "Null" //Paid Notpaid Null
}


class cnaTableViewCell : UITableViewCell {
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet weak var joinState: UIImageView!
    
    func loadItem(#titleIn: String, imageDt: NSData, joinStateIn: String, sizeIn: Int) {
        profilePhoto.image = UIImage(data: imageDt)
        titleLabel.text = titleIn
        sizeLabel.text = "Community Size: \(String(sizeIn))"
        if joinStateIn == "Null"{
            let color: UIColor = UIColor(red: CGFloat(151.0/255.0), green: CGFloat(151.0/255.0), blue: CGFloat(151.0/255.0), alpha: CGFloat(0.5) )
            joinState.backgroundColor = color
        }else if (joinStateIn == "Applied"){
            joinState.backgroundColor = UIColor(red: CGFloat(208.0/255.0), green: CGFloat(2.0/255.0), blue: CGFloat(27.0/255.0), alpha: CGFloat(0.4) )
        }else if (joinStateIn == "Joined"){
            joinState.backgroundColor = UIColor(red: CGFloat(126.0/255.0), green: CGFloat(211.0/255.0), blue: CGFloat(33.0/255.0), alpha: CGFloat(0.4) )
        }
    }
}

class eventTableViewCell : UITableViewCell {
    @IBOutlet var eventPhoto: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var descripText: UITextView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var jomLabel: UILabel!
    @IBOutlet var joinedStateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //@IBOutlet weak var backgroundView: UIView!
    
    func loadItem(#titleIn: String, imageDt: NSData, descriptionIn: String, joinStateIn: String, timeIn:String, addressIn:String, joinOMax: String) {
        eventPhoto.image = UIImage(data: imageDt)
        eventPhoto.layer.shadowColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.5)).CGColor
        eventPhoto.layer.shadowOffset = CGSize(width: 1, height: 0)
        eventPhoto.layer.shadowRadius = CGFloat(4.0)
        
        titleLabel.text = titleIn
        dateLabel.text = timeIn
        descripText.text = descriptionIn
        joinedStateLabel.text = joinStateIn
        addressLabel.text = addressIn
        jomLabel.text = joinOMax
    }
}
