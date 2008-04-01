package Email::MIME::Kit::Part::File;

use strict;
use warnings;
use File::Spec;
use base qw(Email::MIME::Kit::Part);

=head1 NAME

Email::MIME::Kit::Part::File

=head1 METHODS

=head2 C<< path >>

Returns the path for this Part.

This uses EMK::Part's C<< render >> method to pull out the
body.

=head2 C<< render >>

Read from C<< $part->path >> and return its contents as this
Part's body.

=cut

sub path {
  my ($self, $stash) = @_;
  return File::Spec->catdir(
    $self->kit->dir,
    $self->SUPER::render($stash),
  );
}

sub render {
  my ($self, $stash) = @_;
  my $text = Email::MIME::Kit::_slurp($self->path($stash));
  return $self->renderer->render($text, $stash);
}

1;
