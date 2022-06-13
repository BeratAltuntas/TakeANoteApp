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
	var notes: [Note]? { get }
	func LoadUI()
	func UpdateNotes()
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
	var notes: [Note]?
}

// MARK: - Extension: HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
	func LoadUI() {
		delegate?.SetupCells()
	}
	
	func UpdateNotes() {
		notes = CoreDataManager.shared.GetNotes()
		delegate?.ReloadTableView()
	}
}
