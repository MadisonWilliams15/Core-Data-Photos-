//
//  Recipe+CoreDataClass.swift
//  Core Data Photos
//
//  Created by Madison Williams on 3/19/19.
//  Copyright © 2019 Madison Williams. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Recipe)
public class Recipe: NSManagedObject {
    var image: UIImage? {
        get {
            if let imageData = picture as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                picture = convertImage(image: image)
            }
        }
    }
    
    func convertImage(image: UIImage) -> NSData? {
        if (image.imageOrientation == .up) {
            return image.pngData() as NSData?
        }
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image.pngData() as NSData?
        }
        return unwrappedCopy.pngData() as NSData?
    }
    
    convenience init?(title:String, ingredients:String?, directions:String?, image: UIImage?) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext, !title.isEmpty else {
            return nil
        }
        
        self.init(entity: Recipe.entity(), insertInto: managedContext)
        self.title = title
        self.ingredients = ingredients
        self.directions = directions
        
        if let image = image {
            self.picture = convertImage(image: image)
        }
    }
    
    func update(title:String, ingredients:String?, directions:String?, image : UIImage?) {
        self.title = title
        self.ingredients = ingredients
        self.directions = directions
        
        if let image = image {
            self.picture = convertImage(image: image)
        }
        
    }
}
