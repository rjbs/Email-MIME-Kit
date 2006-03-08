package Email::MIME::Kit::Plugin::Header;

use strict;
use warnings;

use base qw(Class::Accessor);

__PACKAGE__->mk_ro_accessors(
  qw(name value)
);

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
  return $self->value;
}

1;
