//  Movie.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved

//  Description: a struct file where we can store the properties of a Movie!

import Foundation
import SwiftyJSON

struct Movie { 

    let id:             String
    let title:          String
    let releaseDate:    String
    let rating:         String
    let overView:       String
    let posterPath:     String
    let genreTitle:     String
    
    init(rawData: JSON) {
        id           = rawData["id"].stringValue
        title        = rawData["title"].stringValue
        releaseDate  = rawData["release_date"].stringValue
        rating       = rawData["vote_average"].stringValue
        overView     = rawData["overview"].stringValue
        posterPath   = rawData["poster_path"].stringValue
        genreTitle   = rawData["genre_ids"].arrayValue.first?.stringValue ?? ""
    }
}

