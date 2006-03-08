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

=head1 NAME

Email::MIME::Kit::Header

=head1 METHODS

=head2 C<< new >>

Transform a hashref with a single key and a single value into an object:

  my $header = Email::MIME::Kit::Header->new({ "X-Foo" => "bar" });
  print $header->name;   # "X-Foo"
  print $header->value;  # "bar"
  print $header->render; # "X-Foo: bar"

=cut

sub new {
  my ($class, $arg) = @_;
  my ($name, $value) = (keys %$arg, values %$arg);
  return $class->SUPER::new({
    name  => $name,
    value => $value,
  });
}

=head2 C<< render >>

Joins name and value as described above.

=cut

sub render {
  my ($self, $stash) = @_;
  return $self->renderer->render($self->value, $stash);
}

1;
