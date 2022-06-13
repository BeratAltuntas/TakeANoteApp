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
		viewModel.SetupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		labelNoteDate.text = DateFormatter().DateFormatNowTR()
		if selectedNote != nil {
			LoadSelectedNote()
		}
	}
	
	func LoadCategories() {
		let optionsClosure = { (action: UIAction) in
		}
		pickerButtonNoteCategory.menu = UIMenu(children: [
			UIAction(title: HomeViewControllerConstants.noteTypes[1], state: .on, handler: optionsClosure),
			UIAction(title: HomeViewControllerConstants.noteTypes[2], handler: optionsClosure),
			UIAction(title: HomeViewControllerConstants.noteTypes[3], handler: optionsClosure),
			UIAction(title: HomeViewControllerConstants.noteTypes[4], handler: optionsClosure),
			UIAction(title: HomeViewControllerConstants.noteTypes[5], handler: optionsClosure)
		])
	}
	
	func KeyboardNotificationCenter() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	func LoadSelectedNote() {
		textFieldNoteTitle.text = selectedNote!.noteTitle
		textViewNote.text = selectedNote!.noteText!
		pickerButtonNoteCategory.titleLabel?.text = selectedNote!.noteCategory
		labelNoteDate.text = selectedNote!.noteLastEditDate
	}
	
	func GetUITexts()-> Note {
		let date = DateFormatter().DateFormatNowTR()
		let category = HomeViewControllerConstants.noteTypeImageNames[pickerButtonNoteCategory.titleLabel!.text!]
		var note = Note()
		note.noteTitle = textFieldNoteTitle.text!
		note.noteText = textViewNote.text!
		note.noteCategory = category
		note.noteLastEditDate = date
		return note
	}
	
	@IBAction func TurnBackPage_TUI(_ sender: Any) {
		DissmissThePage()
	}
	
	@IBAction func SaveNote_TUI(_ sender: Any) {
		if selectedNote != nil {
			viewModel.Delete(note: selectedNote!)
		}
		let note = GetUITexts()
		viewModel.SaveNote(note: note)
		DissmissThePage()
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
		let keyboardScreenEnd = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification{
			textViewNote.contentInset = .zero
		}else{
			
			textViewNote.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height  - view.safeAreaInsets.bottom, right: 0)
		}
		textViewNote.scrollIndicatorInsets = textViewNote.contentInset
		let selectedRange = textViewNote.selectedRange
		textViewNote.scrollRangeToVisible(selectedRange)
	}
}

// MARK: - Extension: NoteDetailViewModelDelegate
extension NoteDetailViewController: NoteDetailViewModelDelegate {
	func DissmissThePage() {
		DispatchQueue.main.async { [weak self] in
			self?.dismiss(animated: true)
		}
	}
	
	func LoadUI() {
		LoadCategories()
		KeyboardNotificationCenter()
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
