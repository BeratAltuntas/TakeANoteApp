//
//  HomeViewController.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import UIKit

// MARK: -
final class HomeViewController: UIViewController {
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.viewModel = HomeViewModel()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	internal var viewModel: HomeViewModelProtocol! {
		didSet {
			viewModel.delegate = self
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

// MARK: -
extension HomeViewController: HomeViewModelDelegate {
	
}
