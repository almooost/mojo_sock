package MojoSock::Test;
use strict;
use warnings;

use base 'Mojolicious::Controller';

sub me {
	my $self = shift;

	$self->render(text => "This is a Test Site The Stash id is:".$self->stash('id'));
}
1;