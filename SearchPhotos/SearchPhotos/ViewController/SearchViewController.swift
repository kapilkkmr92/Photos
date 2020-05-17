//
//  ViewController.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,CustomLoadingIndicator {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    private lazy var requestManager = RequestManager<ImagesResponse>()
    var loadingIndicator: UIActivityIndicatorView?
    private var searchResult = [String]()
    private var originalSearchResult = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTextField.becomeFirstResponder()
        searchResult.removeAll()
        for result in originalSearchResult {
            searchResult.append(result)
        }
        tableView.reloadData()
    }
    
    private func setupUI() {
        self.title = "Search Image"
        searchTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        searchTextField.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func searchRecords(_ textField: UITextField) {
        self.searchResult.removeAll()
        if textField.text?.count != 0 {
            for country in originalSearchResult {
                if let countryToSearch = textField.text{
                    let range = country.lowercased().range(of: countryToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.searchResult.append(country)
                    }
                }
            }
        } else {
            for country in originalSearchResult {
                searchResult.append(country)
            }
        }
        tableView.reloadData()
    }
    
    private func loadList(query: String) {
        showLoadingIndicator()
        requestManager.getImagesWith(query: query) { [weak self] (result) in
            self?.hideLoadingIndicator()
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if let imageCount = imageData?.imageItems.count, imageCount > 0 {
                        self?.storeSearchedResult()
                    }
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController
                    vc.imagesData = imageData?.imageItems ?? []
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            
            case .failed(let error,_):
                print(error)
            }
        }
    }
    
    private func storeSearchedResult() {
        guard let searchedText = searchTextField.text,!searchedText.isEmpty else { return }
        if !originalSearchResult.contains(searchedText) {
            if originalSearchResult.count == 10 {
                originalSearchResult.removeLast()
            }
            originalSearchResult.insert(searchedText, at: 0)
        }
    }
    
    private func showMessage(message: String) {
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

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = searchResult[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        let selectedItem = searchResult[indexPath.row]
        searchTextField.text = selectedItem
        loadList(query: selectedItem)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
