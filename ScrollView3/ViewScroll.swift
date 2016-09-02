//
//  ViewScroll.swift
//  Paging
//
//  Created by Hoàng Minh Thành on 9/1/16.
//  Copyright © 2016 Hoàng Minh Thành. All rights reserved.
//

import UIKit

class ViewScroll: UIViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    var photo: [UIImageView] = []
    var pageImages: [String] = []
    var frontScrollViews: [UIScrollView] = []
    var first = false
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImages = ["image","food","shark"]
        pageController.currentPage = 0
        pageController.numberOfPages = pageImages.count
    }
    @IBAction func previous(sender: UIButton) {
        if pageController.currentPage >= 1 && pageController.currentPage <= pageController.numberOfPages
        {
            let num = pageController.currentPage - 1
            scrollView.contentOffset = CGPointMake(CGFloat(num) * scrollView.frame.size.width,0)
            pageController.currentPage = num
        }
    }
    @IBAction func next(sender: UIButton) {
        if (pageController.currentPage >= 0 && pageController.currentPage < pageController.numberOfPages - 1)
        {
            let num = pageController.currentPage + 1
            scrollView.contentOffset = CGPointMake(CGFloat(num) * scrollView.frame.size.width,0)
            pageController.currentPage = num
        }
    }
    override func viewDidLayoutSubviews() {
        if (!first)
        {
            first = true
            let pagesScrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), 0)
            scrollView.contentOffset = CGPointMake(CGFloat(currentPage) * scrollView.frame.size.width, 0)
            for i in 0..<pageImages.count
            {
                let imgView = UIImageView(image: UIImage(named:pageImages[i]+".jpg"))
                imgView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
                imgView.contentMode = .ScaleAspectFit
                imgView.userInteractionEnabled = true
                imgView.multipleTouchEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                tap.requireGestureRecognizerToFail(doubleTap)
                photo.append(imgView)
                let frontScrollView = UIScrollView(frame: CGRectMake( CGFloat(i) * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height))
                frontScrollView.minimumZoomScale = 1
                frontScrollView.maximumZoomScale = 2
                frontScrollView.delegate = self
                frontScrollView.contentSize = imgView.bounds.size
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
                self.scrollView.addSubview(frontScrollView)
            }
            
        }

    }
    func scrollViewWillBeginDragging(outerScrollView: UIScrollView)
    {
        scrollView.contentOffset = CGPointMake(CGFloat(pageController.currentPage) * scrollView.frame.size.width, 0)
    }
    @IBAction func onChange(sender: AnyObject) {
        scrollView.contentOffset = CGPointMake(CGFloat(pageController.currentPage) * scrollView.frame.size.width, 0)
    }
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        pageController.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return photo[pageController.currentPage]
    }
    func tapImg(gesture: UITapGestureRecognizer)
    {
        let position = gesture.locationInView(photo[pageController.currentPage])
        zoomRectForScale(frontScrollViews[pageController.currentPage].zoomScale * 1.5, center: position)
    }
    func doubleTapImg(gesture: UITapGestureRecognizer)
    {
        let position = gesture.locationInView(photo[pageController.currentPage])
        zoomRectForScale(frontScrollViews[pageController.currentPage].zoomScale * 0.5, center: position)
    }
    func zoomRectForScale(scale: CGFloat,center: CGPoint)
    {
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        frontScrollViews[pageController.currentPage] .zoomToRect(zoomRect, animated: true)

    }

}
