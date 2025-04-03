//
//  DatabaseManager.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//
import CoreData

class DatabaseManager {
    
    var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }

    func saveUser(_ user: [UserData]) {
        saveUsersToCoreData(users: user, context: context)
    }
    
    private func saveUsersToCoreData(users: [UserData], context: NSManagedObjectContext) {
        for user in users {
            let userEntity = People(context: context)
            userEntity.id = user.id?.value ?? ""
            userEntity.firstName = user.name?.first ?? ""
            userEntity.lastName = user.name?.last ?? ""
            userEntity.email = user.email ?? ""
            userEntity.imageLarge = user.picture?.large ?? ""
            userEntity.imageMedium = user.picture?.medium ?? ""
            userEntity.imageThumbnail = user.picture?.thumbnail ?? ""
            userEntity.favouriteStatus = 0 // Default Value when user has not accepted or declined profile
            userEntity.address = user.location?.street?.name ?? ""
            userEntity.city = user.location?.city ?? ""
            userEntity.state = user.location?.state ?? ""
            userEntity.country = user.location?.country ?? ""
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving users to Core Data: \(error)")
        }
    }
    
    
    // Fetch users from Core Data
    func getAllUsers() -> [People] {
        let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            return users
        } catch {
            return []
        }
    }
    
    func updateUserStatus(email: String, status: Int, completion: ((Bool) -> Void)?) {
        let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            if let people = try context.fetch(fetchRequest).first {
                people.favouriteStatus = Int16(status)
                try context.save()
                completion?(true)
            } else {
                print("Entity Not Found.")
                completion?(false)
            }
        } catch {
            print("Error saving users to Core Data: \(error)")
            completion?(false)
        }
    }
    
    func getUserStatusData(status: [Int]) -> [MatchStatus] {
        let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(type: .or, subpredicates: status.map({ NSPredicate(format: "favouriteStatus == %d", $0) }))
        do {
            let users = try context.fetch(fetchRequest)
            var result: [MatchStatus] = []
            _ = users.map { people in
                result.append((people.email ?? "", Int(people.favouriteStatus ?? 0)))
            }
            return result
        } catch {
            print("Error saving users to Core Data: \(error)")
            return []
        }
    }
}
