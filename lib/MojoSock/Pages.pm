package MojoSock::Pages;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub logout {
	my $self = shift;
	$self->stash(info => "Welcome, did you try to log in?");
	$self->render(text => "You successfully logged out");
	$self->redirect_to('pages/information');
	return 1;
}

sub information {
	my $self = shift;

	$self->stash(info => "Welcome, did you try to log in?");
}

1;