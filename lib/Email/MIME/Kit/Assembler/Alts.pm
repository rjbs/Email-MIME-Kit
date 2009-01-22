package Email::MIME::Kit::Assembler::Alts;
use Moose;

our $VERSION = '0.001';

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my %attr = %{ $self->manifest->{attributes} || {} };
  $attr{content_type} = $attr{content_type} || 'multipart/alternative';

  if ($attr{content_type} !~ qr{\Amultipart/alternative\b}) {
    confess "illegal content_type for mail with alts: $attr{content_type}";
  }

  my $parts = [ map { $_->assemble($stash) } $self->_alternatives ];

  my $email = $self->_contain_attachments({
    attributes => \%attr,
    header     => $self->manifest->{header},
    stash      => $stash,
    parts      => $parts,
  });
}

no Moose;
1;
