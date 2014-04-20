package MojoSock::Auth;

use strict;
use warnings;

use base 'Mojolicious::Controller';
use Data::Dumper;


# Check if user is logged in.
sub check{

	my $self = shift;
	# Return 1 if user is already authenticated, else render the login form
	if ($self->is_user_authenticated){
		# Do something
		return 1;
	} else {
		
		$self->render(info => "not logged in");
		$self->render('auth/login_form');
		return undef;
	}
}

# Check user credentials an log in user
sub login {

	my $self = shift;

	# Check if User is already authentcated
	if ($self->req->method eq 'GET') {
		$self->redirect_to('pages_info');
		return undef;
	} else {
		# Get Data from POST
		my %user = (
				username => my $username = $self->req->body_params->param('username'),
				password => my $password = $self->req->body_params->param('password')
			);
		# Authenticate user
		if($self->authenticate($user{username}, $user{password})){

			#Set username and uid in stash and redirect to Echo Start Page
			$self->stash(username=>$username, info => 'Authentication successful');
			$self->redirect_to('echo_start');
			return 1;
		} else {
			# Send User back to login Page
			$self->logout;
			$self->stash(info => "Authentication failure");
			$self->redirect_to('pages_info');
		}
	}	
}

sub logout_user {

	my $self = shift;

	# Reset Session
	if ($self->is_user_authenticated){
		#print Dumper($self->logout);

		print Dumper($self->session);
		$self->logout;
		$self->session(expires => 1);
		$self->stash(info => "Bye Bye");
		$self->redirect_to('pages_info');
		return undef;
	} else {
		$self->redirect_to('pages_info');
	}
}


# Welcome user if logged in
sub welcome {

	my $self = shift;

	$self->render(text => "Welcome your logged in");
}


1;
