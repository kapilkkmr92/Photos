//
//  ViewController.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,CustomLoadingIndicator {

    @IBOutlet weak var searchTextField: UITextField!
    private lazy var requestManager = RequestManager<ImagesModel>()
    var loadingIndicator: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    func loadList(query: String) {
        showLoadingIndicator()
        requestManager.getImagesWith(query: query) { [weak self] (result) in
            self?.hideLoadingIndicator()
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController
//                    vc.listData = imageData?.images ?? []
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            
            case .failed(let error,_):
                print(error)
            }
        }
    }
    
    func showMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSearchPress(_ sender: Any) {
        self.view.endEditing(true)
        if let text = searchTextField.text, text.count > 0 {
            loadList(query: text)
        } else {
            showMessage(message: "Please enter something")
        }
    }
    
}

