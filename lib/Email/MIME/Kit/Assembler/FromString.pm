package Email::MIME::Kit::Assembler::FromString;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my $email = Email::MIME->create(
    header => $self->_prep_header($self->manifest->{header}, $stash),
    body   => $self->manifest->{body},
  );
}

no Moose;
1;
