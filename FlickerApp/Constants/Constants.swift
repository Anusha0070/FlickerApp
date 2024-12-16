//
//  Constants.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/12/24.
//

enum DataError: Error {
    case invalidURL
    case invalidData
}

enum ServerConstants{
    static let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
}
