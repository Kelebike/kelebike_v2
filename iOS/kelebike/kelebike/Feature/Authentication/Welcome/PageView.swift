//
//  PageView.swift
//  kelebike
//
//  Created by Mert on 2.12.2022.
//

import UIKit

// UI view that is the template of every welcome page
class PageView: UIView {
    
    private weak var imageView: UIImageView!
    private weak var descriptionTextView: UITextView!
    
    var imageName: String
    var descriptionHead: String
    var descriptionBody: String

    init(imageName: String, descriptionHead: String, descriptionBody: String) {
        self.imageName = imageName
        self.descriptionHead = descriptionHead
        self.descriptionBody = descriptionBody
        
        super.init(frame: CGRect())
        
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // get image and load it
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: imageName))
        imageView.contentMode = .scaleAspectFit
        //imageView.backgroundColor = .bgColor
        
        // set description text and style
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string: descriptionHead, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        attributedText.append(NSAttributedString(string: "\n\n\n" + descriptionBody, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.systemGray6 ]))
        
        textView.attributedText = attributedText
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .bgColor
        textView.textColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false        

        // add both image and text on the page
        self.imageView = imageView
        addSubview(self.imageView)
        
        self .descriptionTextView = textView
        addSubview(self.descriptionTextView)
    }
    
    private func setupLayout(){
        // constraints for the image
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 75),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)])
        
        // constraints for the description text
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 75),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
