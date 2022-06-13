//
//  HomeViewController.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import UIKit

enum HomeViewControllerConstants {
	static let appPurpleColor = "AppPurpleColor"
	static let notePageSegueId = "CreateNoteSegue"
	static let collectionViewNibName = "NoteTypesCollectionViewCell"
	static let collectionViewCellId = "CollectionViewNoteTypes"
	static let tableViewCellNibName = "NoteTableViewCell"
	static let tableViewCellId = "NoteTableViewCell"
	static let noteTypes = ["Bütün Notlar", "Metin", "Hatırlatıcı", "Ses", "Görüntü", "Belge"]
	static let noteTypeImageNames = ["Metin":"text.viewfinder","Hatırlatıcı":"bell", "Ses":"music.note","Görüntü":"photo.on.rectangle.angled","Belge":"doc"]
}
// MARK: - HomeViewController
final class HomeViewController: UIViewController {
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionViewNoteTypes: UICollectionView!
	@IBOutlet weak var tableViewNotes: UITableView!
	
	var viewModel: HomeViewModelProtocol! {
		didSet {
			viewModel.delegate = self
		}
	}
	
	private var selectedNoteType = 0
	private var selectedNote = -1
	override func viewDidLoad() {
		self.viewModel = HomeViewModel()
		super.viewDidLoad()
		viewModel.LoadUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.UpdateNotes()
	}
	
	@IBAction func CreateNote_TUI(_ sender: Any) {
		performSegue(withIdentifier: HomeViewControllerConstants.notePageSegueId, sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == HomeViewControllerConstants.notePageSegueId {
			let vc = segue.destination as! NoteDetailViewController
			vc.viewModel = NoteDetailViewModel()
			if selectedNote != -1 {
				vc.selectedNote = viewModel.notes[selectedNote]
			}
		}
	}
}

// MARK: - Extension: HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
	func SetupCells() {
		collectionViewNoteTypes.register(UINib(nibName: HomeViewControllerConstants.collectionViewNibName, bundle: nil), forCellWithReuseIdentifier: HomeViewControllerConstants.collectionViewCellId)
		tableViewNotes.register(UINib(nibName: HomeViewControllerConstants.tableViewCellNibName, bundle: nil), forCellReuseIdentifier: HomeViewControllerConstants.tableViewCellId)
	}
	
	func ReloadCollectionView() {
		DispatchQueue.main.async { [weak self] in
			self?.collectionViewNoteTypes.reloadData()
		}
	}
	
	func ReloadTableView() {
		DispatchQueue.main.async { [weak self] in
			self?.tableViewNotes.reloadData()
		}
	}
}

// MARK: - Extension: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.notes?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewControllerConstants.tableViewCellId, for: indexPath)as! NoteTableViewCell
		cell.labelTitle.text = viewModel.notes?[indexPath.row].noteTitle
		cell.labelCreatingNoteDate.text = viewModel.notes?[indexPath.row].noteCreatingDate
		cell.labelNoteShortDesc.text = viewModel.notes?[indexPath.row].noteText
		if let category = viewModel.notes?[indexPath.row].noteCategory {
			cell.imageViewKindOfNote.image = UIImage(systemName: category)
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			viewModel.Delete(note: viewModel.notes![indexPath.row])
		}
	}
}

// MARK: - Extension: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedNote = indexPath.row
		performSegue(withIdentifier: HomeViewControllerConstants.notePageSegueId, sender: self)
	}
}

// MARK: - Extension: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { HomeViewControllerConstants.noteTypes.count }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewControllerConstants.collectionViewCellId, for: indexPath) as! NoteTypesCollectionViewCell
		cell.labelTitle.text = HomeViewControllerConstants.noteTypes[indexPath.row]
		cell.backgroundColor = .systemBackground
		if indexPath.row == selectedNoteType {
			cell.backgroundColor = UIColor(named: HomeViewControllerConstants.appPurpleColor)
			cell.layer.cornerRadius = 15
			cell.layer.masksToBounds = true
		}
		return cell
	}
}

// MARK: - Extension: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedNoteType = indexPath.row
		ReloadCollectionView()
	}
}
