//
//  NoteDetailViewModel.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import Foundation

// MARK: - NoteDetailViewModelProtocol
protocol NoteDetailViewModelProtocol {
	var delegate: NoteDetailViewModelDelegate? { get set }
	func SetupUI()
	func SaveNote(note: Note)
	func Delete(note: NoteEntity)
	
}

// MARK: - NoteDetailViewModelDelegate
protocol NoteDetailViewModelDelegate: AnyObject {
	func LoadUI()
	
}

// MARK: - NoteDetailViewModel
final class NoteDetailViewModel {
	weak var delegate: NoteDetailViewModelDelegate?
	
}

// MARK: - Extension: NoteDetailViewModelProtocol
extension NoteDetailViewModel: NoteDetailViewModelProtocol {
	func SetupUI() {
		delegate?.LoadUI()
	}
	func SaveNote(note: Note) {
		let context = CoreDataManager.shared.GetContext()
		CoreDataManager.shared.SaveEntity(context: context, note: note)
	}
	
	func Delete(note: NoteEntity) {
		CoreDataManager.shared.DeleteNote(note: note)
	}
}
