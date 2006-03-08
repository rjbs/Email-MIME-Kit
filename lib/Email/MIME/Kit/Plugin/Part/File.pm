package Email::MIME::Kit::Plugin::Part::File;

use strict;
use warnings;
use File::Spec;
use base qw(Email::MIME::Kit::Plugin::Part);

sub filename {
  my ($self, $stash) = @_;
  return File::Spec->catdir(
    $self->kit->dir,
    $self->SUPER::render($stash),
  );
}

sub render {
  my ($self, $stash) = @_;
  my $text = Email::MIME::Kit::_slurp($self->filename($stash));
  return $self->renderer->render($text, $stash);
}

1;
