//
//  CreateProductViewController.swift
//  UniversalProduct
//
//  Created by Vrezh on 12/22/20.
//

import UIKit

class CreateProductVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	let rowCount = 1;
	@IBOutlet weak var tableView: UITableView!
	var refreshControl = UIRefreshControl()
	// MARK: ViewModel
	private var productViewModel: ProductViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepearController()
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
	}
	
	@objc func refresh(_ sender: AnyObject) {
		// Code to refresh table view
	}

	private func prepearController() {
		hideKeyboardWhenTappedAround()
		prepareProperties()
		prepearViews()
		setDelegates()
	}

	private func prepearViews() {
		tableView.register(ProductTableViewCell.nib(), forCellReuseIdentifier: "newProductCell")
	}
	
	private func prepareProperties() {
		productViewModel = ProductViewModel()
	}
	
	func setDelegates() {
		productViewModel.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.rowCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = self.tableView.dequeueReusableCell(
				withIdentifier: "newProductCell",
				for: indexPath
		) as? ProductTableViewCell
		else {
			fatalError("Cell does not exist in storyboard. Cell id is: newProductCell")
		}
		cell.delegate = self
		return cell
	}
	
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		picker.dismiss(animated: true)

		guard let image = info[.editedImage] as? UIImage else {
			print("No image found")
			return
		}
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
			as! ProductTableViewCell
		cell.productImageView.image = image
	}

	@IBAction func onSaveButtonClick(_ sender: UIButton) {
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProductTableViewCell
		productViewModel.save(name: cell.nameTextField.text,
							  price: cell.priceTextField.text,
							  count: cell.countTextField.text,
							  minorDescription: cell.descriptionTextView.text,
							  image: cell.productImageView.image)
		self.navigationController?.popViewController(animated: true)
	}

}

// MARK: Handle events incomming from ViewModel
extension CreateProductVC: ProductViewModelDelegate {
	
	func saved() {
		print("Product Saved")
	}
	
}

extension CreateProductVC: ProductTableViewCellDelegate {
	
	func changeImageButtonClicked(row: Int) {
		let vc = UIImagePickerController()
		vc.sourceType = .camera
		vc.allowsEditing = true
		vc.delegate = self
		present(vc, animated: true)
	}
	
}
