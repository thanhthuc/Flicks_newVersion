    //
//  ViewController.swift
//  Flicks
//
//  Created by admin on 7/6/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class NowPlayingViewController: UIViewController{

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataDictionary: [NSDictionary] = []
    var dataFilter: [NSDictionary] = []
    // create the search bar programatically
    let searchBar = UISearchBar()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //configuration for collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.hidden = true
        
        self.segmentControl.selectedSegmentIndex = 1
        
        //not space with top layout
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.rowHeight = 120
        
        //search bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        //searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        //request and get data
        requestData()
        
        //pull to refresh
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(pullToRefreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    
    
    
    func showError() {
        let alert = UIAlertController(title: "Error network", message: "you should check internet connection", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func pullToRefreshData(refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(
            request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        
                        self.dataDictionary = responseDictionary["results"] as! [NSDictionary]
                        self.dataFilter = self.dataDictionary
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        
                        //end refresh after loaded data
                        refreshControl.endRefreshing()
                    }
                }
                if error != nil {
                    print(error?.localizedDescription)
                    self.showError()
                }
        })
        task.resume()
    }
    
    func requestData() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(
            request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        
                        self.dataDictionary = responseDictionary["results"] as! [NSDictionary]
                        self.dataFilter = self.dataDictionary
                        
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
                if error != nil {
                    print(error?.localizedDescription)
                    self.showError()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
        })
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeViewAction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.tableView.hidden = true
            self.collectionView.hidden = false
        }
        else {
            self.tableView.hidden = false
            self.collectionView.hidden = true
        }
        
    }
    
    
}


extension NowPlayingViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCollectionView" {
            
            let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
            let vc = segue.destinationViewController as! DetailNowPlayingVC
            vc.dataDetailNowPlaying = self.dataDictionary[(indexPath?.row)!]
        }
        else {
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let vc = segue.destinationViewController as! DetailNowPlayingVC
            vc.dataDetailNowPlaying = self.dataDictionary[(indexPath?.row)!]
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("moviesCell", forIndexPath: indexPath) as! NowPlayingTableViewCell
        cell.filmNameLable.text = self.dataFilter[indexPath.row]["original_title"] as? String
        cell.descriptionShortLabel.text = self.dataFilter[indexPath.row]["overview"] as? String
        
        let imageUrlString = self.dataFilter[indexPath.row]["poster_path"] as! String
        let realURLString = "https://image.tmdb.org/t/p/w342" + imageUrlString
        let imageUrl = NSURL(string: realURLString)
        cell.nowPlayingImage?.setImageWithURL(imageUrl!)        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFilter.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}
    
    
extension NowPlayingViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.dataFilter = self.dataDictionary
        }
        else {
            dataFilter = dataDictionary.filter({(dataItem) -> Bool in
                
                var isSubstringOf = false
                
                if ((dataItem["original_title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil){
                    isSubstringOf = true
                }
                
                if ((dataItem["overview"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil){
                    isSubstringOf = true
                }
                    
                return isSubstringOf
            })
            
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
}
    
    
extension NowPlayingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataFilter.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("nowPlayingCell", forIndexPath: indexPath) as! NowPlayingCollectionViewCell
        
        cell.nameLabel.text = self.dataFilter[indexPath.row]["original_title"] as? String
        
        let imageUrlString = self.dataFilter[indexPath.row]["poster_path"] as! String
        let realURLString = "https://image.tmdb.org/t/p/w342" + imageUrlString
        let imageUrl = NSURL(string: realURLString)
        cell.imagePoster?.setImageWithURL(imageUrl!)
        
        return cell
    }
    
}
    