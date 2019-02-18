//  Extensions.swift
//  The 10 - George
//  Created by George Garcia on 2/15/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Just put extensions here so we can avoid redundancy

import Foundation
import AlamofireImage

// MARK: Extensions

extension UIImageView {
    
    func download(url: String?) {  // function that downloads the image by the URL
        
        if let string = url, let link = URL(string: string) {
            af_setImage(withURL: link)
        }
    }
}
