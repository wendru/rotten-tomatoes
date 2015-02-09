//
//  MoviesViewController.swift
//  rotten-tomatoes
//
//  Created by Andrew Wen on 2/4/15.
//  Copyright (c) 2015 wendru. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var tabs: UITabBar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    var destinationController = MovieDetailViewController()
    var HUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    var refreshControl: UIRefreshControl!
    var isFiltered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        
        tabs.selectedItem = tabs.items?.first as? UITabBarItem
        tabs.delegate = self
        
        searchBar.delegate = self
        
        createRefreshControl()
        loadData()
    }
    
    func createRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func loadData() {
        HUD.showInView(self.view)
        
        let target = tabs.selectedItem?.title!
        let apiKey = "sqcdumcwj9h8wp9a8r8v6smp"
        var url: NSURL!
        
        if(target == "Box Office") {
            url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + apiKey)
        } else {
            url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + apiKey)
        }
        
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, data, error) in
            if(error != nil) {
                self.warningView.hidden = false
            } else {
                self.warningView.hidden = true
                var errorValue: NSError? = nil
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &errorValue) as NSDictionary
                self.movies = dictionary["movies"] as [NSDictionary]
                self.tableView.reloadData()
            }
            
        })
        
        HUD.dismissAfterDelay(0.5, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltered) {
            return filteredMovies.count
        } else {
            return movies.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie: NSDictionary
        
        if(isFiltered) {
            movie = filteredMovies[indexPath.row] as NSDictionary
        } else {
            movie = movies[indexPath.row] as NSDictionary
        }
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        // NAVBAR HEADER
        navigationItem.title = tabs.selectedItem?.title
        
        // TITLE
        cell.titleLabel.text = movie["title"] as NSString
        
        // RUNTIME
        var runtime = movie["runtime"] as Int
        cell.runTime.text = NSString(format: "%d Hours %d Minutes", runtime / 60, runtime % 60)
        
        // MPAA RATING
        cell.mpaaRating.text = movie["mpaa_rating"] as NSString
        
        // CRITICS RATING
        cell.criticsRating.text = NSString(format: "%d%%", movie["ratings"]?["critics_score"] as Int)
        
        // AUDIENCE RATING
        cell.audienceRating.text = NSString(format: "%d%%", movie["ratings"]?["audience_score"] as Int)
        
        // POSTER IMAGE
        var posterURL = NSURL(
            string: (movie["posters"]?["thumbnail"]? as NSString).stringByReplacingOccurrencesOfString("tmb", withString: "pro")
        )
        cell.poster.setImageWithURL(posterURL)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(isFiltered) {
            destinationController.movie = filteredMovies[indexPath.row]
        } else {
            destinationController.movie = movies[indexPath.row]
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        loadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            isFiltered = false
        } else {
            isFiltered = true
            filteredMovies = [NSDictionary]()
            
            for(var i = 0; i < movies.count; i++) {
                let title = movies[i]["title"] as String
                if(title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) {
                    filteredMovies.append(movies[i])
                }
            }
            
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isFiltered = false
        searchBar.text = ""
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func onRefresh() {
        loadData()
        refreshControl.endRefreshing()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.destinationController = segue.destinationViewController as MovieDetailViewController
        super.prepareForSegue(segue, sender: sender)
    }
}
