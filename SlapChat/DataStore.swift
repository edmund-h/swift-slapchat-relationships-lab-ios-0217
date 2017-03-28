//
//  DataStore.swift
//  SlapChat
//
//  Created by Ian Rahman on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    static let sharedInstance = DataStore()
    /*fileprivate*/ var messages: [Message] = []
    var users: [User] = []
    static var dateFormatter = DateFormatter()
    
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SlapChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData () {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        do{
            messages = try context.fetch(fetchRequest)
            sortMessages()
        }catch{}
        
    }
    
    func addMessage(content: String, date: Date){
        let message = Message(context: self.persistentContainer.viewContext)
        message.content = content
        let messageDate = date as NSDate
        message.createdAt = messageDate
        messages.append(message)
        sortMessages()
    }
    
    func getMessage(at index: Int)-> Message{
        return messages[index]
    }
    
    func getMessageCount()-> Int{
        return messages.count
    }
    
    func sortMessages(){
        
        messages.sort(by: {
            guard let date1 = $0.createdAt else {return false}
            guard let date2 = $1.createdAt else {return true}
            return date1.timeIntervalSinceNow < date2.timeIntervalSinceNow
        })
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    func generateTestData(){
        let verbs = ["lost", "bought", "tested", "tasted", "washed", "carried", "tried out", "burned", "insulted", "trashed", "smashed", "dropped", "side-eyed", "kissed"]
        let pronouns = [("I ", "your"), ("You", "my")]
        let nouns = ["pants", "money", "DS", "favorite mug", "best friend", "grandma's priceless spoon collection", "lucky boxers", "sketchbook", "laptop", "textbook", "student film", "app project", "term paper", "girlfriend", "condoms", "championship ring","iPhone"]
        let finish = ["last thursday.", "two weeks ago.", "on monday.", "over spring break.", "while I was in Chem Lab.", "when we were in High School", "while my buddy Clyde was watching.", "at the Kappa Psi party.", "in your wildest dreams.", "while everyone else was at the homecoming game."]
        
        let num = Int(arc4random_uniform(1300))+200
        for _ in 0...num{
            let rand = Int(arc4random())
            print("hi")
            let msgStr = pronouns[rand % pronouns.count].0 + " " + verbs[rand % verbs.count] +  " " + pronouns[rand % pronouns.count].1 + " " + nouns[rand % nouns.count] + " " + finish[rand % finish.count]
            if let date = generateRandomDate(daysBack: 100){
                addMessage(content: msgStr, date: date)
                print ("did a thing")
            }else {print("could not generate date")}
        }
        
        for index in 0..<getMessageCount(){
            let messageToPrint = getMessage(at: index)
            print("\(messageToPrint.createdAt): \(messageToPrint.content)")
        }
        
        let adjectives = ["sweet","bro","hella","rad","awesome","legit", "sick", "elite", "patrician"]
        let nameNouns = ["Guy","Bro","Jeff","Dude","Playa","Baller","Lifter","Gangster","Man"]
        let numbers = ["69","1989","6969","00","","xXx","80085",""]
        
        let names = ["Jim","Jordan","Jeff","Drew","Ryan","Justin","Greg","Chris","Mike"]
        
        let adjNum = arc4random_uniform(UInt32(adjectives.count))
        let nameNum = arc4random_uniform(UInt32(names.count))
        let numNum = arc4random_uniform(UInt32(numbers.count))
        
        if
    }
}
