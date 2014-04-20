package MojoSock;
use base 'Mojolicious';
use base 'Mojolicious::Controller';

use Mojolicious::Plugin::Authentication;
use Data::Dumper;

# User Hash Array
my %users = (
  sam => {
    username => "sam",
    password => "loginsam",
    uid => ""
  },
  dave => {
    username => "dave",
    password => "logindave",
    uid => ""
  },
  dom => {
    username => "dom",
    password => "logindom",
    uid => ""
  }
);

my %data_in;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Start Authentication Plugin
  $self->plugin('authentication' => {

    # Initialize User
    'autoload_user' => 1,
    'session_key' => 'chat4app2go',
    # Load User from @_
    'load_user' => sub {
        # Get whole application and uid from validate_user
        my ($app, $uid) = @_;
        # Do User configuration
        print "\nuid=".$uid;
        return \$uid;
      },
    # validate user 
    'validate_user' => sub  {

        my $self = shift;
        # Get Username and Password 
        my ($username, $password) = @_;
      
        if (defined $username && defined $password && defined $users{$username}->{'username'} && $users{$username}->{'password'} eq $password){
          my $uid = $username."234123412".$password;
          $users{$username}->{uid} = $uid;
          # Set Session Vars
          $self->session(expires => time + 10800);
          $self->session(uids => $uid);
          $self->session(username => $username);
          return ($self, $uid); 
        } else {
          # return error if user not exists
          $self->stash(login_error_message => 'Invalid credentials');
          return undef;
        }
      },
    'current_user_fn' => 'socketuser',
    });
  # Set Default Expiry time
  $self->sessions->default_expiration(86400); # set expiry to 1 day
  $self->sessions->default_expiration(3600); # set expiry to 1 hour
  # Create Routing Handler 
  my $r = $self->routes;

  # Route to Authentication checking
  #$r->route('/')->to(controller => 'auth', action =>'check');

  # Route to Login page
  $r->route('/info')->via('get')
  ->to('pages#information')->name('pages_info');

  # Route to Login page
  $r->route('/login')->via('get')
  ->to('auth#login')->name('login_form');

  # Route to login validation
  $r->route('/login')->via('post')
  ->to('auth#login')->name('login_validation');

  $r->route('/logout')->via('get')
  ->to('auth#logout_user')->name('auth_logout');

    # Make a Bridge to the Auth Controller
  my $auth_bridge = $r->bridge('/')->to(controller => 'auth', action => 'check');
  # Protected Sites
  $auth_bridge->route('/')->to('auth#welcome');
  $auth_bridge->route('/echo')->to('echo#start')->name('echo_start');
  $auth_bridge->route('/show')->to('echo#show')->name('echo_show');

  $auth_bridge->websocket('/echo')->name("echo_root")
  ->via('get')->to('echo#start');

  # Generic Placeholder if nothing matches
  # Check if user is logged in
  # $r->route('/:request')->via('get')
  # ->to('auth#check')->name('auth_check');


  # # Check if user is logged in
  # $r->route('/:')->via('get')
  # ->to('auth#check')->name('auth_check');


}
sub userdata {
  return %users;
}

sub write_data {

  my($user, $msg) = @_;

  $data_in{$user}->{time()."|".int(rand(10000))} = $msg;

  return 1;
}

sub data_in {
  return \%data_in;
}

1;
