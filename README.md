## Event Recorder

This application contains the microservice that is responsible to update the events and campaign mappings in the database. You can think of this as a child application of `india-res-signup`. It uses a lot of the same models as the `india-res-signup` application with one key difference being that no migrations are run, but the schema is loaded directly from the schema.rb file

To run this application, download the source code and run the following

# TODO