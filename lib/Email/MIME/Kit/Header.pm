package Email::MIME::Kit::Header;

use strict;
use warnings;

use base qw(
            Class::Accessor
            Class::Data::Inheritable
          );

__PACKAGE__->mk_classdata('renderer');
__PACKAGE__->mk_ro_accessors(
  qw(name value)
);

__PACKAGE__->renderer('Email::MIME::Kit::Renderer::Plain');

sub new {
  my ($class, $arg) = @_;
  my ($name, $value) = (keys %$arg, values %$arg);
  return $class->SUPER::new({
    name  => $name,
    value => $value,
  });
}

sub render {
  my ($self, $stash) = @_;
  return $self->renderer->render($self->value, $stash);
}

1;
