//
//  FlickerModel.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/12/24.
//
struct FlickerModel: Codable{
    let title: String?
    let link: String?
    let description: String?
    let modified: String?
    let generator: String?
    let items: [Items]
}

struct Items: Codable{
    let title: String?
    let link: String?
    let media: Media?
    let date_taken: String?
    let description: String?
    let published: String?
    let author: String?
    let author_id: String?
    let tags: String?
}

struct Media: Codable{
    let m: String?
}
