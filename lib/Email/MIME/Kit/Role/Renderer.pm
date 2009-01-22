package Email::MIME::Kit::Role::Renderer;
use Moose::Role;

our $VERSION = '0.001';

=head1 NAME

Email::MIME::Kit::Role::Renderer - things that render templates into contents

=cut

requires 'render';

has kit => (
  is  => 'ro',
  isa => 'Email::MIME::Kit',
  required => 1,
  weak_ref => 1,
);

no Moose::Role;
1;
