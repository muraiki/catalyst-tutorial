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


=head2 url_create

Create a book with the supplied title, rating, and author.

=cut

sub url_create :Chained('base') :PathPart('url_create') :Args(3) {
	my ($self, $c, $title, $rating, $author_id) = @_;

	my $book = $c->model('DB::Book')->create({
		title	=>	$title,
		rating	=>	$rating
		});

	$book->add_to_book_authors({author_id => $author_id});

	$c->stash(book	   => $book,
			  template => 'books/create_done.tt2');

	$c->response->header('Cache-Control' => 'no-cache');
}


=head2 base

Can place common logic to start chained dispatch here

=cut

sub base :Chained('/') :PathPart('books') :CaptureArgs(0) {
	my ($self, $c) = @_;

	# Store the resultset in stash so available for other methods
	$c->stash(resultset => $c->model('DB::Book'));

	$c->log->debug('*** INSIDE BASE METHOD ***');
}


=head2 object

Fetch the specified book object based on the book ID and store
it in the stash.

=cut

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
	my ($self, $c, $id) = @_;

	$c->stash(object => $c->stash->{resultset}->find($id));

	# Make sure the lookup was successful.  You would probably
	# want to do something like this in a real app:
	#   $c->detach('/error_404') if !$c->stash->{object};
	die "Book $id not found!" if !$c->stash->{object};

	# Print a message to the debug log
	$c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
}


=head2 form_create

Display form to collect information for book to create

=cut

sub form_create :Chained('base') :PathPart('form_create') :Args(0) {
	my ($self, $c) = @_;

	$c->stash(template => 'books/form_create.tt2');
}


=head2 form_create_do

Take information from form and add to database

=cut

sub form_create_do :Chained('base') :PathPart('form_create_do') :Args(0) {
	my ($self, $c) = @_;

	my $title = $c->request->params->{title} || 'N/A';
	my $rating = $c->request->params->{rating} || 'N/A';
	my $author_id = $c->request->params->{author_id} || '1';

	my $book = $c->model('DB::Book')->create({
		title	=> $title,
		rating	=> $rating
		});

	$book->add_to_book_authors({author_id => $author_id});

	$c->stash(book		=> $book,
			  template	=> 'books/create_done.tt2');
}


=head2 delete

Delete a book

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
	my ($self, $c) = @_;

	my $book_title = $c->stash->{object}->title;

	# Use the book object saved by the object chain; delete it
	# along with related book_author entries (see cascade
	# in model)
	$c->stash->{object}->delete;

	# Set a staus message to be displayed at the top of the view
	# Doesn't work now that we're using redirect instead of forward.
	# $c->stash->{status_msg} = "$book_title deleted.";

	$c->response->redirect($c->uri_for($self->action_for('list'),
		{status_msg => "$book_title deleted."}));
}


=head2 list_recent

List recently created books

=cut

sub list_recent :Chained('base') :PathPart('list_recent') :Args(1) {
	my ($self, $c, $mins) = @_;

	$c->stash(books => [$c->model('DB::Book')
						    ->created_after(DateTime->now->subtract(minutes => $mins))]);

	$c->stash(template => 'books/list.tt2');
}


=head2 list_recent_tcp

List recently created books

=cut

sub list_recent_tcp :Chained('base') :PathPart('list_recent_tcp') :Args(1) {
	my ($self, $c, $mins) = @_;

	$c->stash(books => [
			$c->model('DB::Book')
			    ->created_after(DateTime->now->subtract(minutes => $mins))
			    ->title_like('TCP')
		]);

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
