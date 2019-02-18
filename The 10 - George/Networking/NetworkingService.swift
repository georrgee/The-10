//  NetworkingService.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved

// Description: NetworkingService is where the magic happens to grab and parse JSON data. Where we are using TheMovieDB API

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingService {
    
    // MARK: Properties
    static let shared = NetworkingService()         // creating an instance so we can call this in other viewcontrollers to load data
    var genreDictionary: [Int: String] = [:]       // empty dictionary so later we can store the ID's with their specific genre names
    
    init() {
        getGenreTitle {  }
    }
    
    // MARK: Movie Data - Here we can use public functions to call them from different view controllers
    
    func getNowPlayingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovieDbUrl(url: now_playingURL, success: success, failure: failure)
    }

    func getUpcomingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovieDbUrl(url: upcoming_URL, success: success, failure: failure)
    }
    
        // the getMovies function will contain a request to from any URL (hence: upcoming, nowplaying since they pretty much have the same parameters)
    private func getMovieDbUrl(url: String, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
       
        guard let api = URL(string: url) else { return }
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            if response.result.isSuccess {
                
                let movieJSON   = JSON(response.result.value!)
                let rawData     = movieJSON["results"].arrayValue
                var results     = [Movie]()
                
                for i in 0...9 {                                // only loop through the first 10 results
                    results.append(Movie(rawData: rawData[i]))  // apply the results to the Struct Movie Properties
                }
                success(results)
            }
        }
    }
    
    // MARK: Images - Getting and Storing the Base URL (TheMovieDB Config API) and Poster Path (TheMovieDB Now_Playing & Upcoming API)
    
    private func getImageBaseUrl(success: @escaping (_ stringUrl: String?) -> Void) {
        
        guard let url = URL(string: config_URL) else { return }         // using the config url
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {     // if it's not successful, exit early in the function
                success(nil)
                return                          // with a completion and a return statements
            }
            
            let rawData     = JSON(response.result.value!)
            let imageDict   = rawData["images"].dictionaryValue as [String: JSON]
            
            guard let base_url = imageDict["base_url"]?.stringValue else {      // storing the the base_url i.e. ("http://image.tmdb.org/t/p/")
                success(nil)
                return
            }
            
            success(base_url)
        }
    }
    
            // Upcoming API URL - Grabbing the paramter:  poster_path
    private func getUpcomingPosterPath(movieId: String, success: @escaping (_ posterPath: String?) -> Void) {
        
        guard let url = URL(string: upcoming_URL) else { return }       // upcoming url stored to url
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {
                success(nil)
                return
            }
            
            guard let response = response.result.value as? [String: AnyObject] else {       // practicing how to use guard
                success(nil)
                return
            }
            
            let rawData = JSON(response)
            let dict    = rawData.dictionaryValue
            
            guard let results = dict["results"]?.arrayValue else {      // results constant to store the array of "Results"
                success(nil)
                return
            }
            
            guard let result = results.filter({             // loop over the array and make sure the movie id matches
                return $0["id"].stringValue == movieId      // that way we wont mix up the images for a specific movie
            }).first else {                                 // and since we want to just grab the first element, it will get the particular ID of a movie
                success(nil)
                return
            }

            let posterPath = result["poster_path"].stringValue      // storing the actual poster_path which i.e. ("/ij0xoc13hGhrYIlXGGuPXWTh3vi.jpg")
            success(posterPath)
        }
    }
    
    // Now_Playing API URL - Grabbing the paramter:  poster_path (so we can store the poster path; SAME AS FUNCTION: getUpcomingPosterPath)
    private func getNowPlayingPosterPath(movieId: String, success: @escaping (_ posterPath: String?) -> Void) {
        
        guard let url = URL(string: now_playingURL) else { return }     // now_playing stored to url
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {     // same as above haha
                success(nil)
                return
            }
            
            guard let response = response.result.value as? [String: AnyObject] else {
                success(nil)
                return
            }
            
            let rawData = JSON(response)
            let dict    = rawData.dictionaryValue
            
            guard let results = dict["results"]?.arrayValue else {
                success(nil)
                return
            }
            
            guard let result = results.filter({
                return $0["id"].stringValue == movieId
            }).first else {
                success(nil)
                return
            }
            
            let posterPath = result["poster_path"].stringValue
            
             success(posterPath)
        }
    }
            // public function we can use to get the actual image for the Upcoming Movies
    func getUpcomingMoviePoster(movieId: String, success: @escaping (_ url: String) -> Void, failure: @escaping(_ error: Error) -> Void) {
        
        // Using Grand Central Dispatch
        getImageBaseUrl() { base_url in
            guard let base_url = base_url else {
                return
            }
            self.getUpcomingPosterPath(movieId: movieId) { posterPathString in
                guard let posterPathString = posterPathString else {
                    return
                }
                
                let photoUrl = base_url + "original" + posterPathString      // combining the base url and poster path string into one (creating an actual URL haha)
                success(photoUrl)
            }
        }
    }
    
            // public function we can use to get the actual image for the Now_Playing Movies
    func getNowPlayingMoviePoster(movieId: String, success: @escaping (_ url: String) -> Void, failure: @escaping(_ error: Error) -> Void) {
        
        getImageBaseUrl() { base_url in                     // same logic as function: getUpcomingMoviePoster
            guard let base_url = base_url else {
                return
            }
            self.getNowPlayingPosterPath(movieId: movieId) { posterPathString in
                guard let posterPathString = posterPathString else {
                    return
                }
                
                let photoURL = base_url + "original" + posterPathString
                success(photoURL)
            }
        }
    }
    
    // MARK: Genres - Getting them from TheMovieDB Genre API

    private func getGenreId(movieId: String, success: @escaping(_ genreId: Int?) -> Void) {     // function to grab the specifc Genre ID for a movie
        
        // movie_details URL API
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(api_key)&language=en-US") else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {
                success(nil)
                return
            }
            
            guard let response = response.result.value as? [String : AnyObject] else {
                success(nil)
                return
            }
            
            let rawData                 = JSON(response)
            let dictionary              = rawData.dictionaryValue
            let genresJSON              = dictionary["genres"]?.arrayValue          // storing the genres array to genresJSON
            let firstGenreDictionary    = genresJSON?[0].dictionaryValue            // getting the first genre dictionary
            let genreId                 = firstGenreDictionary?["id"]?.intValue     // storing the value for key "id" hence the number representing a genre
            
            guard let firstGenreId = genreId else { success(nil); return }          // safe way to store the genre id number
            success(firstGenreId)
        }
    }
    
    private func getGenreTitle( completion: @escaping() -> Void) { // getting the genreTitle
        
        guard let url = URL(string: genre_URL) else { return }      // storing the genre api url to url
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {
                completion()
                return
            }
            
            let rawData      = JSON(response.result.value!)
            let genreArray   = rawData["genres"].arrayValue
            
            for (key, value) in genreArray.enumerated() {       // going through the array of Genres["id": 12, "name" : "Adventure"]
                
                let valueDict   = value.dictionaryValue
                let id          = valueDict["id"]?.intValue         // store the specific genre id
                let name        = valueDict["name"]?.stringValue    // store the name of the genre
                
                guard let genreId = id, let genreName = name else { return }
                self.genreDictionary.updateValue(genreName, forKey: genreId) // store the name from the specific key (genre id)
            }
            completion()
        }
    }
    
        // public function where we can grab the genre for a specifc movie using Grand Central Dispatch
    func getGenre(movieId: String, success: @escaping (_ title: String) -> Void) {
        
        // Again using GCD to retrieve the Genre Name
        getGenreId(movieId: movieId) { genreId in
            
            guard let genreId = genreId else {
                success("")
                return
            }
            let genreName = self.genreDictionary[genreId] ?? ""    // storing the id and name
            success(genreName)
        }
    }
    
}
