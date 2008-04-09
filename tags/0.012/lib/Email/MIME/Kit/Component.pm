package Email::MIME::Kit::Component;

use strict;
use warnings;
use base qw(Class::Accessor::Fast);
use Scalar::Util ();

__PACKAGE__->mk_ro_accessors(
  'kit',
);

=head1 NAME

Email::MIME::Kit::Component

=head1 DESCRIPTION

Base class for all components of a kit:

=over

=item * L<Renderer|Email::MIME::Kit::Renderer>

=item * L<Part|Email::MIME::Kit::Part>

=item * L<Header|Email::MIME::Kit::Header>

=back

=head1 METHODS

=head2 new

See L<Class::Accessor::Fast>.

=head2 kit

Returns the kit that this component belongs to.

=cut

sub new {
  my $class = shift;
  my $self  = $class->SUPER::new(@_);
  Scalar::Util::weaken($self->{kit}) if $self->kit;
  return $self;
}

1;
