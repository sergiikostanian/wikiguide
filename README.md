# Wiki Guide


### App Architecture and Design Patterns

__Top-level architecture - SOA__\
When we talking about architecture it really should depend on project size, requirements, deadlines, team size etc. Unfortunately, there is no silver bullet. For this project, I've chosen SOA architecture. It's one of the most universal architecture, it fits for small/medium projects, yet easily scalable and maintainable. Also, it obligates to make testable, clean and reusable code. And works just great with swift :).

### Design Patterns

__Dependency Injection__\
I believe it should be in every project along with all SOLID principles in mind. Helps make decoupled and testable code.

__Observer__\
Kind of reactive approach. Helps to provide events broadcasting from services.

__MVVM__\
Helps to separate the business logic layer from the view layer and make testable view controllers.

__State Machine__\
In this particular case with the map screen, it's a pretty useful pattern. Helps to operate transitions between different states in separate helper classes.


### 3rd party libraries

__Kingfisher__\
Very simple and reliable library. Provides images downloading and caching functionality.


### Other

I didn't have billing information on my personal Google Cloud Platform account, so I couldn't use their Directions API service, therefore, I used Digitransit. Since it works only in Finland so far you have to be there or simulate your location in order to see route suggestions.

For route suggestion fetching I used url requests with json content type because it's just 1 request. If I had to deal with a bigger amount of such requests I would connect [Apollo](https://github.com/apollographql/apollo-ios) to the project to make GraphQL requests.

I've implemented very fast but a bit ugly network responses parsing and mapping. Normally I would use [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) for such kind of work.
