
//
//  FriendsControllerHelper.swift
//  BioDesign Mail
//
//  Created by Khalid Mohamed on 2/22/17.
//  Copyright © 2017 Khalid Mohamed. All rights reserved.
//

//controller that holds all the data
import UIKit
import CoreData

extension HomeController {
    
    func clearData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
           
        do {
            let entityNames = [ "Friend","Message"]
            for entityName in entityNames {
            
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
            }
            try (context.save())
            
        } catch let err {
            print(err)
            }
        }
    }

    func setupData() {
        
        clearData()
        
     let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
           
            let Billy = NSEntityDescription.insertNewObject(forEntityName: "Friend" , into: context) as! Friend
           Billy.name = " Billy Kiely"
           
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = Billy
            message.text = "OH! is that the place that Jon was talking about earlier"
            message.date = Date() as NSDate?
            
        
            let Jon = NSEntityDescription.insertNewObject(forEntityName: "Friend" , into: context) as! Friend
            Jon.name = " Jon Dowdle"
        
            
            CreateMessageWithText("How is it going", friend: Jon,minutesAgo: 2 ,context: context)
            CreateMessageWithText(" Yeah, It is it is really really good. Highly recommend!!", friend: Jon,minutesAgo: 2,  context: context)
            CreateMessageWithText(" They have so much good burgers!! Lots of options. You can even get a burger with three patties.", friend: Jon, minutesAgo: 1, context: context)
            
            let clark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            clark.name = "Clark Valberg"
            CreateMessageWithText("Everyone is talking about the place.", friend: clark, minutesAgo: 5, context: context)
            let Josh = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            Josh.name = "Josh Siok"
            CreateMessageWithText("Everyone is talking about this place", friend: clark, minutesAgo: 10, context: context)
            let Ben = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            Ben.name = "Ben Nadal"
            CreateMessageWithText("Discuss Creative Decisions and feedback...", friend: Ben, minutesAgo: 30 * 24, context: context)
            let Avi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            Avi.name = "Avi Soroka"
            CreateMessageWithText("A realtime todo list feedback...", friend: Avi, minutesAgo: 8*60*24, context: context)
            let Ryan = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as!Friend
            Ryan.name = "Ryan Duffy"
            CreateMessageWithText(" Hey! Nobody invites me to this burger joint, Why am I always left out", friend: Ryan, minutesAgo: 8*60*48, context: context)
            let Elon = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            Elon.name = " Elon Musk"
            CreateMessageWithText(" We are launching Dragon tomorrow. Also, Im building an underground tunnnel to aviod the Bay Area traffic. Hope you like it. ", friend: Elon, minutesAgo: 8*60*50, context: context)
            
            
            do {
                try (context.save())
            } catch let err {
                print(err)
            }
        }
        
         loadData()
    }
   fileprivate func CreateMessageWithText(_ text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) {
        let message =  NSEntityDescription.insertNewObject(forEntityName: "Message" , into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                 print (friend.name)
                    
              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                fetchRequest.sortDescriptors = [NSSortDescriptor (key: "date", ascending: false)]
                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                fetchRequest.fetchLimit = 1
        do {
            let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
            messages?.append(contentsOf:fetchedMessages!)
        } catch let err {
            print(err)
           }
        }
          messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
            }
    }
  }
    fileprivate func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
         if let context = delegate?.managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
              return  try  context.fetch(request) as? [Friend]
            }catch let err {
                print(err)
            }
    }
        return nil
}
}
