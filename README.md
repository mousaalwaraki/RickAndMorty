# RickAndMorty

## Screenshots

<img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/1.png" width="200"><img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/2.png" width="200"><img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/3.png" width="200"><img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/4.png" width="200">
<img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/5.png" width="200"><img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/6.png" width="200"><img src="https://github.com/mousaalwaraki/RickAndMorty/blob/master/Screenshots/7.png" width="200">  

## Summary

Rick And Morty is a sample app created that uses a generic URLSession to get different data from an API.
The data is then stored locally, using CoreData.
The data is displayed in a suitable way in collection views and table views. 
In the collection view pageination is used to display an appropriate number of cells for the user. New cells are added as the user reaches the end of the collection view using a collection view delegate.
Filtering and search are also available to filter through the data with different parameters.
KingFisher (pod) is used to cache images in the app.

## Challenges

The creation of this app marked a few 'firsts' for me, and was very challenging in contrast with its simple UI.     
While hitting API endpoints is not new to me at all, I had initially created multiple (6) API function calls within the App, that all did more or less the same thing but with a change in the model they'ree being written into. This made for a very messy code and left me unsatisfied. Due to this I pushed myself to learn more about generics and how to implement them within the app. This allowed me to reduce the API functions to an API Manager class that takes advantage of generics and completion to reduce the number of functions.     
Similiarly I had read up on CoreData, but had only worked with UserDefaults prior to this app. I thought it was a perfect time to put my knowledge into practice by creaating a CoreData model and saving data locally on to it.    
Implementing CoreData was challenging, but it also created a similiar issue to the initial way I created API calls, and that was A LOT of functions. I was a ble to reduce them by creating a generic 'fetching' function for CoreData. Whilst I was not able to implement saving CoreData into a generic function it's a challenge I'm looking forward to solving in the near future.   
Lastly pageinating the collection view was a bit challenging due to the filtering and search that was implemented, however as I cracked on with it, it all fell into place and it's working perfectly!
