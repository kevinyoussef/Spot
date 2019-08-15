//
//  ViewController.swift
//  Spot
//
//  Created by Kevin Youssef on 8/5/19.
//  Copyright © 2019 Kevin Youssef. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        

    }
    
    
    
    
    var genres:[String] = ["Pop","Hip-Hop","Dance","Electronic","Acoustic","Disney","Chill","Work-Out","British"]
    var imageURL: [String] = ["Pop","Hip-Hop","Dance","Electronic","Acoustic","Disney","Chill","Work-Out","British"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.genreLabel.text = genres[indexPath.row]

        
        
        
        cell.genreImage.image = UIImage(named: imageURL[indexPath.row])
        
    
//        let url = NSURL(string: imageURL[indexPath.row])
//        if let data = NSData(contentsOf: url! as URL){
//            cell.genreImage.image = UIImage(data: data as Data)
//        }
        
        
//        cell.layer.borderColor = UIColor.white.cgColor
//        cell.layer.cornerRadius = 15
        cell.genreImage.layer.cornerRadius = 15
        cell.genreImage.clipsToBounds = true
//        cell.genreImage.layer.shadowOpacity = 1
//        cell.genreImage.layer.shadowRadius = 200
//        cell.genreImage.layer.shadowOffset = .zero
//        cell.genreImage.layer.shadowColor = UIColor.white.cgColor
 //      cell.layer.borderWidth = 1
//        cell.layer.shadowColor = UIColor.white.cgColor
//        cell.layer.shadowOffset = .zero
//        cell.layer.shadowRadius = 100
//        cell.layer.shadowOpacity = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "TracksPage") as? TracksTableViewController
        
        viewController?.genreName = genres[indexPath.row]
    self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func getAlbumNames () -> Void{
    struct Result: Decodable{
        let albums: [Album]
    }
    
    struct Album: Decodable {
        let name: String
        let id: String
        let images: [Images]
    
    }
        struct Images: Decodable {
            let url: String
        }

    let urlString = "https://api.spotify.com/v1/albums?ids=6KT8x5oqZJl9CcnM66hddo%2C6R8UeugxGTPvPwFkLVqUqs%2C40vQONzvJb6sKejDN3eWza%2C0xzScN8P3hQAz3BT3YYX5w%2C2ZaX1FdZCwchXl1QZiD4O4%2C7G9QcvG6U223NqJzVIMNrZ%2C5658aM19fA3JVwTK6eQX70%2C4GrFuXwRmEBJec22p58fsD&market=ES"
    let session = URLSession.shared
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer BQArb7cyAjr0N8R-9dJoO8wVfm2vTkHkIuAbtLm6yeITIwXgGgSjLIb9RpbLjlxkgoSRCiXn8u9IthaO7YdvqmOo_Gjz6cFsQ3ZubuFYfRcbY1qih78tCLtpSY9IHeMj8UGxMzPKFnF2eWqN3NBf4b7CvuhEFjkHLwsSg8IaAlRffpL1D4HB0QT43mIYDGVv_IAxV50svcwcHyfrSq749q7aS_2pC4EfQ8KMEMAPPGp_cSmxCKP-g1Q8uOvStD3-TLGdi5iD_i01WLCHZogxRo0yC4PT8afA", forHTTPHeaderField: "Authorization")
    
    session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
    
    if let data = data{
    do{
    let album = try JSONDecoder().decode(Result.self, from: data)
    for item in album.albums{
        self.genres.append(item.name)
        self.imageURL.append(item.images[0].url)
    }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    catch{
        print(error)
    }
        }
    }).resume()
    return
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width-20) / 2 , height: self.collectionView.frame.size.height/3)
    }
}



/*

curl -X "GET" "https://api.spotify.com/v1/search?q=genre:pop%20artist:Billie&type=artist" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer BQDxAkpU6TAe-gKxt-YsHdBxEYVXuaphCw6BdM-e3GTWp9VY5T3ibbvuBAZplAmEy_bWVcvRXTzGfqePUgJvxmJ4-h6HOuZC6Wx8t52lIJPSOvS8V0J0vsq9siDp6u3rx4K2Jx1H22AU2XcU35FEgDT3gYVRVc3BXfW5j3R9JvQ0CR3xMlGgtu85DQFXKG0y3dFsIyDF3P6OhtYeK004QBGZrlAizMN6hsYx1ej7z7VFjD-o2bWPRKTHFoVPW5OhGdARdT5IEVc3s26AILelu0GUKLQXvego"
*/
