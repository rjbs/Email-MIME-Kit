package Email::MIME::Kit::Part;

use strict;
use warnings;

use Scalar::Util ();
use base qw(
            Class::Accessor
            Class::Data::Inheritable
          );

__PACKAGE__->mk_classdata('renderer');
__PACKAGE__->mk_ro_accessors(
  qw(header parts body type parent kit attributes)
);
__PACKAGE__->renderer('Email::MIME::Kit::Renderer::Plain');

my $PLUGIN_BASE = "Email::MIME::Kit";

=head1 NAME

Email::MIME::Kit::Part

=head1 DESCRIPTION

Each EMK::Part is a potential MIME entity.  It may have
'parts' or a 'body'.  It may have a 'header' arrayref.  It
becomes (via C<< assemble >>) an Email::MIME object.

=head1 METHODS

=head2 C<< new >>

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

  my $subclass = Scalar::Util::blessed($arg);
  $class .= "::$subclass" if $subclass;

  # avoid $class->SUPER::new because it makes a copy and
  # would undo the weakening of refs

  my $self = bless $arg => $class;
  $self->normalize;
  return $self;
}

=head2 C<< normalize >>

For all the headers and parts of this Part, turn hashrefs
into real objects, similar to the process described in
L</new>.

=cut

sub normalize {
  my ($self) = @_;
  for my $header (@{ $self->header }) {
    my $class = Scalar::Util::blessed($header);
    $class = "Header" . ($class ? "::$class" : "");
    $header = "$PLUGIN_BASE\::$class"->new($header);
  }
  for my $part (@{ $self->parts }) {
    $part->{parent} = $self;
    $part->{kit} = $self->kit;
    Scalar::Util::weaken($part->{$_}) for qw(parent kit);
    $part = __PACKAGE__->new($part);
  }
}

=head2 C<< render >>

Use this Part's C<< renderer >> to render the Part's body.

=cut

sub render {
  my ($self, $stash) = @_;
  return $self->renderer->render($self->body, $stash);
}

=head2 C<< assemble >>

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
