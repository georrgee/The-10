//  Constants.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Here we can use these constants anywhere

import Foundation

// MARK: Networking Constants - API URLS from TheMovieDB

let api_key         = "f2448e7d924f45f280a5db37ec9619b1"
let now_playingURL  = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)&language=en-US"
let upcoming_URL    = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(api_key)&language=en-US"
let genre_URL       = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(api_key)&language=en-US"
let config_URL      = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
