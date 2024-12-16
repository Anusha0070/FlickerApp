//
//  FlickrVM.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/12/24.
//

import Foundation
import UIKit


class FlickrVM{
    
    var networkManager : Network? = NetworkManager.sharedInstance
    var flickrData : FlickerModel?
    var onDataUpdated: (() -> Void)?
    
    var defaultSearch : String = "flowers"
    var serverURL : String = ""
    var searchTimer: Timer?
    
    var onSearchStarted: (() -> Void)? // Closure to notify search started

    @MainActor
    func getFlickrData(url : String){
        self.onSearchStarted?()
        serverURL = url + defaultSearch
        print(serverURL)
        Task{
            do {
                let flickrData: FlickerModel? = try await networkManager?.fetchData(from: serverURL)
                self.flickrData = flickrData
                onDataUpdated?()
            } catch{
                print("Error is:\(error)")
            }
        }
    }
    
    func getDataCount() -> Int{
        return flickrData?.items.count ?? 0
    }
    
    func getFlickrItem(index: Int) -> Items?{
        return flickrData?.items[index]
    }
    
    
    func getFilteredImages(searchText: String){
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            if searchText.isEmpty{
                self.defaultSearch = "flowers"
            } else{
                self.defaultSearch = searchText.lowercased()
            }
            Task{
                await self.getFlickrData(url: ServerConstants.baseURL)
            }
        }

    }
    
    func cleanedImageDetails(index: Int) -> [String: String]{
        let data = flickrData?.items[index]
        var cleanedData : [String: String] = [:]
        cleanedData["publishedDate"] = String(data?.published?.split(separator: "T").first ?? "")
        
        guard let input = data?.author else {
            return [:]
        }

        if let startRange = input.range(of: "\""),
           let endRange = input.range(of: "\"", range: startRange.upperBound..<(input.endIndex )) {
            let substring = input[startRange.upperBound..<endRange.lowerBound]
            cleanedData["author"] = String(substring)
        }
        
        cleanedData["title"] = data?.title
        cleanedData["imgURL"] = data?.media?.m
        return cleanedData
    }
    
}
