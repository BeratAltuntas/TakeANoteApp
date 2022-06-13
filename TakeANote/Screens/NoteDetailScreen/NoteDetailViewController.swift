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
	
	var selectedNote: NoteEntity?
	override func viewDidLoad() {
		let optionsClosure = { (action: UIAction) in
			print(action.title)
		}
		pickerButtonNoteCategory.menu = UIMenu(children: [
			UIAction(title: "Metin", state: .on, handler: optionsClosure),
			UIAction(title: "Hatırlatıcı", handler: optionsClosure),
			UIAction(title: "Ses", handler: optionsClosure),
			UIAction(title: "Görüntü", handler: optionsClosure),
			UIAction(title: "Belge", handler: optionsClosure)
		])
	}
	override func viewWillAppear(_ animated: Bool) {
		labelNoteDate.text = DateFormatter().DateFormatNowTR()
		if selectedNote != nil {
			LoadSelectedNote()
		}
	}
	
	func LoadSelectedNote() {
		textFieldNoteTitle.text = selectedNote!.noteTitle
		textViewNote.text = selectedNote!.noteText!
		pickerButtonNoteCategory.titleLabel?.text = selectedNote!.noteCategory
		labelNoteDate.text = selectedNote!.noteCreatingDate
	}
	
	@IBAction func TurnBackPage_TUI(_ sender: Any) {
		DissmissThePage()
	}
	
	@IBAction func SaveNote_TUI(_ sender: Any) {
		if selectedNote != nil {
			viewModel.Delete(note: selectedNote!)
		}
		let note = FetchNoteDetails()
		viewModel.SaveNote(note: note)
		DissmissThePage()
	}
	
	func FetchNoteDetails()-> Note {
		let date = DateFormatter().DateFormatNowTR()
		let category = HomeViewControllerConstants.noteTypeImageNames[pickerButtonNoteCategory.titleLabel!.text!]
		var note = Note()
		note.noteTitle = textFieldNoteTitle.text!
		note.noteText = textViewNote.text!
		note.noteCategory = category
		note.noteCreatingDate = date
		note.noteLastEditDate = date
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

// MARK: - Extension: DateFormatter
extension DateFormatter {
	func DateFormatNowTR()-> String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "tr_TR")
		formatter.dateFormat = "dd MMMM YYYY HH:mm"
		return formatter.string(from:  Date())
	}
}
