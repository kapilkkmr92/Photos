//
//  ImageListViewController.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var imagesData: [ImageDetail] = []
    private let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        self.tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")
    }
    
    private func startOperations(for photoRecord: ImageDetail, at indexPath: IndexPath) {
      switch (photoRecord.state) {
      case .new:
        startDownload(for: photoRecord, at: indexPath)
      default:
        NSLog("do nothing")
      }
    }
    
    private func startDownload(for photoRecord: ImageDetail, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      let downloader = ImageDownloader(photoRecord)
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
          self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations() {
      pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
      pendingOperations.downloadQueue.isSuspended = false
    }
    
    private func loadImagesForOnscreenCells() {
      if let pathsArray = tableView.indexPathsForVisibleRows {
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        for indexPath in toBeCancelled {
          if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
            pendingDownload.cancel()
          }
          pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        
        for indexPath in toBeStarted {
          let recordToProcess = imagesData[indexPath.row]
          startOperations(for: recordToProcess, at: indexPath)
        }
      }
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                self.navigationController?.popViewController(animated: true)
              case .cancel:
                    print("cancel")
              case .destructive:
                    print("destructive")

              @unknown default:
                print("unknown")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}


extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if imagesData.count == 0 {
            showMessage(message: "No result found")
        }
        return imagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell", for: indexPath) as! ImageListTableViewCell
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(style: .medium)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        let photoDetails = imagesData[indexPath.row]
        cell.selectionStyle = .none
        cell.photoDescription.text = photoDetails.user
        cell.photoImageView.image = photoDetails.image
        
        switch (photoDetails.state) {
        case .failed:
            indicator.stopAnimating()
            cell.photoDescription.text = "Failed to load"
            
        case .new:
            indicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: photoDetails, at: indexPath)
            }
        case .downloaded:
            indicator.stopAnimating()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        vc.imagesData = imagesData
        vc.selectedIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if !decelerate {
        loadImagesForOnscreenCells()
        resumeAllOperations()
      }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      loadImagesForOnscreenCells()
      resumeAllOperations()
    }
}
