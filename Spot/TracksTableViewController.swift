//
//  TracksTableViewController.swift
//  Spot
//
//  Created by Kevin Youssef on 8/6/19.
//  Copyright © 2019 Kevin Youssef. All rights reserved.
//

import UIKit
import AVFoundation

var player = AVAudioPlayer()

class TracksTableViewController: UITableViewController {


    @IBOutlet var tracksTableView: UITableView!
    var genreName = ""
    var genreNameDict: [String:String] = ["Pop":"pop","Hip-Hop":"hip-hop","Dance":"dance","Electronic":"electronic","Acoustic":"acoustic","Disney":"disney","Chill":"chill","Work-Out":"world-music","British":"british"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(genreName)
        print(genreNameDict[genreName]!)
        getTrackNames()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.blue
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    var trackName : [String] = []
    var trackArtist: [String] = []
    var trackDuration: [String] = []
    var trackImage: [String] = []
    var trackPreviewURL: [String] = []
    func getTrackNames () -> Void{
        struct Result: Decodable{
            let tracks: Tracks
        }

        struct Tracks: Decodable {
            let items: [Items]

        }
        struct Items: Decodable {
            let name: String
            let duration_ms: Int
            let preview_url: String?
            let album: Album
            let artists: [Artists]
        }
        struct Artists: Decodable {
            let name: String
        }
        struct Album: Decodable {
            let images: [Images]
        }
        struct Images: Decodable {
            let url: String
        }

        let urlString = "https://api.spotify.com/v1/search?q=genre:\(genreNameDict[genreName]!)&limit=50&type=track"
        print(urlString)
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer BQDOYa0jU5Qr2Q0Qw9DN48e1hsvTU10oD0QS1j5lklwZP3v56awcWkHvWr9ZRE_VUuw0PoKdoEgQtRBstPsDun7Xgquc5FseEHE4axyA2XLgYmkWAop9ODWJUgJrk5TM0Y91PjjsDv5Mu6Jgi4o8ytkBCmAsyYH5apw9XYV7TNcz3sAh4R-RPeWI6qmKc6B7BnGA0a7U_Qfx-xsvRh_s6d9xyVruqAJB-On3iIyjSXjixAMeCuVaYc_7BTUWABdsksf8MYulpuT1SfCCXC2zexwkoTGdvBp4", forHTTPHeaderField: "Authorization")

        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in

            if let data = data {
                let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                print("data :\(string1)")
                do{
                    let album = try JSONDecoder().decode(Result.self, from: data)
                    print(album)
                    for i in album.tracks.items{
                        self.trackPreviewURL.append(i.preview_url ?? "")
                        self.trackName.append(i.name)
                        self.trackArtist.append(i.artists[0].name)
                        let time = i.duration_ms/1000
                        let minutes = time/60
                        let seconds = time%60
                        if seconds < 10{
                            self.trackDuration.append("\(minutes):0\(seconds)")
                        } else{
                        self.trackDuration.append("\(minutes):\(seconds)")
                        }
                        self.trackImage.append(i.album.images[0].url)
                    }
//                    for i in 0..<self.trackPreviewURL.count{
//                        if self.trackPreviewURL[i] == ""{
//                            self.trackPreviewURL[i] = ""
//                            self.trackName[i] = ""
//                            self.trackArtist[i] = ""
//                            self.trackDuration[i] = ""
//                            self.trackImage[i] = ""
//                        }
//                        trackPreviewURL.removeAll(where: {""})
//                    }
                    //print(self.trackImage)

                    DispatchQueue.main.async {
                        self.tracksTableView.reloadData()
                    }
                    print(self.trackPreviewURL)
                }
                catch{
                    print("error \(error.localizedDescription)")
                }
            }
        }).resume()
        
        return
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! TracksTableViewCell
        cell2.songTitleLabel?.text = trackName[indexPath.row]
        cell2.artistLabel?.text = trackArtist[indexPath.row]
        cell2.durationLabel?.text = trackDuration[indexPath.row]
        
        let url = NSURL(string: trackImage[indexPath.row])
        if let data = NSData(contentsOf: url! as URL){
            cell2.trackImage.image = UIImage(data: data as Data)
        }
        return cell2
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! AudioViewController
        let url = NSURL(string: trackImage[indexPath!])
        if let data = NSData(contentsOf: url! as URL){
            vc.image = UIImage(data: data as Data)!
            vc.mainSongTitle = trackName[indexPath!]
            vc.ArtistName = trackArtist[indexPath!]
            vc.mainPreviewURL = trackPreviewURL[indexPath!]
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
