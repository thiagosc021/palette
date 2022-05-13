//
//  ColorPaletteView.swift
//  Palette
//
//  Created by Thiago Costa on 5/10/22.
//  Copyright © 2022 Cameron Stuart. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {

    //MARK: properties
    var colors: [UIColor]? {
        didSet {
            buildColorBlocks()
        }
    }
    
    //MARK: Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    //MARK: Helper functions
    func buildColorBlocks() {
        guard let colors = colors else {
            return
        }
        resetColorBricks()
        
        for color in colors {
            let colorBlockView = generateColorBlockViews(with: color)
            addSubview(colorBlockView)
            colorStackView.addArrangedSubview(colorBlockView)
        }
        
        layoutIfNeeded()
    }
    
    func generateColorBlockViews(with color: UIColor) -> UIView {
        let colorBlock = UIView()
        colorBlock.backgroundColor = color
        
        return colorBlock
    }
    
    func resetColorBricks() {
        for subview in colorStackView.arrangedSubviews {
            colorStackView.removeArrangedSubview(subview)
        }
    }
    
    func setupView() {
        self.addSubview(colorStackView)
        colorStackView.anchor(top: self.topAnchor,
                              bottom: self.bottomAnchor,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor,
                              paddingTop: 0.0, paddingBottom: 0.0, paddingLeft: 0.0, paddingRight: 0.0)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    //MARK: Views
    let colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        
        return stackView
    }()
    
}
