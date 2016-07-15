//
//  MoviesViewController.swift
//  flicks
//
//  Created by Martene Mendy on 7/13/16.
//  Copyright © 2016 Martene Mendy. All rights reserved.
//

import UIKit

import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   @IBOutlet weak var movieTableView: UITableView!

   var movies: [NSDictionary]! = [NSDictionary]()

   override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.

      movieTableView.dataSource = self
      movieTableView.delegate = self

      let key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
      let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(key)")
      let request = NSURLRequest(URL: url!)
      let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())

      let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, reponseOrNil, errorOrNil) in
         if let data = dataOrNil {
            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
               // NSLog("Rest response: \(responseDictionary)")
               self.movies = (responseDictionary["results"] as! [NSDictionary])
               self.movieTableView.reloadData()
            }
         }
      })
      task.resume()
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return movies!.count
   }

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

      let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieViewCell
      let movie = movies![indexPath.row]
      let title = movie["title"]!
      let overview = movie["overview"]!

      cell.movieTitle.text = title as? String
      cell.movieSynopsis.text = overview as? String
      // hint???
      cell.movieSynopsis.sizeToFit()

      let urlString = movie["poster_path"]! as! String
      let url = NSURL(string:"https://image.tmdb.org/t/p/w342" + urlString)
      cell.movieImage.setImageWithURL(url!)
      //print("row \(indexPath.row)")
      return cell
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
