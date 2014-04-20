package MojoSock::Cities;

use strict;
use warnings;

use base 'Mojolicious::Controller';

my %cities = (
		new_york => 'New York is famous for its Statue of Liberty',
		paris => 'Paris is famous for its Eiffel Tower'
		);

sub show {
	my $self = shift;

	my $city_info = $cities{ $self->stash('id')};

	$self->render(text => 'City not found!') unless $city_info;

	$self->stash(our_data => $city_info);

}

sub index {
	my $self = shift;

	$self->stash(cities => \%cities);
}

sub create {
	my $self = shift;

	my $new_city_name = $self->param('name');
	my $new_city_info = $self->param('info');

	$cities{$new_city_name} = $new_city_info;

	$self->redirect_to('cities_show', id => $self->param('name'));
}

sub edit {
	my $self = shift;

	my $city_info = $cities{ $self->stash('id')};

	$self->stash(info => $city_info);
}

sub update {
	my $self = shift;


	my $new_city_name = $self->param('name');
	my $new_city_info = $self->param('info');

	if ($cities{$new_city_name}){
		$cities{$new_city_name} = $new_city_info;
		$self->redirect_to('cities_show', id => $self->param('name'));
	} else {
		$self->render(text => 'city not found');
	}
}

1;