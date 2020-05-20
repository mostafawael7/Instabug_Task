//
//  Networking.swift
//  Instabug Challenge
//
//  Created by Mostafa Hendawi on 5/18/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import Foundation
import UIKit

class Networking{
    
    let baseUrl = URL(string: "http://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c53e6604e4985b6989e2")
    let posterUrl = URL(string: "http://image.tmdb.org/t/p/original")
    
    func getMovies(page: String, onCompletion: @escaping ([Movie],[UIImageView]) -> ()){
        
        var movies = [Movie]()
        var images = [UIImageView]()
        
        var request = URLRequest(url: URL(string: baseUrl!.absoluteString + "&page=\(page)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                //An error occurred
                print("Error1: \(String(describing: error))")
                onCompletion(movies, images)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                //Wrong Response
                print("Error2: \(String(describing: error))")
                onCompletion(movies, images)
                return
            }
            guard let data = data else {
                print("Error3: \(String(describing: error))")
                onCompletion(movies, images)
                return
            }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                let results = jsonResponse["results"] as! [[String: Any]]
                for result in results{
                    let movie = Movie(title: result["title"] as! String,
                                      overview: result["overview"] as! String,
                                      date: result["release_date"] as! String)
                    let image = UIImageView()
                    image.load(url: URL(string: self.posterUrl!.absoluteString + (result["poster_path"] as! String))!)
                    images.append(image)
                    movies.append(movie)
                }
                DispatchQueue.global(qos: .background).async {
                    onCompletion(movies, images)
                }
            } catch{
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
