//
//  HomeViewModel.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import Foundation

// MARK: - HomeViewModelProtocol
protocol HomeViewModelProtocol {
	var delegate: HomeViewModelDelegate? { get set }
	var notes: [NoteEntity]! { get }
	func LoadUI()
	func UpdateNotes()
	func Delete(note: NoteEntity)
	func FetchNotes(byCategory: String)
	func FetchNotes(byText: String)
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
	var selectedNoteType: Int { get set }
	
	func SetupCells()
	func ReloadCollectionView()
	func ReloadTableView()
}

// MARK: - HomeViewModel
final class HomeViewModel {
	weak var delegate: HomeViewModelDelegate?
	var notes: [NoteEntity]!
}

// MARK: - Extension: HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
	func LoadUI() {
		delegate?.SetupCells()
		UpdateNotes()
	}
	
	func UpdateNotes() {
		notes?.removeAll()
		notes = CoreDataManager.shared.GetNotes()
		delegate?.ReloadTableView()
	}
	
	func Delete(note: NoteEntity) {
		CoreDataManager.shared.DeleteNote(note: note)
		UpdateNotes()
	}
	
	func FetchNotes(byCategory: String) {
		if byCategory == HomeViewControllerConstants.noteTypes.first {
			UpdateNotes()
		} else {
			notes = CoreDataManager.shared.GetNotesBy(categoryFilter: byCategory)
			delegate?.ReloadTableView()
		}
	}
	
	func FetchNotes(byText: String) {
		if byText.isEmpty {
			delegate?.selectedNoteType = .zero
			delegate?.ReloadCollectionView()
			UpdateNotes()
		} else {
			notes = CoreDataManager.shared.GetNotesBy(text: byText)
		}
		delegate?.ReloadTableView()
	}
}
