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
	
	func GetLastNoteId()->Int {
		let fetchRequest : NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
		do{
			var lastId = -1
			let notes = try GetContext().fetch(fetchRequest)
			for note in notes{
				lastId = Int(note.noteId)
			}
			return lastId
		}
		catch{
			return -1
		}
	}
	
	func GetNotes()-> [Note] {
		let fetchRequest : NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
		do{
			var returningNote = [Note]()
			let notes = try GetContext().fetch(fetchRequest)
			for note in notes {
				var tempNote = Note()
				tempNote.noteId = Int(note.noteId)
				tempNote.noteTitle = note.noteTitle
				tempNote.noteText = note.noteText
				tempNote.noteCategory = note.noteCategory
				tempNote.noteCreatingDate = note.noteCreatingDate
				tempNote.noteLastEditDate = note.noteLastEditDate
				returningNote.append(tempNote)
			}
			return returningNote
		}
		catch{
			return []
		}
	}
}
