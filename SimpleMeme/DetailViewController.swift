//
//  DetailViewController.swift
//  SimpleMeme
//
//  Created by Filipe Merli on 06/09/17.
//  Copyright © 2017 Filipe Merli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageDetailView: UIImageView!
    var meme = Meme()
    
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        
        self.imageDetailView!.image = meme.memeGeneratedImage

        self.imageDetailView.contentMode = .scaleAspectFit
        
        //self.imageView!.image = UIImage(named: meme.image)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
}
