package Email::MIME::Kit::Assembler::Simple;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  require Data::Dumper;
  printf "time to assemble: %s\n", Data::Dumper::Dumper($stash);
}

no Moose;
1;
