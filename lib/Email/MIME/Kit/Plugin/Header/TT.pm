package Email::MIME::Kit::Plugin::Header::TT;

use strict;
use warnings;
use base qw(
            Email::MIME::Kit::Plugin::Header
            Email::MIME::Kit::Plugin::TT
          );

sub render {
  my ($self, $stash) = @_;
  my $text = $self->SUPER::render($stash);
  return $self->tt_process(\$text, $stash);
}

1;
