//
//  Item.swift
//  Technovation
//
//  Created by Vicky Liu on 9/29/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class Item {
    let name: String
    let type: ItemType
    let image: UIImage?
    let thumbnailImage: UIImage?
    let point: Int
    
    init(name: String, type: ItemType, image: UIImage?, thumbnailImage: UIImage?, point: Int) {
        self.name = name
        self.type = type
        self.image = image
        self.thumbnailImage = thumbnailImage
        self.point = point
    }
    
    static let items: [Item] = [
        
        //Hairstyles
        Item(name: "hair1", type: .hair, image: UIImage(named: "hair1"), thumbnailImage: UIImage(named: "hair1thumb"), point: 20),
        Item(name: "hair2", type: .hair, image: UIImage(named: "hair2"), thumbnailImage: UIImage(named: "hair2thumb"), point: 20),
        
        //Faces
        Item(name: "face1", type: .face, image: UIImage(named: "face1"), thumbnailImage: UIImage(named: "face1thumb"), point: 0),
        Item(name: "face2", type: .face, image: UIImage(named: "face2"), thumbnailImage: UIImage(named: "face2thumb"), point: 5),
        Item(name: "face3", type: .face, image: UIImage(named: "face3"), thumbnailImage: UIImage(named: "face3thumb"), point: 5),
        
        //Shirts
        Item(name: "shirt1", type: .shirt, image: UIImage(named: "shirt1"), thumbnailImage: UIImage(named: "shirt1thumb"), point: 30),
        Item(name: "shirt2", type: .shirt, image: UIImage(named: "shirt2"), thumbnailImage: UIImage(named: "shirt2thumb"), point: 30),
        
        //Pants
        Item(name: "pants1", type: .pants, image: UIImage(named: "pants1"), thumbnailImage: UIImage(named: "pants1thumb"), point: 30),
        Item(name: "pants2", type: .pants, image: UIImage(named: "pants2"), thumbnailImage: UIImage(named: "pants2thumb"), point: 30),
        
        //Shoes
        Item(name: "shoes1", type: .shoes, image: UIImage(named: "shoes1"), thumbnailImage: UIImage(named: "shoes1thumb"), point: 20),
        Item(name: "shoes2", type: .shoes, image: UIImage(named: "shoes2"), thumbnailImage: UIImage(named: "shoes2thumb"), point: 20),
        Item(name: "shoes3", type: .shoes, image: UIImage(named: "shoes3"), thumbnailImage: UIImage(named: "shoes3thumb"), point: 20),
        
        //Head accessories
        Item(name: "head1", type: .head, image: UIImage(named: "head1"), thumbnailImage: UIImage(named: "head1thumb"), point: 0),
        Item(name: "head2", type: .head, image: UIImage(named: "head2"), thumbnailImage: UIImage(named: "head2thumb"), point: 10),
        
        //Neck accessories
        Item(name: "neck1", type: .neck, image: UIImage(named: "neck1"), thumbnailImage: UIImage(named: "neck1thumb"), point: 20),
        Item(name: "neck2", type: .neck, image: UIImage(named: "neck2"), thumbnailImage: UIImage(named: "neck2thumb"), point: 20),
        
        //Wings
        Item(name: "wings1", type: .wings, image: UIImage(named: "wings1"), thumbnailImage: UIImage(named: "wings1thumb"), point: 40),
        Item(name: "wings2", type: .wings, image: UIImage(named: "wings2"), thumbnailImage: UIImage(named: "wings2thumb"), point: 40),
        
        //Eyeglasses
        Item(name: "eyeglasses1", type: .eyeglasses, image: UIImage(named: "eyeglasses1"), thumbnailImage: UIImage(named: "eyeglasses1thumb"), point: 10),
        Item(name: "eyeglasses2", type: .eyeglasses, image: UIImage(named: "eyeglasses2"), thumbnailImage: UIImage(named: "eyeglasses2thumb"), point: 10)
    ]
}


