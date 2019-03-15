/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Table section header view calss, used in MainViewController for topic editing.
 */

import UIKit

class TopicSectionTitleButton: UIButton {
    
    let xoffset: CGFloat = -8.0, space: CGFloat = 20.0
    let imageSideLength: CGFloat = 28.0

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let sectionTitleView = superview as? TopicSectionTitleView {
            if sectionTitleView.editingStyle == .none {
                return super.titleRect(forContentRect: contentRect)
            }
        }
        let yoffset: CGFloat = (contentRect.height - imageSideLength) / 2.0
        return CGRect(x: xoffset, y: yoffset, width: imageSideLength, height: imageSideLength)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let sectionTitleView = superview as? TopicSectionTitleView {
            if sectionTitleView.editingStyle == .none {
                return super.titleRect(forContentRect: contentRect)
            }
        }
        return CGRect(x: contentRect.origin.x + xoffset + imageSideLength + space,
                      y: contentRect.origin.y,
                      width: contentRect.size.width - xoffset, height: contentRect.size.height)
    }
}

class TopicSectionTitleView: UIView {

    enum EditingStyle {
        case none, inserting, deleting
    }
    
    @IBOutlet weak var titleButton: TopicSectionTitleButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private(set) var editingStyle: EditingStyle = .none
    var section: Int = -1
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1) //R =G = B = 247/255
        titleButton.setTitleColor(.black, for: .normal)
        shareButton.alpha = 0.0
    }
    
    func setEditingStyle(_ newStyle: EditingStyle, title: String) {
        
        editingStyle = newStyle
        
        switch newStyle {
        case .none:
            titleButton.setTitle(title, for: .normal)
            titleButton.setImage(nil, for: .normal)
            shareButton.alpha = 1.0
            
        case .inserting:
            titleButton.setTitle(title, for: .normal)
            titleButton.setImage(UIImage(named: AssetNames.add), for: .normal)

        case .deleting:
            titleButton.setTitle(title, for: .normal)
            titleButton.setImage(UIImage(named: AssetNames.cross), for: .normal)
            titleButton.tintColor = .red
        }
    }
}
