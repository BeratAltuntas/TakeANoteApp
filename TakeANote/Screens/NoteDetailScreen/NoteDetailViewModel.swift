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
	func SaveNote(note: Note)
}

// MARK: - NoteDetailViewModelDelegate
protocol NoteDetailViewModelDelegate: AnyObject {
	
}

// MARK: - NoteDetailViewModel
final class NoteDetailViewModel {
	weak var delegate: NoteDetailViewModelDelegate?
}

// MARK: - Extension: NoteDetailViewModelProtocol
extension NoteDetailViewModel: NoteDetailViewModelProtocol {
	func SaveNote(note: Note) {
		let context = CoreDataManager.shared.GetContext()
		CoreDataManager.shared.SaveEntity(context: context, note: note)
	}
}
