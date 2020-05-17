//
//  ImageDetailViewController.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var customPageIndicator: UIPageControl!
    @IBOutlet weak var customScrollView: UIScrollView!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var photosUrls: [String]?
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        customScrollView.delegate = self
        customScrollView.isPagingEnabled = true
        let imagesCount = photosUrls?.count ?? 0
        for index in 0..<imagesCount {

            frame.origin.x = self.customScrollView.frame.size.width * CGFloat(index)
            frame.size = self.customScrollView.frame.size

            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: "PlaceHolder")
            if let url = URL(string: photosUrls?[index] ?? "") {
                imageView.load(url: url)
            }
            self.customScrollView.addSubview(imageView)
        }
        
        self.customScrollView.contentSize = CGSize(width: customScrollView.frame.width * CGFloat(imagesCount) ,height: self.customScrollView.frame.size.height)
        customPageIndicator.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        if let selectedIndex = selectedIndex {
            customScrollView.scrollRectToVisible(CGRect(x: customScrollView.frame.width * CGFloat(selectedIndex), y: 0, width:  customScrollView.frame.width, height: self.customScrollView.frame.size.height), animated: true)
        }
        
    }

    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        customPageIndicator.numberOfPages = photosUrls?.count ?? 0
        customPageIndicator.currentPage = selectedIndex ?? 0
        customPageIndicator.tintColor = UIColor.red
        customPageIndicator.pageIndicatorTintColor = UIColor.black
        customPageIndicator.currentPageIndicatorTintColor = UIColor.green
        
    }

    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(customPageIndicator.currentPage) * customScrollView.frame.size.width
        customScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        customPageIndicator.currentPage = Int(pageNumber)
    }

}
