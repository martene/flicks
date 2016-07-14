//
//  MoviesViewController.swift
//  flicks
//
//  Created by Martene Mendy on 7/13/16.
//  Copyright © 2016 Martene Mendy. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   @IBOutlet weak var movieTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

      movieTableView.dataSource = self
      movieTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return 20
   }

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

      let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)

      cell.textLabel!.text = "row \(indexPath.row)"
      print("row \(indexPath.row)")
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
