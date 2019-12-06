##Services

This folder covers the network services of the application. Since we have completed most of the API as well as the controller system for the data transactions on the server side we are now going to start building the client side application's networking side first as a layered architecture.

To get this right, we will start by creating a link interface that will show all the URLs
in a selectable manner that will run a test on the system to ensure functionality.

To get the whole MVC system up we will be using BLoC to implement the control system that will
bind our models to the user interface.

#####\#Notes

Since we are trying to layer the BLoC system in a way that takes on the form of an MVC model we will
thus have three layers on the client: that is, the data layer, BLoC layer and finally the UI which
should be completely separable from the rest of the application.

* So for the data layer we will have that the models keep the database structure of their owning
entity and use the database utility class provided to create the interface. This layer should be bound
with the requesting system.

* We see so far that the MVC model will have to form a sub layer of the BLoC model from this, because
it must be the layer that abstracts, validates, and binds the request data to our models and provide
them in a clean error handled format.

* On this application we will create the middleware classes to function as database handlers for the
incoming requests. In essence we are trying to create a pipeline between the client interface and
back end API.