//
//  PaletteViewController.swift
//  Palette
//
//  Created by Thiago Costa on 5/9/22.
//  Copyright © 2022 Cameron Stuart. All rights reserved.
//

import UIKit

class PaletteViewController: UIViewController {
    
    //MARK: Properties
    var safeArea: UILayoutGuide {
        self.view.safeAreaLayoutGuide
    }
    private var buttons: [UIButton: UnsplashRoute] {
        [featureButton: .featured, randomButton: .random, doubleRainbowButton: .doubleRainbow]
    }
    var photos: [UnsplashPhoto] = []
    
    //MARK: Lifecycles
    override func loadView() {
        super.loadView()
        
        addAllSubviews()
        setButtomStackView()
        constrainTableView()
        configureTableView()
        activateButtons()
        fectchUnsplash(.featured)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemIndigo
    }
    
    //MARK: Helper functions
    func activateButtons() {
        buttons.keys.forEach({ $0.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside) })
        featureButton.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
    
    @objc func selectButton(sender: UIButton) {
        buttons.keys.forEach({ $0.setTitleColor(.lightGray, for: .normal) })
        sender.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
        fectchUnsplash(buttons[sender] ?? .featured)
    }
    
    func fectchUnsplash(_ unsplashCategory: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: unsplashCategory) { photos in
            DispatchQueue.main.async {
                guard let photos = photos else {
                    return
                }
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
    
    func addAllSubviews() {
        view.addSubview(featureButton)
        view.addSubview(randomButton)
        view.addSubview(doubleRainbowButton)
        view.addSubview(buttonStackView)
        view.addSubview(paletteTableView)
    }
    
    func setButtomStackView() {
        buttonStackView.addArrangedSubview(featureButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        
        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16.0).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8.0).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8.0).isActive = true
    }
    
    func constrainTableView() {
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0.0, paddingBottom: 0.0, paddingLeft: 0.0, paddingRight: 0.0)
    }
    
    func configureTableView() {
        paletteTableView.delegate = self
        paletteTableView.dataSource = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "photoCell")
    }
    
    //MARK: - Views
    let featureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Features", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
  
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Random", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Double Rainbow", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let paletteTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()

}

extension PaletteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PaletteTableViewCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]

        cell.photo = photo
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace = view.frame.width - (2 * SpacingConstants.outerHorizontalPadding) //image is a square
        let labelSpace = SpacingConstants.smallElementHeight
        let colorPaletteSpace = SpacingConstants.mediumElementHeight
        
        return imageViewSpace + (2 * SpacingConstants.outerVerticalPadding) + SpacingConstants.verticalObjectBuffer + labelSpace + SpacingConstants.verticalObjectBuffer + colorPaletteSpace
    }
}
