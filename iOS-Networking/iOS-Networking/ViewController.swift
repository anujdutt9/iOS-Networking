//
//  ViewController.swift
//  iOS-Networking
//
//  Created by Anuj Dutt on 7/19/19.
//  Copyright © 2019 Anuj Dutt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // Get Button tapped
    // Fake JSON Request: https://jsonplaceholder.typicode.com/
    @IBAction func onGetTapped(_ sender: Any) {
        // Define the URL for the API Call
        guard let url = URL(string: "http://0.0.0.0:80/ping") else {return}
        
        // Create a URL Session
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response{
                print("API Response:\n\(response)")
            }
            // Raw Data
            if let data = data{
                print("Data length: \(data.count)")
                do {
                    // Convert data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    // Post Button tapped
    @IBAction func onPostTapped(_ sender: Any) {
        
        let resourcesPath = Bundle.main.resourcePath
        
        let fileManager = FileManager.default
        
        do{
            
            let docsArr = try fileManager.contentsOfDirectory(atPath: resourcesPath ?? "")
            print("Docs: \(docsArr)")
        }catch{
            print("\(#function) \(error)")
        }
        
        
        let goodUrl = URL(fileURLWithPath: (resourcesPath?.appending("/apple.png"))!)
        var img:Data? = nil
        do{
            img = try Data(contentsOf: goodUrl)
        }catch{}
        
        
        self.imageView.image = UIImage(data: img!)
        
        // To send an Image and ASR Text use this in Parameters
        if let url = URL(string: "https://www.allaboutbirds.org/guide/assets/og/75335251-1200px.jpg"){
            do {
                let data = try Data(contentsOf: url)
                //self.imageView.image = UIImage(data: data)
                self.image = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        
        // Input Parameters to Post
        let parameters = ["Image": self.image?.jpegData(compressionQuality: 0.5)?.base64EncodedString(), "Question": "What is in this picture?", "Model": "v1"]
        // Define the URL
        guard let url = URL(string: "http://0.0.0.0:80/vqa") else {return}
        // Define URL Request
        var request = URLRequest(url: url)
        // Define this request as a Post Request
        request.httpMethod = "POST"
        // Create the JSON data as payload
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        // HTTP body to request body
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // URL Session
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print("API Response:\n\(response)")
            }
            // Raw Data
            if let data = data{
                do {
                    // Convert data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
}

