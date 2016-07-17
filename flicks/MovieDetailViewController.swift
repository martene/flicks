//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Martene Mendy on 7/16/16.
//  Copyright © 2016 Martene Mendy. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

   @IBOutlet weak var movieDetailImage: UIImageView!
   @IBOutlet weak var movieDetailTitle: UILabel!
   @IBOutlet weak var movieDetailReleaseDate: UILabel!
   @IBOutlet weak var movieDetailOverview: UILabel!

   @IBOutlet weak var movieScrollView: UIScrollView!

   var movie: NSDictionary!

   override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      // scrollview
      let movieScrollViewContentWidth = movieScrollView.bounds.width
      let movieScrollViewContentHeight = movieScrollView.bounds.height * 2
      movieScrollView.contentSize = CGSizeMake(movieScrollViewContentWidth, movieScrollViewContentHeight)


      print("movie: \(movie)")
      let movieTitle = movie["title"] as! String
      movieDetailTitle.text = movieTitle

      let movieOverview = movie["overview"] as! String
      movieDetailOverview.text = movieOverview
      movieDetailOverview.sizeToFit()

      let movieImagePath = movie["poster_path"] as! String
      if let movieImageUrl = NSURL(string: "https://image.tmdb.org/t/p/original" + movieImagePath) {
         movieDetailImage.setImageWithURL(movieImageUrl)
      }
      else{
         movieDetailImage.image = nil
      }

      let movieReleaseDate = movie["release_date"] as! String
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let d = dateFormatter.dateFromString(movieReleaseDate)
      dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
      movieDetailReleaseDate.text = dateFormatter.stringFromDate(d!)
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
