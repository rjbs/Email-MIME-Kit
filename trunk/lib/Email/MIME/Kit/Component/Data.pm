package Email::MIME::Kit::Component::Data;

use strict;
use warnings;
use base qw(Email::MIME::Kit::Component
            Class::Data::Inheritable
          );

use Scalar::Util ();

__PACKAGE__->mk_accessors('_renderer');

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
  $self->_renderer || $self->_renderer(
    $self->renderer_class->new({
      kit => $self->kit
    }),
  );
}

=head1 CLASS DATA

=head2 renderer_class

Which class to use for C<< renderer >>.

Defaults to 'Email::MIME::Kit::Renderer::Plain'.

=cut

__PACKAGE__->mk_classdata('renderer_class');
__PACKAGE__->renderer_class('Email::MIME::Kit::Renderer::Plain');

1;
