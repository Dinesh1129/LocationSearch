# iOS Challenge

### Architecture:

1. Adopted **MVP architecture** to seperate the functionality and reduce the burden of view controller. It also helps to write proper unit test cases to cover all business logic by mocking view, presenter and model.
2. Used **protocols instead of concreat classes** to mock the wireframes, presenter and view wherever needed to perform unit tests.
3. Followed **dependency injection** as much as possible to make unit tesiting easy

**View Controller**
1. Should confirm to ViewProtocol, It is the only part of MVP that knows about UIKit
2. Encapsulates representation, intercepts events and passes them to Presenter
3. Knows nothing about model objects
4. Strongly captures view

**Presenter**
1. Implements processing the information from the model
2. Responsible for handling events
3. Responsible for getting data from service or data store
4. Knows nothing about UIKit
5. Has weak reference on View

**Model**
1. Is responsible for maintainig consistent state of data
2. Based on View's need , presenter will call the service and update the model
3. It doesn't know anything about View
4. Should contain all business logic related to model objects

### Unit Testing
1. **Model** is as passive as possible, not much unit-testing can be done
2. **View** is passive as well. We can cover basic unit test cases like table cells properly registered, hidden properties of UI based on presenter value
3. **Presenter** it contains all business logic, thus it is a main target for unit-tests

### Third Party Libraries used

1. **Alamofire**  and **AlamofireObjectMapper** to make REST service
2. **ObjectMapper** to convert resposne JSON into data model and vice versa
3. **OHHTTPStubs** to stub the HTTPS response for unit testing
