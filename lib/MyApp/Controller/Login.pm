package MyApp::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MyApp::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Login logic

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Get user and pass from form
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};

    if ($username && $password) {
    	# Try to login if user and pass supplied
    	if ($c->authenticate({ username => $username,
    						   password => $password })) {
    		$c->response->redirect($c->uri_for(
    			$c->controller('Books')->action_for('list')));
    		return;
    	} else {
    		# Could not log user in
    		$c->stash(error_msg => "Bad username or password.");
    	}
    } else {
    	# Set an error message
    	$c->stash(error_msg => "Empty username or password.")
    		unless ($c->user_exists);
    }

    # If eitehr of the above don't work out, send to login page
    $c->stash(template => 'login.tt2');
}



=encoding utf8

=head1 AUTHOR

muraiki,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
