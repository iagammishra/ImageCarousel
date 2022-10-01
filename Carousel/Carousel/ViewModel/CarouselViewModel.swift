//
//  CarouselViewModel.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import Foundation

struct CarouselViewModel {
    var model = CarouselModel()
    mutating func filterData(text: String) {
        self.model.arrayList = self.model.imageList.filter { ($0.description ?? "").lowercased().contains(text.lowercased()) }
    }
    mutating func fetchAllImages(callBack: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if let url = Bundle.main.url(forResource: "ImagesData", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(ImageResponseData.self, from: data)
                    guard let carousel = jsonData.carousel else {
                        callBack(false, "Unable to fetch data")
                        return
                    }
                    self.model.carouselData = carousel
                    callBack(true, nil)
                } catch {
                    print("error:\(error)")
                    callBack(false, error.localizedDescription)
                }
            }
        else {
            callBack(false, "File not found")
        }
    }
}
