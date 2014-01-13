package MyApp::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    INCLUDE_PATH => [
    	MyApp->path_to( 'root', 'src'),
    ],

    # Set to 1 for detailed timer stats in HTML as comments
    TIMER => 0,

    WRAPPER => 'wrapper.tt2',

    render_die => 1,
);

=head1 NAME

MyApp::View::HTML - TT View for MyApp

=head1 DESCRIPTION

TT View for MyApp.

=head1 SEE ALSO

L<MyApp>

=head1 AUTHOR

muraiki,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
