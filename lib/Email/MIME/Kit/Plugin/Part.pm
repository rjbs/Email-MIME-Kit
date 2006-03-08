package Email::MIME::Kit::Plugin::Part;

use strict;
use warnings;

use Scalar::Util ();
use base qw(Class::Accessor);

__PACKAGE__->mk_ro_accessors(
  qw(header parts body type root)
);

my $PLUGIN_BASE = "Email::MIME::Kit::Plugin";

sub new {
  my ($class, $arg) = @_;
  for my $default (
    [ header => [] ],
    [ parts  => [] ],
    [ body   => '' ],
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
    $part->{root} = $self->root;
    $part = __PACKAGE__->new($part);
  }
}

sub render {
  my ($self, $stash) = @_;
  return $self->body;
}
  

sub assemble {
  my ($self, $stash) = @_;
  use Data::Dumper;
  my %arg = (
    attributes => {
      content_type => $self->type || "text/plain",
    },
    header => [
      map { $_->name => $_->render($stash) } @{ $self->header }
    ],
    @{ $self->parts } ?
      (parts => [ map { $_->assemble($stash) } @{$self->parts} ]) :
        (body => $self->render($stash))
  );
  
  return Email::MIME->create(%arg);
}

1;
