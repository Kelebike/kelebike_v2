//
//  WelcomeViewController.swift
//  kelebike
//
//  Created by Mert on 2.12.2022.
//

import UIKit
import FirebaseAuth

extension UIColor {
    // extension to UIColor for easy acces of background color
    static var bgColor = UIColor(red: 201/255, green: 226/255, blue: 101/255, alpha: 1)
    static var accentColor = UIColor(red: 29/255, green: 73/255, blue: 167/255, alpha: 1)
}

class WelcomeViewController: UIViewController {
    
// ======= start of creating UI components ======= //
    
    // bottom bar that holds the buttons and indicator bar
    var bottomControlStackView = UIStackView()
    
    // previous button
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Prev", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.accentColor, for: .normal)
        button.addTarget(self, action: #selector(prevPressed), for: .touchUpInside)

        return button
    }()
    
    // next button
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.accentColor, for: .normal)
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        
        return button
    }()
    
    // page indicator bar
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .accentColor
        pc.pageIndicatorTintColor = .accentColor.withAlphaComponent(0.6)
        pc.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        
        return pc
    }()
    
    lazy var page0: PageView = {
        let view = PageView(imageName: "bike_icon",
                            descriptionHead: "Rent bikes with the kelebike App",
                            descriptionBody: "Welcome to kelebike app. Sign-up with your mail with gtu.edu.tr extension and start riding the school bikes in no time")
        return view
    }()
    
    lazy var page1: PageView = {
        let view = PageView(imageName: "how_icon",
                            descriptionHead: "how to rent",
                            descriptionBody: "okey  ")
        return view
    }()
    
    lazy var page2: PageView = {
        let view = PageView(imageName: "helmet_icon",
                            descriptionHead: "safety",
                            descriptionBody: "okey")
        return view
    }()
    
    lazy var page3: PageView = {
        let view = PageView(imageName: "garage_icon",
                            descriptionHead: "maintenance",
                            descriptionBody: "okey  ")
        return view
    }()
    
// ======= end of creating UI components ======= //
    
    // array of all pages
    lazy var pages = [page0, page1, page2, page3]
    
    // creating and putting all the pages in to a scroll view
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
        
        // add pages to the scroll view in a for loop
        for i in 0..<pages.count {
            scrollView.addSubview(pages[i])
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        scrollView.delegate = self
        return scrollView
    }()
    
    // main view func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor

        setupComponents()
        setupLayout()
    }
    
    // add all the UI components to the view
    func setupComponents() {
        // create a stack view for the bottom conponents
        bottomControlStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlStackView.distribution = .fillEqually
        
        // add scrool view (all the pages)
        view.addSubview(scrollView)
        // add bottom bar
        view.addSubview(bottomControlStackView)
    }
    
    // place constrains for all the object in the view
    func setupLayout() {
        // constraints for scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        // constraints for the page control bar
        bottomControlStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomControlStackView.heightAnchor.constraint(equalToConstant: 50),
            bottomControlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)])
    }
    
    // prev button functionality
    @objc private func prevPressed() {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(pageControl.currentPage - 1)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    // next button functionality
    @objc private func nextPressed() {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(pageControl.currentPage + 1)
        scrollView.scrollRectToVisible(frame, animated: true)
        
        if(pageControl.currentPage == pages.count - 1) {
            performSegue(withIdentifier: "endOfWelcome", sender: nil)
        }
    }
    
    // objective-c code that handles the bottom bar press
    @objc func pageControlTapHandler(sender: UIPageControl){
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

// scroll view delegate to track and update buttom bar index
extension WelcomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if (pageControl.currentPage == pages.count - 1) {
            nextButton.setTitle("I understand", for: .normal)
        }
        else{
            nextButton.setTitle("Next", for: .normal)
        }
    }
}


