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
    private var cell = ItemCollectionViewCell()
    let defaults = UserDefaults.standard
    
    var hairImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
    
    var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "head1")
        return imageView
    }()
    
    var neckImageView: UIImageView = {
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
        view.addSubview(neckImageView)
        view.addSubview(hairImageView)
        view.addSubview(headImageView)
        view.addSubview(eyeglassesImageView)
        
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
        hairImageView.translatesAutoresizingMaskIntoConstraints = false
        faceImageView.translatesAutoresizingMaskIntoConstraints = false
        shirtImageView.translatesAutoresizingMaskIntoConstraints = false
        pantsImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        headImageView.translatesAutoresizingMaskIntoConstraints = false
        neckImageView.translatesAutoresizingMaskIntoConstraints = false
        wingsImageView.translatesAutoresizingMaskIntoConstraints = false
        eyeglassesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50),
            userIconImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -view.frame.height/30),
            userIconImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75),
            userIconImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            
            hairImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            hairImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            hairImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            hairImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
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
            
            headImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            headImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            headImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            headImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            neckImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            neckImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            neckImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            neckImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            wingsImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            wingsImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            wingsImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            wingsImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor),
            
            eyeglassesImageView.centerXAnchor.constraint(equalTo: userIconImageView.centerXAnchor),
            eyeglassesImageView.centerYAnchor.constraint(equalTo: userIconImageView.centerYAnchor),
            eyeglassesImageView.topAnchor.constraint(equalTo: userIconImageView.topAnchor),
            eyeglassesImageView.leftAnchor.constraint(equalTo: userIconImageView.leftAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        let item = items[indexPath.row]
        guard let cellImage = item.thumbnailImage else { return cell }
        let cellPoint = item.point
        let cellName = item.name
        cell.configure(name: cellName, image: cellImage, point: cellPoint)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item.type {
        case .hair:
            hairImageView.image = item.image
        case .face:
            faceImageView.image = item.image
        case .shirt:
            shirtImageView.image = item.image
        case .pants:
            pantsImageView.image = item.image
        case .shoes:
            shoesImageView.image = item.image
        case .head:
            headImageView.image = item.image
        case .neck:
            neckImageView.image = item.image
        case .wings:
            wingsImageView.image = item.image
        case .eyeglasses:
            eyeglassesImageView.image = item.image
        }
    
        let db = Firestore.firestore()
        
        //get no of points from Firestore to local storage
        let docRef = db.collection("users").document(Constants.uID!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //update purchased items after purchase
                var newPurchase = Constants.purchasedItem
                if !newPurchase.contains(item.name) {
                    newPurchase.append(item.name)
                    //update point after purchase
                    let newPoints = (Constants.points ?? 0) - item.point
                    db.collection("users").document(Constants.uID!).updateData([
                        "purchasedItem": newPurchase
                    ])
                    db.collection("users").document(Constants.uID!).updateData([
                        "points": newPoints
                    ]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Purchase made, now: \(newPoints)")
                            self.pointsLabel.text = "You have \(newPoints) points!"
                            Constants.points = newPoints
                            print ("purchased \(item.name)")
                            Constants.purchasedItem = newPurchase
                            collectionView.reloadData()
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
