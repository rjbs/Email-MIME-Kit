package Email::MIME::Kit::Renderer::Plain;

use strict;
use warnings;

=head1 NAME

Email::MIME::Kit::Renderer::Plain

=head1 METHODS

=head2 C<< render >>

A simple renderer that does nothing but return the value
it's asked to render, unchanged.

=cut

sub render {
  my ($self, $input) = @_;
  return $input;
}

1;
