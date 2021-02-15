//
//  ProductViewModel.swift
//  UniversalProduct
//
//  Created by Vrezh on 12/22/20.
//

import Foundation
import UIKit

protocol ProductViewModelDelegate: AnyObject {
	func saved()
	func updated()
	func deleted()
}

extension ProductViewModelDelegate {
	func saved() { }
	func updated() { }
	func deleted() { }
}

class ProductViewModel {
	weak var delegate: ProductViewModelDelegate?

	var name: String = ""
	var price: String = ""
	var count: String = ""
	var minorDescription: String = ""
	var image: UIImage = UIImage(named: "sampleProduct") ?? UIImage()

	private var product: Product!

	init() { }

	init(product: Product) {
		self.product = product
		name = product.name ?? ""
		price = "\(product.price)"
		count = "\(product.count)"
		minorDescription = product.minorDescription ?? ""
		image = UIImage(data: product.image ?? Data()) ?? UIImage()
	}

	func save(name: String?, price: String?, count: String?, minorDescription: String?, image: UIImage?) {
		product = Product(context: AppDelegate.delegate.persistentContainer.viewContext)
		setProduct(name: name, price: price, count: count, minorDescription: minorDescription, image: image)
		delegate?.saved()
	}

	func update(name: String?, price: String?, count: String?, minorDescription: String?, image: UIImage?) {
		setProduct(name: name, price: price, count: count, minorDescription: minorDescription, image: image)
		delegate?.updated()
	}

	func delete() {
		deleteProduct()
		delegate?.deleted()
	}

	func setProduct(name: String?, price: String?, count: String?, minorDescription: String?, image: UIImage?) {
		product.name = name
		product.minorDescription = minorDescription
		product.image = image?.pngData()
		if let priceStr = price, let p = Int32(priceStr) {
			product.price = p
		}
		if let countStr = count, let c = Int32(countStr) {
			product.count = c
		}
		AppDelegate.delegate.saveContext()
	}

	func deleteProduct() {
		AppDelegate.delegate.persistentContainer.viewContext.delete(product)
		AppDelegate.delegate.saveContext()
	}

}
