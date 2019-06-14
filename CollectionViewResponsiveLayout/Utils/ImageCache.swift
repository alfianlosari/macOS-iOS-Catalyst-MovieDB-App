//
//  ImageCache.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 08/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    private static let imageCache = NSCache<AnyObject, AnyObject>()
    
    public static func downloadImage(url: URL, result: @escaping (Result<UIImage, Error>) -> Void) {
        let urlString = url.absoluteString
        
        if let imageFromCache = ImageCache.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            result(.success(imageFromCache))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                ImageCache.imageCache.setObject(image, forKey: urlString  as AnyObject)
                DispatchQueue.main.async { 
                    result(.success(image))
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                result(.failure(error))
                }
                
                
            }
        }
    }
    
    




}
