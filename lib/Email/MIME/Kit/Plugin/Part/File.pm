package Email::MIME::Kit::Plugin::Part::File;

use strict;
use warnings;
use IO::All ();
use base qw(Email::MIME::Kit::Plugin::Part);

sub filename {
  my ($self, $stash) = @_;
  return join("/", $self->root, $self->SUPER::render($stash));
}

sub render {
  my ($self, $stash) = @_;
  my $text = IO::All::io(
    $self->filename($stash),
  )->all;
  return $text;
}

1;
