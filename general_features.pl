#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

# '/path' route to some part of the web application
get '/path' => sub ($c) {
    # $c is a instance of Mojolicious::Controller
    $c->render(text => 'Some text');
};

# get parameters passed with a GET request
get '/param' => sub ($c) {
    # $c->param(PARAM_NAME) returns the value of the parameter PARAM_NAME
    my $id = $c->param('id');
    $c->render(text => "The ID is: $id\n");
};

# same thing, but using a POST request
post '/post' => sub ($c) {
    my ($username, $password) = ($c->param('user'), $c->param('pass'));
    $c->render(text => "Received POST request with: user=$username and pass=$password\n");
};

# rendering templates
get '/template1' => sub ($c) {
    $c->render(template => 'template1');
};

# passing data to a template
get '/template2' => sub ($c) {
    # $c->stash(name => value) passes data to the template as NAME
    $c->stash(username => 'LvMalware');
    # Another way to pass data is including a parameter on the call to $c->render()
    $c->render(template => 'template2', password => 'password');
};

# accessing the HTTP request information
get '/http_req' => sub ($c) {
    #$c->req gives access to all the information about the HTTP request
    my $ua = $c->req->headers->user_agent;
    #headers gives access to the request headers (consult Mojo::Headers)
    my $lang = $c->req->headers->accept_language;
    $c->render(text => "This page was requested by $ua<br>Your browser accepts these languages: $lang");
};

# controlling the HTTP response
post '/http_res' => sub ($c) {
    #$c->res gives control over the response body and headers
    #setting a custom header
    $c->res->headers->header('Custom-header' => 'Header value');
    #rendering the request body as response data
    $c->render(data => $c->req->body);
};

# using JSON
put '/json' => sub ($c) {
    #Mojolicious has native support for JSON (consult Mojo::JSON)
    #gets the JSON received with the request as a hash ref
    my $hash = $c->req->json;
    #the hash can be modified as usual
    $hash->{something} = 'something else';
    #and it can be rendered back
    $c->render(json => $hash);
};

# built-in exception

get '/fatal' => sub {
    #Mojolicious returns a 500 (internal error) when the application dies
    die "Intentional fatal error";
};

# built-in not_found template
get '/not_found' => sub ($c) {
    #Mojolicious has some templates to exceptions and not_found pages
    $c->render(template => 'does_not_exist');
};

app->start;

# data section containing the templates
__DATA__

# the marker to delimiting a template starts with an @@ followed by the template name .html.ep
@@ template1.html.ep
This is template being rendered
<%# This is a comment! %>

@@ template2.html.ep
Here we can get the data by using < % = $ VAR_NAME % > .
<br>
We have username=<%= $username %> and password=<%= $password %> .


