//
//  CarouselModel.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import Foundation
struct CarouselModel {
    var carouselData = [CarouselData]()
    var imageList = [ImageData]()
    var arrayList = [ImageData]()
}

struct ImageResponseData: Codable {
    var carousel: [CarouselData]?
}

struct CarouselData: Codable {
    var mainImage: String?
    var images: [ImageData]?
}

struct ImageData: Codable {
    var description: String?
    var imageUrl: String?
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image-url"
        case description
    }
}
