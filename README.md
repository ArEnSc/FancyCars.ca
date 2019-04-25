Assumptions List:

Assumptions Stubbing means you want to me to create a json file and my service pulls the code from there, in anyway to get stuff on the screen like mock.

I created a mock service for my purpose.

Infinite Scrolling:

This requires a paging based API in general, the given API doesn't page, and according to the spec that was given it means that all the items are retrieved.

I wrote a simple mock paging API to send data in pages back, for infinite scrolling.

Sorting:
I am assuming you wanted client side sorting, so I implemented that for the items on the screen current.
If it does "page" to the next screen, those items would be unsorted.
It should be server side responsbility to provide a sorted dataset that I could page. This is more or a slight hack to meet requirements give time.
I could have created an end point that did this feature however.

Offline:
Works offline I am sure you meant offline, as in offline caching using core data or an embedded database, but this also could have meant, you wanted me to use mock json data.

Anyways 
This is the result of the requirements!