import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: ## Cookbook 1 Challenge: GET `posts` from json-server
//: __Instruction:__ Do the TODOs.
//:
//: Default session with `waitsForConnectivity`:
let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let defaultSession = URLSession(configuration: config)
//: ### GET Data Task With URL and Completion Handler
//: In the demo, we looked at the iTunes search data task, and converted its response to Tracks.
//: For this challenge, you'll GET all posts from the json-server host, using this `url`:
let urlString = "http://localhost:3000/posts/"
let url = URL(string: urlString)!
//: A data task's completion handler receives data, response and error objects.
//: If there's no error, and the data and response objects exist, it handles the response.
//: The handler of a GET task converts the data into objects the app can use.
//:
//: GET responses are all different — the server's REST API usually describes the keys and values,
//: or you can do a preliminary GET and inspect the response. We did this with the RESTed app in Part 2,
//: so we know the response body is an array of dictionaries,
//: and each dictionary has keys "id", "author" and "title".
//:
//: Normally, your app will have a Model struct or class. If this Model object conforms to the `Codable` protocol,
//: and its property names match keys in the JSON response,
//: you can use a JSON decoder to automatically parse the response data into Model objects.
//:
//: __TODO 1 of 3:__ Create a JSON decoder and a `Codable` struct to store `Post` objects.
//: Make sure the struct's property names match the keys in the response data:

struct Post {


}
//: The properties below set up an array of `Post` objects, and initialize `errorMessage` to an empty string:
var posts: [Post] = []
var errorMessage = ""
//: __TODO 2 of 3:__ Create the task, with `url` and completion handler (rearrange and adapt the demo code; in this case, the response data is an unkeyed array that matches `[Post]`):








// TODO 3 of 3: Remember to resume (start) the task

//: Run your `json-server` in Terminal: `json-server --watch db.json`, then run this playground.
//: You can double-check the result in RESTed by GETting all posts.
