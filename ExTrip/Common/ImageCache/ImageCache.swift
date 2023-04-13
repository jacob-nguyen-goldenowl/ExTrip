//
//  CachedImage.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

final class ImageCache {
    
    enum APIError: Error {
        case errorImage
    }
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    private let initiatedQueue = DispatchQueue.global(qos: .userInitiated)
    
    static let shared = ImageCache()
    
    private init() {}
        
    func loadImage(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        if let image = self.imageCache.object(forKey: urlString as NSString) {
            completion(.success(image))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.errorImage))
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.errorImage))
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                    completion(.success(image))
                } else {
                    completion(.failure(APIError.errorImage))
                }
            } else {
                completion(.failure(APIError.errorImage))
            }
        }
        task.resume()
    }
    
}
