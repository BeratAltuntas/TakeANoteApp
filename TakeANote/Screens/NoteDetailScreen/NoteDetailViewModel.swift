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
	
}
