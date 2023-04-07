# WEB APPLICATIONS:

----

## Introduction

This project connects together what I have learnt working with databases and with what I have learnt in building web applications.

>A simplified schema of how a typical database-backed (CRUD) web application works:
> 1. The client sends a HTTP request to the web server over the Internet: GET /albums
> 2. The web server (a Sinatra application, in our case) handles the request, and executes the route block, which calls the method AlbumRepository#all
> 3. The Repository class runs a SQL query to the database.
> 4. The database returns a result set to the program.
> 5. The Repository class returns a list of Album objects to the route block.
> 6. The route block sends a response to the client containing the data.

----

## Objective

* To learn how to test-drive Sinatra routes which interacts with database-backed Repository class
* To learn how to use Embedded Ruby(ERB) syntax to dynamically generate HTML responses
<!-- We can use ERB (for Embedded Ruby) syntax to generate dynamically the HTML that is sent to the client, by replacing the dynamic parts of the HTML, which are delimited by ERB tags (in between <%= and %> to print on the erb file, <% and %> to execute a ruby code block). -->
* To learn how to use HTML links to make the browser send `GET` requests.
* To learn how to use HTML forms to make the browser send `POST` requests.

----

## Sequence diagram for web application: `post/artists` route with Database:

```mermaid
sequenceDiagram
    participant pm as HTTP CLIENT: Postman
    participant sin as app.rb (using Sinatra)
    participant ar as ArtistRepository class
    participant db_conn as DatabaseConnection class in (in lib/database_connection.rb)
    participant db as Postgres Database


    Note left of pm: Flow of time <br />⬇ <br /> ⬇ <br /> ⬇


    %% t->>app: Runs `ruby app.rb`
    pm->>sin: configures and sends HTTP request, `POST /artists` to the request handler, Application Class, in
    sin->>db_conn: Opens connection to database by calling the connect method on
    sin->>ar: implement the HTTP request by defining the route that handles calls create method with an Artist object argument on the ArtistRepository Class
    ar->>db_conn: sends the sql query `INSERT INTO` by calling the `exec_params` method on
    db_conn->>db: sends query to the database via the open database connection
    db->>db_conn: returns the whole row of the new artist created
    db_conn->>ar: returns the whole row of the new artist created
    ar->>sin: returns Artist instance
    sin->>pm: sends the generated HTTP response status '200 OK' back to the client signifying the request was successful
```

----

## Sequence diagram explaining the behaviour of the program when a request is sent to `GET /artists/:id`:

![sequence diagram](get-method-sequence-diagram.png)

----

## Other information

* When building programs, we use RSpec as a client to test-drive our HTTP routes
* Using **hypertext links**, or **anchor links** in HTML with `<a>` HTML tag to create links with attribute `href` containing the path of the link. example below:

```html
<a href="/about">Go to the about page</a>
```

* Using browser developer tools to inspect HTTP requests sent by the browser, and the responses it receives can help get visibility into what the browser sends and get back through its HTTP connection with the web server

* A form is used to send `POST` request, usually with some additional data, as request parameters and implemented over two routes:

1. `GET` route, only returns an HTML page with the form, so the user can fill in and submit it.
2. `POST` route, handles the body parameters sent by the browser, and returns a response (usually to indicate whether the form data has been successfully handled or saved).

Like links, forms can also be used to make the browser send an HTTP request

* On Route Priority: In Sinatra, it uses the first route that matches a request. For example, if a route `/albums/:id` has been defined first then also creating a `/albums/new` route, `:id` will "capture" the value `new` in the URL. An easy fix is to define, `/albums/new` first.