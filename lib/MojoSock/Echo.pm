package MojoSock::Echo;

use strict;
use warnings;

use JSON;
use base 'Mojolicious::Controller';
use Data::Dumper;


# Start Websocket for echoing
sub start {
	my $self = shift;

	# Get Username from Auth::login
	my $username = $self->session('username');
	# Get all users from Array
	#my %users = MojoSock::userdata;
	#my %data_in = &MojoSock::data_in;
	print "\nUsername:".Dumper($username);

	$self->echo_render("echo/start", $username, "Place Message here", "", scalar(localtime(time())));
	# Log that Socket has opened
	$self->app->log->debug('Websocket opened');
	$self->app->log->debug('For User: '.$username);

	# Incrase inactivity timeout for connection a bit
	Mojo::IOLoop->stream($self->tx->connection)->timeout(300);

	# Incoming message direct
	# $self->on(message => sub {
	# 	my ($self, $msg) = @_;
	# 	$self->send("direct echo: $msg");
	# 	});

	# Write Data to Hash Array
	$self->on(message => sub {
		my ($self, $json,) = @_;
		# Get Data from Javascript json String
		my $arr = decode_json($json);
		# Write Data in Hash Array
		MojoSock::write_data($arr->{'id'}, $arr->{'data'});
		#$data_in{$arr->{'id'}.time()} = $arr->{'data'};
		#print Dumper(%users);
		#$self->stash(users => \%users);

		$self->echo_render("echo/start", $arr->{'id'}, "Place Message here", $arr->{'data'}, scalar(localtime(time())));

		$self->send("encoded echo: ".$arr->{'id'}." => ".$arr->{'data'});

		print Dumper(MojoSock::data_in);
	});

	# Closed
	$self->on(finish => sub {
		my ($self, $code, $reason) = @_;
		$self->app->log->debug("Websocket closed with status".$code);
	});
}

# Display user data
sub show {
	my $self = shift;
	# Write users Hash to Stash for Rendering in Show.html.ep
	$self->stash(user => $self->session('username'));
	$self->stash(users => MojoSock::userdata);
	$self->stash(data_in => MojoSock::data_in);
}

sub echo_render{

my ($self, $template, $username, $msg, $message, $time ) = @_;

$self->render(template => $template,
								user => $username,
								msg => $msg,
								message => $message,
								time => $time,
								partial => 1);
}

1;