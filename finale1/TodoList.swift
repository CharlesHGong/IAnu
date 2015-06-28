//
//  TodoList.swift
//  finale1
//
//  Created by GongHanning on 28/06/2015.
//  Copyright (c) 2015 libra34567. All rights reserved.
//

import Foundation

//notification
struct TodoItem {
    var eventName:String = "Default"
    var eventDate :NSDate = NSDate()
    var eventStartTime: NSDate = NSDate()
    var eventLocation:String = "Default"
    var UUID:String = "1111"
}
private let ITEMS_KEY = "todoItems"

class TodoList {
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    func addItem(item:TodoItem) {
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: item.eventDate)
        let hour = comp.hour
        let minute = comp.minute
        
        todoDictionary[item.UUID] = ["eventName":item.eventName,"eventDate":item.eventDate,"eventLocation":item.eventLocation] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "\(item.eventName) is happenning in \(item.eventLocation) at \(hour):\(minute) today" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.eventDate // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        println(item.eventDate)
    }

}

