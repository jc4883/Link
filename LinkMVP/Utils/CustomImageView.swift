//
//  CustomImageView.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 8/3/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    func loadImage(urlString : String) {
        let lastURLUsedToLoadImage = urlString
        guard let imageURL = URL(string: urlString ) else{return}
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, err) in
            if let err = err{
                print("fetching profile picture failed: ", err)
                return
            }
            //prevent repeating and out of order cells
            if imageURL.absoluteString != lastURLUsedToLoadImage {
                return
            }
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
            }
        }).resume()
    }
}

