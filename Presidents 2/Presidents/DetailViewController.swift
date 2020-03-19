//
//  DetailViewController.swift
//  Presidents
//
//  Created by Victor on 11/6/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //Labels
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var presidentView: UIImageView!
    
    /*
        Update the user interface for the detail item.
     */
    func configureView() {
        if let detail = self.detailItem { 
            if let imageView = self.presidentView {
                ImageProvider.sharedInstance.imageWithURLString(urlString: detail.url) {
                    (image) in
                    imageView.image = image
                }
                
            }
        if let label = self.nameLabel{ //displays president info on corresponding labels
            label.text = detail.name
        }
        if let label = self.numberLabel{
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            label.text = "\(formatter.string(from: detail.number as NSNumber)!) President of the United States"
        }
        if let label = self.termLabel{
            label.text = "( \(detail.startDate) to \(detail.endDate) )"
        }
        if let label = self.nickNameLabel{
            label.text = detail.nickName
        }
        if let label = self.partyLabel{
            label.text = detail.politicalParty
        }
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: President? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

}

