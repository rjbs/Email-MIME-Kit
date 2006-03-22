package Email::MIME::Kit::Part::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Part);

__PACKAGE__->renderer_name('TT');

=head1 NAME

Email::MIME::Kit::Part::TT

=head1 DESCRIPTION

Render 'body' as a TT template string instead of using it
unchanged.

=head1 SEE ALSO

L<Email::MIME::Kit::Renderer::TT>

=cut

1;
