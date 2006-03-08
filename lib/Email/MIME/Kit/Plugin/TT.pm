package Email::MIME::Kit::Plugin::TT;

use strict;
use warnings;
use Template;

my $TT;

sub tt {
  $TT ||= Template->new;
}

sub tt_process {
  my ($self, $input, $stash, $output, %opt) = @_;
  my $return;
  unless ($output) {
    $output = \$return;
  }
  $self->tt->process($input, $stash, $output, %opt)
    or die $self->tt->error, "\n";
  return $return;
}

1;

