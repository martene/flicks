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

      //print("movie: \(movie)")
      let movieTitle = movie["title"] as! String
      movieDetailTitle.text = movieTitle

      let movieOverview = movie["overview"] as! String
      movieDetailOverview.text = movieOverview
      movieDetailOverview.sizeToFit()

      let movieImagePath = movie["poster_path"] as! String
      //
      loadImageFromNetwork(movieDetailImage, imagePath: movieImagePath)

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

   // Loading a Low Resolution Image followed by a High Resolution Image
   func loadImageFromNetwork(imageView: UIImageView, imagePath: String){

      let imageBaseUrl = "https://image.tmdb.org/t/p"
      let smallImageUrlPath = imageBaseUrl + "/w45" + imagePath
      let largeImageUrlPath = imageBaseUrl + "/original" + imagePath

      let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrlPath)!)
      let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrlPath)!)

      imageView.setImageWithURLRequest(
         smallImageRequest,
         placeholderImage: nil,
         success: {(smallImageRequest, smallImageResponse, smallImage) -> Void in
            // should be in the cache
            imageView.alpha = 0.0
            imageView.image = smallImage

            UIView.animateWithDuration(
               0.3,
               animations: {() -> Void in
                  imageView.alpha = 1.0
               },
               completion: { (success) -> Void in
                  // network call
                  imageView.setImageWithURLRequest(
                     largeImageRequest,
                     placeholderImage: nil,
                     success: {(largeImageRequest, largeImageResponse, largeImage) -> Void in
                        // largeImageResponse nill if the image is cached
                        imageView.image = largeImage
                     },
                     failure: {(req, resp, error) -> Void in
                        // do something
                     }
                  )
               }
            )
         },
         failure: {(req, resp, error) -> Void in
            // do something
         }
      )
   }
}
