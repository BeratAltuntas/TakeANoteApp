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
	static let noteTypes = ["Bütün Notlar", "Hatırlatıcı", "Ses", "Görüntü", "Belge"]
}
// MARK: - HomeViewController
final class HomeViewController: UIViewController {
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionViewNoteTypes: UICollectionView!
	@IBOutlet weak var tableViewNotes: UITableView!
	
	internal var viewModel: HomeViewModelProtocol! {
		didSet {
			viewModel.delegate = self
		}
	}
	var selectedNoteType = 0
	override func viewDidLoad() {
		self.viewModel = HomeViewModel()
		super.viewDidLoad()
		viewModel.LoadUI()
	}
	@IBAction func CreateNote_TUI(_ sender: Any) {
		performSegue(withIdentifier: HomeViewControllerConstants.notePageSegueId, sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == HomeViewControllerConstants.notePageSegueId {
			let vc = segue.destination as! NoteDetailViewController
			vc.viewModel = NoteDetailViewModel()
		}
	}
}

// MARK: - Extension: HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
	func LoadCells() {
		collectionViewNoteTypes.register(UINib(nibName: HomeViewControllerConstants.collectionViewNibName, bundle: nil), forCellWithReuseIdentifier: HomeViewControllerConstants.collectionViewCellId)
		tableViewNotes.register(UINib(nibName: HomeViewControllerConstants.tableViewCellNibName, bundle: nil), forCellReuseIdentifier: HomeViewControllerConstants.tableViewCellId)
	}
	func ReloadCollectionView(inMain: Bool) {
		DispatchQueue.main.async { [weak self] in
			self?.collectionViewNoteTypes.reloadData()
		}
	}
}

extension HomeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	
}
extension HomeViewController: UITableViewDelegate {
}

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
extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedNoteType = indexPath.row
		ReloadCollectionView(inMain: false)
	}
}
