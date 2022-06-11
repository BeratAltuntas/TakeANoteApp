//
//  NoteDetailViewController.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import UIKit

// MARK: -
final class NoteDetailViewController: UIViewController {
	
	internal var viewModel: NoteDetailViewModelProtocol! {
		didSet {
			viewModel.delegate = self
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: -
extension NoteDetailViewController: NoteDetailViewModelDelegate {
	
}
