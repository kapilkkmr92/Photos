//
//  Extensions.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation
import UIKit

protocol CustomLoadingIndicator: class {
    var loadingIndicator: UIActivityIndicatorView? { get set }
}

extension CustomLoadingIndicator where Self: UIViewController {
    
    func showLoadingIndicator(at point: CGPoint? = nil) {
        OperationQueue.main.addOperation({
            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            self.view.addSubview(loadingIndicator)
            loadingIndicator.center = point ?? self.view.center
            loadingIndicator.startAnimating()
            self.loadingIndicator = loadingIndicator
        })
    }
    
    func hideLoadingIndicator() {
        OperationQueue.main.addOperation({
            guard let _ = self.loadingIndicator else {
                return
            }
            self.loadingIndicator?.removeFromSuperview()
            self.loadingIndicator = nil
        })
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
