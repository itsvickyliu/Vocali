//
//  UserInfoViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/30/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserInfoViewController : UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    private var collectionView: UICollectionView?
    private var items = Item.items
    
    var faceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "face1")
        return imageView
    }()
    
    var shirtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var pantsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var shoesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var hatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "hat1")
        return imageView
    }()
    
    var scarfImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var wingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var eyeglassesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //self.edgesForExtendedLayout = .bottom
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize (width: 70, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor(cgColor: Constants.red)
        guard let myCollection = collectionView else {
            return
        }
        print(myCollection.frame)
        view.addSubview(myCollection)
        view.addSubview(faceImageView)
        view.addSubview(wingsImageView)
        view.addSubview(pantsImageView)
        view.addSubview(shirtImageView)
        view.addSubview(shoesImageView)
        view.addSubview(hatImageView)
        view.addSubview(scarfImageView)
        view.addSubview(eyeglassesImageView)
        view.addSubview(accessoryImageView)
        
        addConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        let frameY = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        collectionView?.frame = CGRect(x: view.frame.size.width-100, y: frameY, width: 100, height: view.frame.size.height - frameY).integral
    }
    
    func setupUI(){
        pointsLabel.text = "You have \(Constants.points ?? 0) points!"
        pointsLabel.font = UIFont(name: "FredokaOne-Regular", size: 25)
        pointsLabel.textColor = UIColor(cgColor: Constants.red)
    }
    
    func addConstraints() {
        userIconImageView.translatesAutoresizingMaskIntoConstraints = false
        faceImageView.translatesAutoresizingMaskIntoConstraints = false
        shirtImageView.translatesAutoresizingMaskIntoConstraints = false
        pantsImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        hatImageView.translatesAutoresizingMaskIntoConstraints = false
        scarfImageView.translatesAutoresizingMaskIntoConstraints = false
        wingsImageView.translatesAutoresizingMaskIntoConstraints = false
        eyeglassesImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50),
            userIconImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -view.frame.height/30),
            userIconImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75),
            userIconImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            
            faceImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            faceImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            faceImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            faceImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            shirtImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            shirtImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            shirtImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            shirtImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            pantsImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            pantsImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            pantsImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            pantsImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            shoesImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            shoesImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            shoesImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            shoesImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            hatImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            hatImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            hatImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            hatImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            scarfImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            scarfImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            scarfImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            scarfImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            wingsImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            wingsImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            wingsImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            wingsImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            eyeglassesImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            eyeglassesImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            eyeglassesImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            eyeglassesImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            accessoryImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            accessoryImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            accessoryImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            accessoryImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        let item = items[indexPath.row]
        guard let image = item.thumbnailImage else { return cell }
        cell.configure(with: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item.type {
        case .face:
            faceImageView.image = item.image
        case .shirt:
            shirtImageView.image = item.image
        case .pants:
            pantsImageView.image = item.image
        case .shoes:
            shoesImageView.image = item.image
        case .hat:
            hatImageView.image = item.image
        case .scarf:
            scarfImageView.image = item.image
        case .wings:
            wingsImageView.image = item.image
        case .eyeglasses:
            eyeglassesImageView.image = item.image
        case .accessory:
            accessoryImageView.image = item.image
        }
    }
}
