//
//  CoreDataManager.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 13.06.2022.
//
import CoreData
import Foundation
import UIKit.UIApplication

class CoreDataManager {
	static let shared = CoreDataManager()
	
	func GetContext()-> NSManagedObjectContext
	{
		return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	}
	func SaveEntity(context: NSManagedObjectContext, note:Note) {
		guard let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: context) else {return}
		
		let entityNote = NSManagedObject(entity: entity, insertInto: context)
		entityNote.setValue(note.noteId, forKey: "noteId")
		entityNote.setValue(note.noteTitle, forKey: "noteTitle")
		entityNote.setValue(note.noteText, forKey: "noteText")
		entityNote.setValue(note.noteCategory, forKey: "noteCategory")
		entityNote.setValue(note.noteCreatingDate, forKey: "noteCreatingDate")
		entityNote.setValue(note.noteLastEditDate, forKey: "noteLastEditDate")
		SaveContext()
	}
	func SaveContext(){
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
	}
}
