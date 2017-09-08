//
//  TableViewController.swift
//  SimpleMeme
//
//  Created by Filipe Merli on 08/09/17.
//  Copyright © 2017 Filipe Merli. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var memeTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //memes = appDelegate.memes
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    //Refreshes table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeTable!.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetail") as! DetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[indexPath.row]
        
        cell.textLabel?.text = meme.memeTopText + " " + meme.memeBottomText
        cell.imageView?.image = meme.memeGeneratedImage
        
        return cell
    }
}
