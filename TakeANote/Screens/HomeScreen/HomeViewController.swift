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
	static let noteTypes = ["Bütün Notlar", "Metin", "Hatırlatıcı", "Ses", "Görüntü", "Belge"]
	static let noteTypeImageNames = ["Metin":"text.viewfinder", "Hatırlatıcı":"bell", "Ses":"music.note", "Görüntü":"photo.on.rectangle.angled", "Belge":"doc", "NotYok":"multiply.square"]
}
enum UIConstants {
	static let collectionViewNibName = "NoteTypesCollectionViewCell"
	static let collectionViewCellId = "CollectionViewNoteTypes"
	static let tableViewCellHeight: CGFloat = 120
	static let tableViewCellNibName = "NoteTableViewCell"
	static let tableViewCellId = "NoteTableViewCell"
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
	var zeroNote = Note()
	var selectedNoteType: Int = .zero
	private var selectedNote = -1
	
	override func viewDidLoad() {
		self.viewModel = HomeViewModel()
		super.viewDidLoad()
		viewModel.LoadUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.UpdateNotes()
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
	
	@IBAction func CreateNote_TUI(_ sender: Any) {
		performSegue(withIdentifier: HomeViewControllerConstants.notePageSegueId, sender: self)
	}
	
}

// MARK: - Extension: HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
	
	func SetupCells() {
		collectionViewNoteTypes.register(UINib(nibName: UIConstants.collectionViewNibName, bundle: nil), forCellWithReuseIdentifier: UIConstants.collectionViewCellId)
		tableViewNotes.register(UINib(nibName: UIConstants.tableViewCellNibName, bundle: nil), forCellReuseIdentifier: UIConstants.tableViewCellId)
		tableViewNotes.estimatedRowHeight = UIConstants.tableViewCellHeight
		tableViewNotes.rowHeight = UITableView.automaticDimension
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
	
	func FillZeroNote() {
		zeroNote.noteTitle = "Kayıtlı Note Yok"
		zeroNote.noteText = "Not bulunamadı."
		zeroNote.noteCategory = "multiply.square"
		zeroNote.noteLastEditDate = ""
	}
}

// MARK: - Extension: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.notes?.count == 0 ? 1 : viewModel.notes?.count ?? 0 }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.tableViewCellId, for: indexPath)as! NoteTableViewCell
		if viewModel.notes.count == .zero {
			cell.labelTitle.text = zeroNote.noteTitle
			cell.labelCreatingNoteDate.text = zeroNote.noteLastEditDate
			cell.labelNoteShortDesc.text = zeroNote.noteText
			if let category = zeroNote.noteCategory {
				cell.imageViewKindOfNote.image = UIImage(systemName: category)
			}
		} else {
			cell.labelTitle.text = viewModel.notes?[indexPath.row].noteTitle
			cell.labelCreatingNoteDate.text = viewModel.notes?[indexPath.row].noteLastEditDate
			cell.labelNoteShortDesc.text = viewModel.notes?[indexPath.row].noteText
			if let category = viewModel.notes?[indexPath.row].noteCategory {
				cell.imageViewKindOfNote.image = UIImage(systemName: category)
			}
		}
		cell.labelNoteShortDesc.sizeToFit()
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete && viewModel.notes.count != .zero{
			viewModel.Delete(note: viewModel.notes![indexPath.row])
		}
	}
}

// MARK: - Extension: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if viewModel.notes.count != .zero {
			selectedNote = indexPath.row
			performSegue(withIdentifier: HomeViewControllerConstants.notePageSegueId, sender: self)
		}
	}
	
	private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

// MARK: - Extension: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { HomeViewControllerConstants.noteTypes.count }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.collectionViewCellId, for: indexPath) as! NoteTypesCollectionViewCell
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
		viewModel.FetchNotes(byCategory: HomeViewControllerConstants.noteTypeImageNames[HomeViewControllerConstants.noteTypes[selectedNoteType]] ?? HomeViewControllerConstants.noteTypes.first!)
		ReloadCollectionView()
	}
}

extension HomeViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel.FetchNotes(byText: searchText.lowercased())
		if viewModel.notes.count == .zero {
			
		}
	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = .none
		selectedNoteType = .zero
		viewModel.UpdateNotes()
		ReloadCollectionView()
		searchBar.endEditing(true)
	}
}
