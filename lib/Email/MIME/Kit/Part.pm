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
  #$subclass ||= "Multipart" if @{$arg->{parts}};
  $class .= "::$subclass" if $subclass;
  #warn "blessing into $class\n";
  my $self = $class->SUPER::new($arg);
  $self->normalize;
  return $self;
}

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

sub render {
  my ($self, $stash) = @_;
  return $self->renderer->render($self->body, $stash);
}

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
