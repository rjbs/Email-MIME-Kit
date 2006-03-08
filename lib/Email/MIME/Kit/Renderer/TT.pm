package Email::MIME::Kit::Renderer::TT;

use strict;
use warnings;
use Template;

my $TT;

sub tt {
  $TT ||= Template->new;
}

sub render {
  my ($self, $input, $stash, $args) = @_;
  $stash ||= {};
  my ($output, %opt) = @{ $args || [] };
  my $return;
  unless ($output) {
    $output = \$return;
  }
  $self->tt->process(\$input, $stash, $output, %opt)
    or die $self->tt->error, "\n";
  return $return;
}

1;

