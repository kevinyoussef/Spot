//
//  AudioViewController.swift
//  Spot
//
//  Created by Kevin Youssef on 8/7/19.
//  Copyright © 2019 Kevin Youssef. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    @IBOutlet weak var playpausebtn: UIButton!
    var image = UIImage()
    var mainSongTitle = String()
    var ArtistName = String()
    var mainPreviewURL = String()
    var downloaded = false
    
    let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.white,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : -1.0]
        
        as [NSAttributedString.Key : Any]
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var Artist: UILabel!
    @IBOutlet weak var songUnavailable: UILabel!
    @IBOutlet weak var timeTracker: UILabel!
    @IBOutlet weak var negativeTimeTracker: UILabel!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        self.timeTracker.attributedText = NSMutableAttributedString(string: "0:00", attributes: self.strokeTextAttributes)
        self.negativeTimeTracker.attributedText = NSMutableAttributedString(string: "-0:30", attributes: self.strokeTextAttributes)
        songTitle.attributedText = NSMutableAttributedString(string: mainSongTitle, attributes: strokeTextAttributes)
        Artist.attributedText = NSMutableAttributedString(string: ArtistName, attributes: strokeTextAttributes)
        songUnavailable.attributedText = NSMutableAttributedString(string: "Sorry, Song Unavailable 😥", attributes: strokeTextAttributes)
        songUnavailable.isHidden = true
        background.image = image
        mainImageView.image = image
        
        if mainPreviewURL != ""{
            downloadFileFromURL(url: URL(string: mainPreviewURL)!)
            
            songUnavailable.isHidden = true
            playpausebtn.isHidden = false
            trackSlider.isHidden = false
            timeTracker.isHidden = false
            negativeTimeTracker.isHidden = false
            playpausebtn.setAttributedTitle(NSMutableAttributedString(string: "Pause", attributes: strokeTextAttributes), for: .normal)
            playpausebtn.layer.cornerRadius = 5
            
        }
        if mainPreviewURL == ""{
            playpausebtn.isHidden = true
            trackSlider.isHidden = true
            songUnavailable.isHidden = false
            timeTracker.isHidden = true
            negativeTimeTracker.isHidden = true
        }
        
        trackSlider!.minimumValue = Float(0)
        trackSlider!.maximumValue = Float(30)
        trackSlider.isContinuous = true
        trackSlider.value = Float(0)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.downloaded{
                let timer2 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    var remainingTime = 30 - Int(player.currentTime)
                    self.trackSlider.value = Float(player.currentTime)
                    if Int(player.currentTime)<10{
                        self.timeTracker.attributedText = NSMutableAttributedString(string: "0:0\(Int(player.currentTime))", attributes: self.strokeTextAttributes)
                    }
                    else{
                    self.timeTracker.attributedText = NSMutableAttributedString(string: "0:\(Int(player.currentTime))", attributes: self.strokeTextAttributes)
                    }
                    if remainingTime < 10{
                    self.negativeTimeTracker.attributedText = NSMutableAttributedString(string: "-0:0\(remainingTime)", attributes: self.strokeTextAttributes)
                    }
                    else{
                    self.negativeTimeTracker.attributedText = NSMutableAttributedString(string: "-0:\(remainingTime)", attributes: self.strokeTextAttributes)
                    }
                }
                self.downloaded = false
            }
        }
    }

    

    func downloadFileFromURL(url: URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { customURL, response, error in
            self.play(url: customURL!)
            self.downloaded = true
        })
        downloadTask.resume()
        
    }
    
    func play(url: URL){
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func pauseplay(_ sender: Any) {
        
        if mainPreviewURL == ""{
        }
        else if player.isPlaying {
            player.pause()
playpausebtn.setAttributedTitle(NSMutableAttributedString(string: "Play", attributes: strokeTextAttributes), for: .normal)        }
        else{
            player.play()
playpausebtn.setAttributedTitle(NSMutableAttributedString(string: "Pause", attributes: strokeTextAttributes), for: .normal)        }
    }
 
    @IBAction func changeAudioTime(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(trackSlider.value)
        player.prepareToPlay()
        player.play()
        playpausebtn.setAttributedTitle(NSMutableAttributedString(string: "Pause", attributes: strokeTextAttributes), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
}

