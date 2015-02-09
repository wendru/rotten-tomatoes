//
//  MoviesViewController.swift
//  rotten-tomatoes
//
//  Created by Andrew Wen on 2/4/15.
//  Copyright (c) 2015 wendru. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies = [NSDictionary]()
    var destinationController = MovieDetailViewController()
    var HUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        
        loadData()
    }
    
    func loadData() {
        HUD.showInView(self.view)
        
        let apiKey = "sqcdumcwj9h8wp9a8r8v6smp"
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + apiKey)
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &errorValue) as NSDictionary
            self.movies = dictionary["movies"] as [NSDictionary]
            self.tableView.reloadData()
        })
        
        HUD.dismissAfterDelay(0.5, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        let movie = movies[indexPath.row] as NSDictionary
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
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
        destinationController.movie = movies[indexPath.row]
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.destinationController = segue.destinationViewController as MovieDetailViewController
        super.prepareForSegue(segue, sender: sender)
    }
}
