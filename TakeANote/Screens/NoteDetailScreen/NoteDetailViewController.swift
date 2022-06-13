//
//  NoteDetailViewController.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import UIKit

// MARK: - NoteDetailViewController
final class NoteDetailViewController: UIViewController {
	
	@IBOutlet private weak var textFieldNoteTitle: UITextField!
	@IBOutlet private weak var pickerButtonNoteCategory: UIButton!
	@IBOutlet private weak var labelNoteDate: UILabel!
	@IBOutlet private weak var textViewNote: UITextView!
	var viewModel: NoteDetailViewModelProtocol! {
		didSet {
			viewModel.delegate = self
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func TurnBackPage_TUI(_ sender: Any) {
		DissmissThePage()
	}
	
	@IBAction func SaveNote_TUI(_ sender: Any) {
		let note = FetchNoteDetails()
		viewModel.SaveNote(note: note)
		DissmissThePage()
	}
	
	func FetchNoteDetails()-> Note {
		let date = DateFormatter().DateFormatNowTR()
		let category = HomeViewControllerConstants.noteTypeImageNames[pickerButtonNoteCategory.titleLabel!.text!]
		let noteID = CoreDataManager.shared.GetLastNoteId()
		if noteID == -1 {
			
			let note = Note(noteId: 0,
							noteTitle: textFieldNoteTitle.text!,
							noteText: textViewNote.text,
							noteCategory: category,
							noteCreatingDate: date,
							noteLastEditDate: date)
			return note
		}
		let note = Note(noteId: noteID,
						noteTitle: textFieldNoteTitle.text!,
						noteText: textViewNote.text,
						noteCategory: category,
						noteCreatingDate: date,
						noteLastEditDate: date)
		return note
	}
}

// MARK: - Extension: NoteDetailViewModelDelegate
extension NoteDetailViewController: NoteDetailViewModelDelegate {
	func DissmissThePage() {
		DispatchQueue.main.async { [weak self] in
			self?.dismiss(animated: true)
		}
	}
}

extension DateFormatter {
	func DateFormatNowTR()-> String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "tr_TR")
		formatter.dateFormat = "dd MMMM YYYY HH:mm"
		return formatter.string(from:  Date())
	}
}
