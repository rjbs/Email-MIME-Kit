package Email::MIME::Kit::Assembler::FromFile;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my $body_ref = $self->kit->get_kit_entry($self->manifest->{path});
     $body_ref = $self->render($body_ref, $stash);

  my %attr = %{ $self->manifest->{attributes} || {} };
  $attr{content_type} = $attr{content_type} || 'text/plain';

  my $email = $self->_contain_attachments({
    attributes => \%attr,
    header     => $self->manifest->{header},
    stash      => $stash,
    body       => $$body_ref,
    container_type => $self->manifest->{container_type},
  });
}

no Moose;
1;
