//
//  ImageDownloader.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/12/24.
//
import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    private init() {}
    let imageCache = NSCache<NSString, UIImage>()

    func getImage(url: String?, completion:@escaping (UIImage) -> ()) {
        guard let url = url else {
            completion(UIImage(named: "template")!)
            return
        }

        if let cached = imageCache.object(forKey: url as NSString) {
            completion(cached)
            return
        }

        DispatchQueue.global(qos: .background).async {
            if let dataUrl = URL(string: url) {
                do {
                    let data = try Data(contentsOf: dataUrl)
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url as NSString)
                        completion(image)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(UIImage(named: "template")!)
                }
            } else {
                completion(UIImage(named: "template")!)
            }
        }
    }
}


