//
//  ImageProvider.swift
//  Presidents
//
//  Created by Kurt McMahon on 10/26/16.
//  Copyright © 2016 Northern Illinois University. All rights reserved.
//

import Foundation
import UIKit

class ImageProvider {
    
    // Singleton property that can be used to access the ImageProvider object
    static let sharedInstance = ImageProvider()
    
    // Image cache
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // Gets an image. Arguments are the image URL as a string, and a closure
    // to execute if the image is successfully obtained.
    func imageWithURLString(urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        // If the image is stored in the image cache, retrieve it
        if urlString == "None" {
            completion(UIImage(named: "default.png"))
        } else if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(cachedImage)
        } else {
            
            // Otherwise, try to download the image from the provided URL
            weak var weakSelf = self
            
            let session = URLSession.shared
            
            if let url = NSURL(string: urlString) {
                //let task = session.dataTaskWithURL(url) {
                let task = session.dataTask(with: url as URL) {
                    (data, response, error) in
                    let httpResponse = response as? HTTPURLResponse
                    if httpResponse!.statusCode != 200 {
                        // Download failed, so perform some error handling
                        DispatchQueue.main.async {
                            print("HTTP Error: status code \(httpResponse!.statusCode).")
                            completion(UIImage(named: "default.png"))
                        }
                    } else if (data == nil && error != nil) {
                        // Download failed, so perform some error handling
                        DispatchQueue.main.async() {
                            print("No image data downloaded for image \(urlString).")
                            completion(UIImage(named: "default.png"))
                        }
                    } else {
                        // Download succeeded; attempt to converte data to
                        // an image and call the completion closure on the
                        // main thread.
                        if let image = UIImage(data: data!) {
                            DispatchQueue.main.async {
                                weakSelf!.imageCache.setObject(image, forKey: urlString as AnyObject)
                                completion(image)
                            }
                        }
                    }
                }
                task.resume()
            } else {
                // Invalid URL string, so perform some error handling
                print("Invalid URL \(urlString).")
                completion(UIImage(named: "default.png"))
                //completion(image: UIImage(named: "default.png"))
            }
        }
    }
    
    // Call this method to clear the cache on a memory warning.
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
