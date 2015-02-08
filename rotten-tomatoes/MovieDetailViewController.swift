//
//  MovieDetailViewController.swift
//  rotten-tomatoes
//
//  Created by Andrew Wen on 2/7/15.
//  Copyright (c) 2015 wendru. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movie = NSDictionary()
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var mpaaRating: UILabel!
    @IBOutlet weak var criticsRating: UILabel!
    @IBOutlet weak var audienceRating: UILabel!
    var HUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieDetail()
    }
    
    func setMovieDetail() {
        HUD.showInView(self.view)
        
        // TITLE
        navItem.title = movie["title"] as NSString
        
        // RUNTIME
        var runtime = movie["runtime"] as Int
        self.runtime.text = NSString(format: "%d Hour(s) %d Minute(s)", runtime / 60, runtime % 60)
        
        // MPAA RATING
        mpaaRating.text = movie["mpaa_rating"] as NSString
        
        synopsis.text = movie["synopsis"] as? String
        synopsis.sizeToFit()
        
        // CRITICS RATING
        criticsRating.text = NSString(format: "%d%%", movie["ratings"]?["critics_score"] as Int)
        
        // AUDIENCE RATING
        audienceRating.text = NSString(format: "%d%%", movie["ratings"]?["audience_score"] as Int)
        
        // POSTER IMAGE
        var posterURL = NSURL(
            string: (movie["posters"]?["thumbnail"]? as NSString).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        )
        poster.setImageWithURL(posterURL!)
        
        HUD.dismissAfterDelay(1.0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePanning(sender: AnyObject) {
        if(sender.state != UIGestureRecognizerState.Ended) { return }
        
        var translation = sender.translationInView(scroller)
        var bounds = scroller.bounds
        
        if(translation.y > 0) {
            bounds.origin.y = 0
        } else if (translation.y < 0) {
            bounds.origin.y = 470
        }
        
        scroller.bounds = bounds
        sender.setTranslation(CGPointZero, inView: scroller)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
