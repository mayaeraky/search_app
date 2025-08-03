# README

This is a relatime search app that saves into the DB search queries per user to then show then as analytics for the user upon search.

For scalability: 

1. Search Input was created as a separate model that references the user through its id.

2. Search Input has the attribute occurrences which reflects the count of the search of this statement. This can make us avoid same statment in different table rows and makes querying the table easier (less data), ordering by how trendy the search is much easier, and eliminates redundunt data. 

3. implementation of controller, policy, service, user authentication in before action used in application controller, all of these could have been simplified but this structure eases the next steps when adding features and models to this system and ensures scalability.

The Pyramid Problem:

one of the challenges of it being a relatime search app is the pyramid problem which is avoided here by cinsidering these cases:

1. Before saving the search input to the DB, The system makes sure that the current search keyword is not a prefix of another previous search. In case of it being a prefix it's not saved.

2. Before saving the search input to the DB, The system checks for existing search inputs with the same keyword. In that case the occurrences attribute in the existing search input is incremented instead of creating a new search input.

3. Finally we check for previous search inputs that have a keyword that is a prefix of the current one and were created less than 5 minutes ago (The duration after which the previous search is considered unrelated to the current one) to destroy them.


UI/UX:

I didn't work much on the UI/UX experience just a basic ui to test the app. after searching the top searches per this user will show on the screen and upon clicking on any search input, its details with show. if you click again the details will be hidden.


Suggested Enhancements (were not implemented due to the time constraint):

1. I believe redis caching will be a great help for scalability and performance of the app.

2. Adding index to the right DB tables that would probably need it in the future.

3. Filtering the data could be done in a delayed job to improve performance but this depends on the ui/ux design and how fast and instant we need this data to reflect.

4. Better Tests design.


Ruby version  3.4.5 
Rails version 8.0.2

To run DB migrations:  rails db:migrate