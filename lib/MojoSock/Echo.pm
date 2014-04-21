package MojoSock::Echo;

use strict;
use warnings;

use utf8;
use Mojo::JSON;
use base 'Mojolicious::Controller';
use Data::Dumper;
use DateTime;

my $clients = {};
my $user_online = {};

# Start Websocket for echoing
sub chat {
	my $self = shift;

	# Get Username from Auth::login
	my $username = $self->session('username');

	$self->echo_render("echo/chat", $username, "Place Message here", "", scalar(localtime(time())));
	# Log that Socket has opened
	$self->app->log->debug('Websocket opened');
	$self->app->log->debug('For User: '.$username);
	$self->app->log->debug(sprintf "Client connected %s: ", $self->tx);

	# Incrase inactivity timeout for connection a bit
	Mojo::IOLoop->stream($self->tx->connection)->timeout(300);

	# Set current client into clients hash
	my $client_id = sprintf "%s", $self->tx;
	$clients->{$client_id} = $self->tx;

	# Set current User into user_online hash
	$user_online->{$username} = 'online';

	# Write Data to Hash Array
	$self->on(message => 
		sub {
			my ($self, $msg) = @_;
			#Create new JSON object
			my $json = Mojo::JSON->new;
			# Create current Timestamp
			my $dt   = DateTime->now( time_zone => 'Europe/Zurich');
			# Get Data from Javascript json String
			my $arr = $json->decode($msg);
			# Write Data in Hash Array
			MojoSock::write_data($arr->{'id'}, $arr->{'data'});

			$self->echo_render("echo/chat", $arr->{'id'}, "Place Message here", $arr->{'data'}, scalar(localtime(time())));

			# Send message back to single client
			#$self->send("encoded echo: ".$arr->{'id'}." => ".$arr->{'data'});

			# Send Message to all users;
			# Get all users from Array
			for (keys %$clients){
				$clients->{$_}->send(
					$json->encode({
						user => $arr->{'id'},
						hms => $dt->hms,
						text => $arr->{'data'},
						user_online => $user_online,
						})
				);
			}


			print Dumper(MojoSock::data_in);
		}
	);

	# Closed
	$self->on(finish => 
		sub {
			my ($self, $code, $reason) = @_;

			# Delete Client from hash arrays
			delete $clients->{$client_id};
			delete $user_online->{$username};
			$self->app->log->debug("Websocket closed with status".$code);
		}
	);
}



# Display user data
sub show {
	my $self = shift;
	# Write users Hash to Stash for Rendering in Show.html.ep
	$self->render(user => $self->stash('username'),
								users => MojoSock::userdata,
								data_in => MojoSock::data_in
								partial => 1);
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