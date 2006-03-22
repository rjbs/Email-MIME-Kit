package Email::MIME::Kit::Header;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Component::Data);

use Scalar::Util ();

__PACKAGE__->mk_ro_accessors(
  qw(name value)
);

=head1 NAME

Email::MIME::Kit::Header

=head1 METHODS

=head2 reform

Transform a hashref with a single key and a single value
into a hashref with 'name' and 'value' as keys:

  my $header = Email::MIME::Kit::Header->reform({ "X-Foo" => "bar" });
  print $header->{name};   # "X-Foo"
  print $header->{value};  # "bar"

This is called automatically by kit loading; you should not
have to call it manually.

A second hashref may be passed in, whose keys and values
will be merged into the header as well.

=cut

sub reform {
  my ($class, $arg, $extra) = @_;
  $extra ||= {};
  my ($name, $value) = (keys %$arg, values %$arg);
  my $new = {
    name  => $name,
    value => $value,
    %$extra,
  };
  # despite the name, this is not a real subclass -- it'll
  # be something like "TT"
  if (my $subclass = Scalar::Util::blessed($arg)) {
    bless $new => $subclass;
  }
  return $new;
}

=head2 render

Joins name and value as described above.

=cut

sub render {
  my ($self, $stash) = @_;
  return $self->renderer->render($self->value, $stash);
}

1;
