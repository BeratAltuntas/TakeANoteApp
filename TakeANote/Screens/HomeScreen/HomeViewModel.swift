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
	func LoadUI()
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
	func LoadCells()
	func ReloadCollectionView(inMain: Bool)
}

// MARK: - HomeViewModel
final class HomeViewModel {
	weak var delegate: HomeViewModelDelegate?
}

// MARK: - Extension: HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
	func LoadUI() {
		delegate?.LoadCells()
	}
}
