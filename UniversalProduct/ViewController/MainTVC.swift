//
//  MainTVC.swift
//  UniversalProduct
//
//  Created by Vrezh on 12/22/20.
//

import UIKit

class MainTVC: UITableViewController {

	// MARK: ViewModel
	private var productListViewModel: ProductListViewModel!
	private var updatingRow: Int!

	override func viewDidLoad() {
		super.viewDidLoad()
		prepearController()
		productListViewModel.fetch()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		productListViewModel.fetch()
	}

	private func prepearController() {
		hideKeyboardWhenTappedAround()
		prepareProperties()
		prepearViews()
		setDelegates()
	}

	private func prepearViews() {
		tableView.register(ProductTableViewCell.nib(), forCellReuseIdentifier: "productCell")
	}
	
	private func prepareProperties() {
		productListViewModel = ProductListViewModel()
	}

	func setDelegates() {
		productListViewModel.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return productListViewModel.productViewModels.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
				withIdentifier: "productCell",
				for: indexPath
		) as? ProductTableViewCell
		else {
			fatalError("Cell does not exist in storyboard. Cell id is: productCell")
		}
		cell.productViewModel = productListViewModel.productViewModels[indexPath.row]
		cell.delegate = self
		return cell
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView,
				   commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			self.productListViewModel.deleate(index: indexPath.row)
		}
	}
	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
					indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))
			as! ProductTableViewCell
		cell.changeImageButton.tag = indexPath.row
		
		let modifyAction = UIContextualAction(
			style: .normal,
			title:  "Update",
			handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
				success(true)
				let cell = tableView.cellForRow(
					at: IndexPath(row: indexPath.row, section: 0)
				) as! ProductTableViewCell

				self.productListViewModel.update(
					index: indexPath.row,
					name: cell.nameTextField.text,
					price: cell.priceTextField.text,
					count: cell.countTextField.text,
					minorDescription: cell.descriptionTextView.text,
					image: cell.productImageView.image
				)
			}
		)
		modifyAction.backgroundColor = .blue
		
		return UISwipeActionsConfiguration(actions: [modifyAction])
	}

	@IBAction func onRefreshButtonClick(_ sender: Any) {
		productListViewModel.fetch()
	}
}

// MARK: Handle events incomming from ProductListViewModel
extension MainTVC: ProductListViewModelDelegate {
	
	func fetched() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	func updated(index: Int) {
		print("Updated row at index \(index)")
		productListViewModel.fetch()
	}
	
	func deleted(index: Int) {
		print("Deleated row at index \(index)")
		productListViewModel.fetch()
	}

}

extension MainTVC: ProductTableViewCellDelegate {
	func changeImageButtonClicked(row: Int) {
		let vc = UIImagePickerController()
		vc.sourceType = .camera
		vc.allowsEditing = true
		vc.delegate = self
		present(vc, animated: true)
		updatingRow = row
	}
}

extension MainTVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		picker.dismiss(animated: true)

		guard let image = info[.editedImage] as? UIImage else {
			print("No image found")
			return
		}
				
		let cell = self.tableView.cellForRow(at: IndexPath(row: updatingRow, section: 0))
			as! ProductTableViewCell
		cell.productImageView.image = image
	}
}
