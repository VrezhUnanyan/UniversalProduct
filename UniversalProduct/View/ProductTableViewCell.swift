//
//  TableViewCell.swift
//  UniversalProduct
//
//  Created by Vrezh on 12/22/20.
//

import UIKit


protocol ProductTableViewCellDelegate: AnyObject {
	func changeImageButtonClicked(row: Int)
}

class ProductTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var priceTextField: UITextField!
	@IBOutlet weak var countTextField: UITextField!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var productImageView: UIImageView!
	
	@IBOutlet weak var changeImageButton: UIButton!
	weak var delegate: ProductTableViewCellDelegate?
	
	var productViewModel: ProductViewModel! {
		didSet {
			self.nameTextField.text = productViewModel.name
			self.priceTextField.text = productViewModel.price
			self.countTextField.text = productViewModel.count
			self.descriptionTextView.text = productViewModel.minorDescription
			self.productImageView.image = productViewModel.image
		}
	}
	
	static func nib() -> UINib {
		return UINib(nibName: "ProductTableViewCell", bundle: nil)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		self.nameTextField.placeholder = "name of product"
		self.priceTextField.placeholder = "price of product"
		self.countTextField.placeholder = "name of product"
		self.descriptionTextView.text = ""
		setDelegates()
	}

	func setDelegates() {
		self.nameTextField.delegate = self
		self.priceTextField.delegate = self
		self.countTextField.delegate = self
		self.descriptionTextView.delegate = self
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	@IBAction func onChangeImageButtonClick(_ sender: UIButton) {
		delegate?.changeImageButtonClicked(row: sender.tag)
	}
}
