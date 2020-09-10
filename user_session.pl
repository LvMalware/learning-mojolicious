#!/usr/bin/env perl

use Mojolicious::Lite -signatures;

# using a random secret to make signed cookies tamper resistant.
app->secrets([ join '', map { rand(256) } 1 .. rand(55) ]);

# executed everytime someone tries to access /user
under '/user' => sub ($c) {
    #ensure that only logged users can access this page
    return 1 if (defined($c->session->{username}) && $c->session->{logged_in} == 1);
    #if we reach this point, there is not user logged in
    $c->render(template => 'unauthorized');
    undef;
};

# executed when an authenticated user accesses /user/
get '/' => sub ($c) {
    #render a welcome message to the user
    $c->render(template => 'user_home', username => $c->session->{username});
};

# back to the root of the application
under '/';

# executed when someone accesses /
get '/' => sub ($c) {
    #if theres an user authenticated, redirect to /user
    if (defined($c->session->{username}) && $c->session->{logged_in} == 1)
    {
        $c->redirect_to('/user');
    }
    else
    {
        #Redirect to /login otherwise
        $c->redirect_to('/login');
    }
};

# a very simple logout mechanism
get '/logout' => sub ($c) {
    #clears the username of this session
    $c->session->{username} = undef;
    #sets logged_in to 0
    $c->session->{logged_in} = 0;
    #redirect to /
    $c->redirect_to('/');
};

# login mechanism when the form is submited
post '/login' => sub ($c) {
    #gets the specified username and password
    my ($user, $pass) = ($c->param('user'), $c->param('pass'));
    #let's just pretend I am consulting a database, ok? rsrs
    if ($user eq 'lvmalware' && $pass eq 'password')
    {
        #if the user is registered, save it the username to this session
        $c->session->{username} = $user;
        $c->session->{logged_in} = 1;
        #redirect to the user space /user
        $c->redirect_to('/user');
    }
    else
    {
        #if the user or password does not match
        $c->render(text => 'Wrong password!');
    }
};

# login page when accessed with a GET
get '/login' => sub ($c) {
    $c->render(template => 'login');
};

app->start;

__DATA__

@@ login.html.ep

<html>
    <head>
        <title> Log In </title>
    </head>
    <body>
        <form method='POST'>
            <p> Username: <input type='text' name='user'></p>
            <p> Password: <input type='password' name='pass'></p>
            <input type='submit' value='Log In'>
        </form>
    </body>
</html>

@@ unauthorized.html.ep

<html>
    <head>
        <title> Unauthorized </title>
    </head>
    <body>
        <p> You're not authorized to access this page </p>
        <%= link_to "Log In" => 'login' %>
    </body>
<html>

@@ user_home.html.ep

<html>
    <p> Welcome, <%= $username %> </p>
    <br>
    <%= link_to "Log Out" => 'logout' %>
</html>
