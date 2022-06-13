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
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
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
}
