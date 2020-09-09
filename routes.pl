#!/usr/bin/env perl

use Mojolicious::Lite -signatures;

#naming a route to allow automatic template detection
get '/' => sub ($c) {
    #a named route does not need to have a specified template to render as it will (if possible) be detected automagically
    $c->render;
} => 'index'; #'index' is the name of this route to /

#templates can also be rendered without a sub routine if they can be identified
get '/hello';

app->start;

#section __DATA__ holds the templates to be rendered

__DATA__

@@ index.html.ep

<%# link_to TEXT => LINK adds a <a> tag to LINK with TEXT%>
<%= link_to Hello => 'hello' %>
<%= link_to Reload => 'index' %>

@@ hello.html.ep

Hello World!
