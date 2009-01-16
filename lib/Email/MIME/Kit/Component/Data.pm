package Email::MIME::Kit::Component::Data;

use strict;
use warnings;
use base qw(Email::MIME::Kit::Component
            Class::Data::Inheritable
          );

use Scalar::Util ();

=head1 NAME

Email::MIME::Kit::Component::Data

=head1 DESCRIPTION

Component subclass for message data (headers and parts).

=head1 CLASS METHODS

=head2 instance

Used only by kit loading.

Expects a (possibly blessed) hashref argument, which C<<
instance >> turns into an object of the appropriate
subclass.

=cut

sub instance {
  my ($class, $arg) = @_;
  my $use_class = $class;
  if (my $subclass = Scalar::Util::blessed($arg)) {
    $use_class .= "::$subclass";
  }
  return $use_class->new($arg);
}

=head2 OBJECT METHODS

=head2 renderer

Instantiate (if needed) a renderer object and return it.

=cut

sub renderer {
  my $self = shift;
  return $self->kit->renderer($self->renderer_name);
}

=head1 CLASS DATA

=head2 renderer_name

Which class to use for C<< renderer >>.

Defaults to 'Plain'.

=cut

__PACKAGE__->mk_classdata('renderer_name');
__PACKAGE__->renderer_name('Plain');

1;
