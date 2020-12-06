//
//  CoreDataStorage.swift
//  new_app
//
//  Created by Olena on 06.12.2020.
//  Copyright © 2020 Olena. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStorage {
    
    enum Issue: Error {
        case noValue
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NoteModel")
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
    
    func save(note: Note) throws {
          let entity = NSEntityDescription.entity(forEntityName: "NoteCore", in: persistentContainer.viewContext)!
          let managedObject = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
          managedObject.setValue(note.noteId, forKey: "noteId")
          managedObject.setValue(note.name, forKey: "name")
          managedObject.setValue(note.text, forKey: "text")
          managedObject.setValue(note.tags as NSSet, forKey: "tags")
          managedObject.setValue(note.isFavourite, forKey: "isFavourite")
          managedObject.setValue(note.creationDate, forKey: "creationDate")
          managedObject.setValue(note.deletionDate, forKey: "deletionDate")
          saveContext()
      }
    
    func fetchNote() throws -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCore")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        
        var notes: [Note] = []
        
        for result in results {
            let noteId = result.value(forKey: "noteId") as! Int
            let name = result.value(forKey: "name") as! String
            let text = result.value(forKey: "text") as! String
            let tags = result.value(forKey: "tags") as! Set<String>
            let isFavourite = result.value(forKey: "isFavourite") as! Bool
            let creationDate = result.value(forKey: "creationDate") as! Date
            let deletionDate = result.value(forKey: "deletionDate") as! Date
            let note = Note(noteId: noteId, name: name, text: text, tags: tags, isFavourite: isFavourite, creationDate: creationDate, deletionDate: deletionDate)
            notes.append(note)
        }
        return notes

    }
    
    func deleteNote(noteId: Int) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCore")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", argumentArray: [Int64(noteId)])
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        
        for result in results {
            persistentContainer.viewContext.delete(result)
        }
        saveContext()
        
    }
    
    func updateNote(noteId: Int, newValue: Any?, oldValue: String) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCore")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", argumentArray: [Int64(noteId)])
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let managedObject = results.first else { throw Issue.noValue }
        managedObject.setValue(newValue, forKey: oldValue)
        saveContext()
    }
    
    func deleteAllData() throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCore")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        
        for result in results {
            persistentContainer.viewContext.delete(result)
        }
    }
        
}
