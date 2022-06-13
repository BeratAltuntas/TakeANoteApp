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
	@IBOutlet private weak var labelNoteDate: UILabel!
	@IBOutlet private weak var textViewNote: UITextView!
	internal var viewModel: NoteDetailViewModelProtocol! {
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
