//
//  ViewController.swift
//  testing
//
//  Created by Anil on 18/05/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
    
  
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressCount: UILabel!

    var task : NSURLSessionTask!
    
    var counter:Float = 0.0 {
        
        didSet {
            let fractionalProgress = Float(counter) / 100.0
            let animated = counter != 0
            
            progressBar.setProgress(fractionalProgress, animated: animated)
            progressCount.text = ("\(counter)%")
        }
        //The didSet is called immediately after the new value is stored. The fractionalProgress constant keeps track of the progress.
    }
    
    lazy var session : NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        return session
        }()
    
    override func viewDidLoad() {
        progressBar.setProgress(0.0, animated: true)  //set progressBar to 0 at start
    }
    
    @IBAction func doElaborateHTTP (sender:AnyObject!) {
        
        progressCount.text = "0%"
        if self.task != nil {
            return
        }
        
        let s = "https://dl.dropboxusercontent.com/u/87285547/09%20Working%20Man_%20Finding%20My%20Way.mp3"
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(URL:url)
        let task = self.session.downloadTaskWithRequest(req)
        self.task = task
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        println("downloaded \(100*writ/exp)")
    
        dispatch_async(dispatch_get_main_queue(), {
            self.counter = Float(100*writ/exp)
            return
        })
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        println("completed: error: \(error)")
    }
    
    // this is the only required NSURLSessionDownloadDelegate method
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {

    }
    
}

