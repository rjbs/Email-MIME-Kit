package Email::MIME::Kit::Header::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Header);

__PACKAGE__->renderer_class('Email::MIME::Kit::Renderer::TT');

=head1 NAME

Email::MIME::Kit::Header::TT

=head1 SEE ALSO

L<Email::MIME::Kit::Header>
L<Email::MIME::Kit::Renderer::TT>

=cut

1;
