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
	
	func SaveContext() {
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
	}
	
	func SaveEntity(context: NSManagedObjectContext, note: Note) {
		guard let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: context) else { return }
		let entityNote = NSManagedObject(entity: entity, insertInto: context)
		entityNote.setValue(note.noteTitle, forKey: "noteTitle")
		entityNote.setValue(note.noteText, forKey: "noteText")
		entityNote.setValue(note.noteCategory, forKey: "noteCategory")
		entityNote.setValue(note.noteLastEditDate, forKey: "noteLastEditDate")
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
	
	func DeleteNote(note: NoteEntity) {
		GetContext().delete(note)
		SaveContext()
	}
}
