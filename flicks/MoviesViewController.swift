//
//  MoviesViewController.swift
//  flicks
//
//  Created by Martene Mendy on 7/13/16.
//  Copyright © 2016 Martene Mendy. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

   @IBOutlet weak var movieTableView: UITableView!
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var navItem: UINavigationItem!


   var movies: [NSDictionary]! = [NSDictionary]()
   let refreshControl = UIRefreshControl()

   var endpoint: String!
   var filteredMovies: [NSDictionary]!

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.

      //Adding Pull-to-Refresh
      refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
      movieTableView.insertSubview(refreshControl, atIndex: 0)

      loadNetworkRequest()

      movieTableView.dataSource = self
      movieTableView.delegate = self

      searchBar.delegate = self
      searchBar.backgroundColor = movieTableView.backgroundColor

      filteredMovies = movies

      navItem.titleView = searchBar
      navItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
      print("nc: \(self.navigationController)")
      print("nc: \(self.navigationController?.navigationBar)")
      if let navigationBar = self.navigationController?.navigationBar {
         navigationBar.titleTextAttributes = [
         NSFontAttributeName : UIFont.boldSystemFontOfSize(5),
         NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
         NSShadowAttributeName : NSShadow()
         ]}
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return filteredMovies!.count
   }

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

      //print("row \(indexPath.row)")

      let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieViewCell
      let movie = filteredMovies![indexPath.row]
      //print("movie \(movie)")

      let title = movie["title"]!
      let overview = movie["overview"]!

      cell.movieTitle.text = title as? String
      cell.movieSynopsis.text = overview as? String
      // hint???
      cell.movieSynopsis.sizeToFit()


      if let urlString = movie["poster_path"] as? String {
         let url = NSURL(string: "https://image.tmdb.org/t/p/w45" + urlString)
         cell.movieImage.setImageWithURL(url!)
      }
      
      // no color when user select cell
      cell.selectionStyle = .None
      return cell
   }

   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
   }


   func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

      if searchText.isEmpty {
         filteredMovies = movies
      }
      else{
         filteredMovies = movies.filter({
            ($0["title"] as! NSString).localizedCaseInsensitiveContainsString(searchText)
         })
      }
      movieTableView.reloadData()
   }


   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

      //print ( "prepare for segue")
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.

      let movieCell = sender as! UITableViewCell
      let indexPath = movieTableView.indexPathForCell(movieCell)
      let movie = filteredMovies![indexPath!.row]

      let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
      movieDetailViewController.movie = movie
   }

   func loadNetworkRequest(){
      let key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
      let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(key)")
      let request = NSURLRequest(URL: url!)
      let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())

      // Display 'Heads Up Display'
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)

      let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, reponseOrNil, errorOrNil) in
         // this is only for testing MBProgressHUD or 'Simulator > Reset Content and Settings' from your simulator
         //sleep(3)

         if let data = dataOrNil {
            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
               //NSLog("Rest response: \(responseDictionary)")
               self.movies = (responseDictionary["results"] as! [NSDictionary])
               self.filteredMovies = self.movies
               self.movieTableView.reloadData()
            }
         }

         if let error = errorOrNil {
            self.view.hidden = true
            print(error.localizedDescription)
         }
         // Hide HUD
         MBProgressHUD.hideHUDForView(self.view, animated: true)
      })
      task.resume()
   }

   func refreshControlAction(refreshControl: UIRefreshControl){

      loadNetworkRequest()

      // Tell the refreshControl to stop spinning
      refreshControl.endRefreshing()
   }

}
