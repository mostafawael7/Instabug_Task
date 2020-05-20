//
//  Movie.swift
//  Instabug Challenge
//
//  Created by Mostafa Hendawi on 5/18/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import Foundation
import UIKit

//struct Image: Codable{
//    let imageData: Data?
//
//    init(withImage image: UIImage) {
//        self.imageData = image.pngData()
//    }
//
//    func getImage() -> UIImage? {
//        guard let imageData = self.imageData else {
//            return nil
//        }
//        let image = UIImage(data: imageData)
//
//        return image
//    }
//}


struct Movie: Codable{
    
    var title: String
    var overview: String
    var date: String
    
//    var poster: Data
    
//    init(title: String, overview: String, date: String, poster: UIImage) {
//        self.title = title
//        self.overview = overview
//        self.date = date
//        self.poster = poster.pngData()!
//    }
}
