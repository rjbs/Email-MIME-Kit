package Email::MIME::Kit::Assembler::FromFile;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my $body_ref = $self->kit->get_kit_entry($self->manifest->{path});
     $body_ref = $self->render($body_ref, $stash);

  my $header = $self->_prep_header($self->manifest->{header}, $stash);

  my $email = Email::MIME->create(
    header => $header,
    body   => $$body_ref,
  );

  my $container = $self->_contain_attachments($email, $stash);
}

no Moose;
1;
