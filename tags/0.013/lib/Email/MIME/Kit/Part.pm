package Email::MIME::Kit::Part;

use strict;
use warnings;

use Scalar::Util ();

use base qw(Email::MIME::Kit::Component::Data);

__PACKAGE__->mk_ro_accessors(
  qw(header parts body type parent attributes)
);

my $PLUGIN_BASE = "Email::MIME::Kit";

=head1 NAME

Email::MIME::Kit::Part

=head1 DESCRIPTION

Each EMK::Part is a potential MIME entity.  It may have
'parts' or a 'body'.  It may have a 'header' arrayref.  It
becomes (via C<< assemble >>) an Email::MIME object.

=head1 METHODS

=head2 new

Called by C<< Kit->new >>.  This turns a hashref (from
message.yml) into a real object, including reblessing into a
real Part subclass if it was tagged in YAML (e.g. !File/TT).

=cut

sub new {
  my ($class, $arg) = @_;
  for my $default (
    [ header     => [] ],
    [ parts      => [] ],
    [ body       => '' ],
    [ attributes => {} ],
  ) {
    $arg->{$default->[0]} ||= $default->[1];
  }

  my $self = $class->SUPER::new($arg);
  Scalar::Util::weaken($self->{parent}) if $self->parent;
  $self->normalize;
  return $self;
}

=head2 normalize

For all the headers and parts of this Part, turn hashrefs
into real objects, similar to the process described in
L</new>.

=cut

sub normalize {
  my ($self) = @_;
  for my $header (@{ $self->header }) {
    $header = $self->kit->header_class->instance(
      $self->kit->header_class->reform($header, { kit => $self->kit }),
    );
  }
  for my $part (@{ $self->parts }) {
    $part->{parent} = $self;
    $part->{kit} = $self->kit;
    $part = $self->kit->part_class->instance($part);
  }
}

=head2 render

Use this Part's C<< renderer >> to render the Part's body.

C<< assemble >> calls this as necessary.  You should not
need to call it explicitly.

=cut

sub render {
  my ($self, $stash) = @_;
  return $self->renderer->render($self->body, $stash);
}

=head2 assemble

  my $mime = $part->assemble($stash);

Assemble this Part into an Email::MIME.  C<< type >> is
passed as the 'content_type' attribute, along with anything
else in the 'attributes' mapping.

Likewise, all headers are rendered and passed in as the
'header' parameter to C<< Email::MIME->create >>.

If this Part has C<< parts >>, recursively calls C<<
assemble >> on each of them, passing in the stash.

=cut

sub assemble {
  my ($self, $stash) = @_;

  my %arg = (
    attributes => {
      content_type => $self->type || "text/plain",
      %{ $self->attributes },
    },
    header => [
      map { $_->name => $_->render($stash) } @{ $self->header }
    ],
    # prefer parts over body, like Email::MIME::Creator
    @{ $self->parts } ?
      (parts => [ map { $_->assemble($stash) } @{$self->parts} ]) :
        (body => $self->render($stash))
  );
  
  return Email::MIME->create(%arg);
}

1;
