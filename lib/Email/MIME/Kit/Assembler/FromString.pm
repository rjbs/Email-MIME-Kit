package Email::MIME::Kit::Assembler::FromString;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

our $VERSION = '0.001';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my $body = $self->manifest->{body};

  # I really shouldn't have to do this, but I'm not going to go screw around
  # with @#$@#$ Email::Simple/MIME just to deal with it right now. -- rjbs,
  # 2009-01-19
  $body .= "\x0d\x0a" unless $body =~ /[\x0d|\x0a]\z/;

  my %attr = %{ $self->manifest->{attributes} || {} };
  $attr{content_type} = $attr{content_type} || 'text/plain';

  my $email = $self->_contain_attachments({
    attributes => \%attr,
    header     => $self->manifest->{header},
    stash      => $stash,
    body       => $body,
    container_type => $self->manifest->{container_type},
  });
}

no Moose;
1;
