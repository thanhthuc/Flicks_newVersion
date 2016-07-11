//
//  DetailNowPlayingVC.swift
//  Flicks
//
//  Created by Nguyen Thanh Thuc on 11/07/2016.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import AFNetworking

class DetailNowPlayingVC: UIViewController {
    
    var dataDetailNowPlaying: NSDictionary!
    
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var nameFilmLabel: UILabel!
    @IBOutlet weak var dateFilm: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrlString = self.dataDetailNowPlaying["poster_path"] as! String
        let realURLString = "https://image.tmdb.org/t/p/w342" + imageUrlString
        let imageUrl = NSURL(string: realURLString)
        imagePoster?.setImageWithURL(imageUrl!)
        
        self.nameFilmLabel.text = self.dataDetailNowPlaying["original_title"] as? String
        //release_date
        self.dateFilm.text = self.dataDetailNowPlaying["release_date"] as? String
        //vote_average
        self.rateLabel.text = self.dataDetailNowPlaying["vote_average"] as? String
        
        self.hourLabel.text = "1 hour 30 min"
        
        self.overviewLabel.text = self.dataDetailNowPlaying["overview"] as? String
    }
    
    
    
}
