//
//  ViewController.swift
//  CapitalOne
//
//  Created by Chase McCarty on 2015-08-21.
//  Copyright (c) 2015 Chase McCarty. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var pendingChargesLabel: UILabel!
    @IBOutlet weak var loadingWheel1: UIActivityIndicatorView!
    @IBOutlet weak var loadingWheel2: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var username: String?
    var password: String?
    
    var javascriptInject1: String?
    var javascriptInject2: String?
    let javascriptInject3 = "window.submitform();"

    var webView: UIWebView!
    //var loadedFirstPage = false
    var loadedPage = 0
    
    var user:User?

    override func viewDidLoad() {
        println("View did load")
        super.viewDidLoad()
        loadingWheel1.hidesWhenStopped = true
        loadingWheel2.hidesWhenStopped = true
        
        webView = UIWebView(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.size.height, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webView.delegate = self
        
        //Make sure that the view is reloaded every time the app opens (even from background)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadView", name: "UIApplicationDidBecomeActiveNotification", object: nil)
        
        /*
        user = getSavedPlayer() as? User
        if (user != nil) {
            username = user!.username
            password = user!.password
            if username != "" && password != "" {
                createJavascript(username!, password: password!)
                loadWebView()
            }
        } else {
            performSegueWithIdentifier("GoToLogin", sender: self)
        } */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadView(){
        println("Reload View")
        //Check if there is saved user data
        //If there isnt, then perform a segue to user login page
        user = getSavedPlayer() as? User
        if (user != nil) {
            username = user!.username
            password = user!.password
            if username != "" && password != "" {
                createJavascript(username!, password: password!)
                loadWebView()
            }
        } else {
            performSegueWithIdentifier("GoToLogin", sender: self)
        }
    }
    
    
    func loadWebView(){
        loadingWheel1.startAnimating()
        loadingWheel2.startAnimating()
        currentBalanceLabel.text = "--"
        pendingChargesLabel.text = "--"
        //loadedFirstPage = false
        loadedPage = 0
        //webView = UIWebView(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.size.height, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        //webView.delegate = self
        let url = NSURL(string: "https://www.capitalonecardservice.ca/ecare/loginform?&locale=en_CA&brand=CO_190_101")!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        //self.view.addSubview(webView)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //Make sure this doesnt get called when the second and final page is loaded
        println("Web View Loaded")
        //if loadedFirstPage == true{
        if loadedPage == 2 {
            //return
            readHtml(nil)
            return
        }
        //loadedFirstPage = true
        loadedPage += 1
        let stuff = webView.stringByEvaluatingJavaScriptFromString(javascriptInject1!)
        let stuff2 = webView.stringByEvaluatingJavaScriptFromString(javascriptInject2!)
        let myTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("injectJavascript:"), userInfo: nil, repeats: false)
        
    }
    
    func createJavascript(username: String, password: String){
        javascriptInject1 = String(format:"var username = document.querySelector('#userid1'); username.value = '%@';", username)
        javascriptInject2 = String(format:"var username = document.querySelector('#password1'); username.value = '%@';", password)
    }
    
    func injectJavascript(timer : NSTimer) {
        let stuff = webView.stringByEvaluatingJavaScriptFromString(javascriptInject3)
        //let myTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("readHtml:"), userInfo: nil, repeats: false)
    }
    
    func readHtml(timer: NSTimer?) {
        let html: String? = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        if html != nil {
            //println("Html: \(html) ")
            getCurrentBalance(html!)
        } else {
            println("No HTML :(")
        }
    }
    
    func isInteger(char: String) -> Bool{
        var numbers: String = "0123456789.,"
        if numbers.rangeOfString(char) != nil{
            return true
        } else {
            return false
        }
    }
    
    func getCurrentBalance(html: String) {
        var htmlArray = Array(html)
        var dollarArray = [String]()
        var tempString: String = ""
        for index in 0...htmlArray.count-1 {
            if htmlArray[index] == "$" {
                var tempIndex = index
                if index > 0 && htmlArray[index-1] == "-"{
                    tempString.append(htmlArray[index-1])
                }
                while isInteger(String(htmlArray[tempIndex+1])){
                    tempString.append(htmlArray[tempIndex+1])
                    tempIndex = tempIndex+1
                }
                dollarArray.append(tempString)
                tempString = ""
            }
            if dollarArray.count > 4 {
                break
            }
        }
        if dollarArray.count < 1 || dollarArray[1] == "" {
            loadingWheel1.stopAnimating()
            loadingWheel2.stopAnimating()
            println("login failed")
            var alert = UIAlertController(title: "Login Failed", message: "Please try to login again", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Default) {
                (action: UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("GoToLogin", sender: self)
            }
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        currentBalanceLabel.text = dollarArray[1]
        pendingChargesLabel.text = dollarArray[2]
        loadingWheel1.stopAnimating()
        loadingWheel2.stopAnimating()
    }
    
    @IBAction func viewSite(sender: AnyObject) {
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel , target: self, action: "closeWebView")
        navigationBar.leftBarButtonItem = cancelButton
        
        
        self.view.addSubview(webView)
    }
    
    func closeWebView(){
        println("Closed Web View")
        webView.removeFromSuperview()
        navigationBar.leftBarButtonItem = nil
    }
    
    @IBAction func getSavedPlayerFromSegue(segue: UIStoryboardSegue){
        let signInViewController: SignInViewController = segue.sourceViewController as! SignInViewController
        username = signInViewController.usernameView.text
        password = signInViewController.passwordView.text
        if username != "" && password != "" {
            createJavascript(username!, password: password!)
            loadWebView()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


}

