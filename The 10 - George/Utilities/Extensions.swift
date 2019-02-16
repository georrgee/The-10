//  Extensions.swift
//  The 10 - George

//  Created by George Garcia on 2/15/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import Foundation
import AlamofireImage

// MARK: Extensions
extension UIImageView {
    // function that downloads the image by the URL
    func download(url: String?) {
        if let string = url, let link = URL(string: string) {
            af_setImage(withURL: link)
        }
    }
}
