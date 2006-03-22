package Email::MIME::Kit::Part::File::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Part::File);

__PACKAGE__->renderer_class('Email::MIME::Kit::Renderer::TT');

=head1 NAME

Email::MIME::Kit::Part::File::TT

=head1 SEE ALSO

L<Email::MIME::Kit::Part::File>
L<Email::MIME::Kit::Render::TT>

=cut

1;
