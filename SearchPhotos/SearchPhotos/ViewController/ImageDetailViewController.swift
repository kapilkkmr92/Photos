//
//  ImageDetailViewController.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    private var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var imagesData: [Item]?
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        configurePageControl()
        setupScrollView()
        defaultSelection()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        let imagesCount = imagesData?.count ?? 0
        for index in 0..<imagesCount {
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = imagesData?[index].image
            imageView.contentMode = .scaleAspectFit
            switch imagesData?[index].state {
            case .new:
                guard let url = URL(string: imagesData?[index].largeImageURL ?? "") else { return }
                imageView.load(url: url)
            default:
                break
            }
            scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imagesCount) ,height: self.scrollView.frame.size.height)
    }
    
    func configurePageControl() {
        pageageControl.numberOfPages = imagesData?.count ?? 0
        pageageControl.currentPage = selectedIndex ?? 0
        pageageControl.tintColor = UIColor.red
        pageageControl.pageIndicatorTintColor = UIColor.black
        pageageControl.currentPageIndicatorTintColor = UIColor.green
        pageageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    private func defaultSelection() {
        if let selectedIndex = selectedIndex {
            scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width * CGFloat(selectedIndex), y: 0, width:  scrollView.frame.width, height: self.scrollView.frame.size.height), animated: true)
        }
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageageControl.currentPage = Int(pageNumber)
    }

}
