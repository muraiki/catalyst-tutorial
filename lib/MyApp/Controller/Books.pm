package MyApp::Controller::Books;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MyApp::Controller::Books - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched MyApp::Controller::Books in Books.');
}


=head2 list

Fetch all book objects and pass to books/list.tt2 in stash to be displayed

=cut

sub list :Local {
	my ($self, $c) = @_;

	$c->stash(books => [$c->model('DB::Book')->all]);

	# $c->stash(books => ' ');

	# not necessary since catalyst will look for tt2 with same name as
	# controller action. However, omitting it will prevent the use of
	# $c->forward and $c->detach
	$c->stash(template => 'books/list.tt2');
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
