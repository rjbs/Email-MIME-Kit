package Email::MIME::Kit::Assembler::Alts;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my $email = Email::MIME->create(
    attributes => { content_type => 'multipart/alternative' },
    header => $self->_prep_header($self->manifest->{header}, $stash),
    parts  => [
      map { $_->assemble($stash) } $self->_alternatives
    ],
  );

  my $container = $self->_contain_attachments($email, $stash);
}

no Moose;
1;
