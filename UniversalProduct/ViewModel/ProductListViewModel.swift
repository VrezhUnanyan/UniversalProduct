//
//  ProductListViewModel.swift
//  UniversalProduct
//
//  Created by Vrezh on 12/25/20.
//


import Foundation
import UIKit

protocol ProductListViewModelDelegate: AnyObject {
	func fetched()
	func updated(index: Int)
	func deleted(index: Int)
}

extension ProductListViewModelDelegate {
	func fetched() { }
	func updated(index: Int) { }
	func deleted(index: Int) { }
}

class ProductListViewModel {
	
	public weak var delegate: ProductListViewModelDelegate?
	
	private(set) var products: [Product] = []
	
	private(set) var productViewModels: [ProductViewModel] = []
	
	init() { }
	
	func fetch() {
		do {
			products = try AppDelegate.delegate.persistentContainer.viewContext.fetch(
				Product.fetchRequest()
			) as! [Product]
			productViewModels = self.products.map { (product: Product) in
				return ProductViewModel(product: product)
			}
			delegate?.fetched()
		} catch {
			delegate?.fetched()
		}
	}
	
	func update(index: Int, name: String?, price: String?,
				count: String?, minorDescription: String?, image: UIImage?) {
		productViewModels[index].update(name: name, price: price,
										count: count, minorDescription: minorDescription, image: image)
		delegate?.updated(index: index)
	}
	
	func deleate(index: Int) {
		productViewModels[index].deleteProduct()
		productViewModels.remove(at: index)
		delegate?.deleted(index: index)
	}
	
}

