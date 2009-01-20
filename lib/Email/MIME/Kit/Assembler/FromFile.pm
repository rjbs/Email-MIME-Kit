package Email::MIME::Kit::Assembler::FromFile;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my $body_ref = $self->kit->get_kit_entry($self->manifest->{path});

  my $email = Email::MIME->create(
    header => $self->_prep_header($self->manifest->{header}, $stash),
    body   => ${ $self->render($body_ref, $stash) },
  );
}

no Moose;
1;
