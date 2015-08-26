Get data from a website that requires authentication by injecting javascript

This is the main (best) version of the capital one viewer app. 
It uses Javascript injection and a webView that isn't shown to get the data about balances.

It employs login (saved and changeable), and an option to view the site. 


To Do:
Add Resizing so it works on all iPhone sizes
Add app icons
Add Better Graphics
Determine the difference between a login failing, and account being locked


In the future it would be nice to seperate the retrieval of the website out into totally seperate code, but because of the 
delegation the the webViewdidload as well as the timer for loading, im not sure how to do that yet
