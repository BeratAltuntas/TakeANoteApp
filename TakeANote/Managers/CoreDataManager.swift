//
//  CoreDataManager.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 13.06.2022.
//
import CoreData
import Foundation
import UIKit.UIApplication

enum CoreDataNoteEntityConstants {
	static let entityName = "NoteEntity"
	static let entityNoteTitle = "noteTitle"
	static let entityNoteText = "noteText"
	static let entityNoteCategory = "noteCategory"
	static let entityNoteLastEditDate = "noteLastEditDate"
}

class CoreDataManager {
	static let shared = CoreDataManager()
	
	func GetContext()-> NSManagedObjectContext
	{
		return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	}
	
	func SaveContext() {
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
	}
	
	func SaveEntity(context: NSManagedObjectContext, note: Note) {
		guard let entity = NSEntityDescription.entity(forEntityName: CoreDataNoteEntityConstants.entityName, in: context) else { return }
		let entityNote = NSManagedObject(entity: entity, insertInto: context)
		entityNote.setValue(note.noteTitle, forKey: CoreDataNoteEntityConstants.entityNoteTitle)
		entityNote.setValue(note.noteText, forKey: CoreDataNoteEntityConstants.entityNoteText)
		entityNote.setValue(note.noteCategory, forKey: CoreDataNoteEntityConstants.entityNoteCategory)
		entityNote.setValue(note.noteLastEditDate, forKey: CoreDataNoteEntityConstants.entityNoteLastEditDate)
		SaveContext()
	}
	
	func GetNotes()-> [NoteEntity] {
		let fetchRequest : NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
		do{
			var notes = try GetContext().fetch(fetchRequest)
			notes = notes.reversed()
			return notes
		}
		catch{
			return []
		}
	}
	
	func GetNotesBy(categoryFilter: String)->[NoteEntity] {
		let notes = GetNotes()
		var tempNotes = [NoteEntity]()
		for note in notes {
			if note.noteCategory == categoryFilter {
				tempNotes.append(note)
			}
		}
		return tempNotes
	}
	
	func GetNotesBy(text: String)->[NoteEntity] {
		let notes = GetNotes()
		var tempNotes = [NoteEntity]()
		for note in notes {
			if (note.noteText?.lowercased().contains(text))! || (note.noteTitle?.lowercased().contains(text))! || (note.noteLastEditDate?.lowercased().contains(text))!  {
				tempNotes.append(note)
			}
		}
		return tempNotes
	}
	
	func DeleteNote(note: NoteEntity) {
		GetContext().delete(note)
		SaveContext()
	}
}
