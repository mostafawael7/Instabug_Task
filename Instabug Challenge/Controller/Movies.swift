//
//  ViewController.swift
//  Instabug Challenge
//
//  Created by Mostafa Hendawi on 5/17/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import UIKit

class Movies: UIViewController {

    struct customized {
        static var customMovies = [Movie]()
        static var customImages = [UIImageView]()
    }
    
    @IBOutlet weak var tableView: UITableView!
    var loadingView: UIView!
    
    var movies = [Movie]()
    var images = [UIImageView]()
    var page = 1
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        ///Set a title for the nav bar
        navigationItem.title = "TMDB"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        ///Load Movies
        Networking().getMovies(page: String(page), onCompletion: { (moviesData, imagesData) in
            self.movies = moviesData
            self.images = imagesData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        ///Set the refresh indicator
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func showLoading() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.75
        loadingView.layer.cornerRadius = 10
        let loadingLabel = UILabel()
        loadingLabel.text = "Loading.."
        loadingLabel.sizeToFit()
        loadingLabel.textColor = UIColor.white
        loadingLabel.frame.origin = CGPoint(x: 10, y: 10)
        loadingView.addSubview(loadingLabel)
        self.view.addSubview(loadingView)
        tableView.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        loadingView.removeFromSuperview()
        tableView.isUserInteractionEnabled = true
    }
    
    @objc func refresh(sender:AnyObject) {
        showLoading()
        page += 1
        print("page: \(page)")
        Networking().getMovies(page: String(page), onCompletion: { (moviesData, imagesData) in
            self.movies = moviesData
            self.images = imagesData
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.hideLoading()
            }
        })
    }
    
    @IBAction func addMovieButton(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMovie") as! AddMovie
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Movies: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return Movies.customized.customMovies.count
        } else {
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "My Movies"
        } else {
            return "All Movies"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell else{
            fatalError("An error occurred while instantiating the cell")
        }
        let singleMovie = indexPath.section == 0 ? Movies.customized.customMovies[indexPath.row] : movies[indexPath.row]
        cell.posterImage!.image = indexPath.section == 0 ? Movies.customized.customImages[indexPath.row].image : images[indexPath.row].image
        cell.movieName.text = singleMovie.title
        cell.movieDate.text = singleMovie.date
        cell.movieOverview.text = singleMovie.overview
        return cell
    }
}
