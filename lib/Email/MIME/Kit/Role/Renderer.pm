package Email::MIME::Kit::Role::Renderer;
use Moose::Role;

requires 'render';

has kit => (
  is  => 'ro',
  isa => 'Email::MIME::Kit',
  required => 1,
  weak_ref => 1,
);

no Moose::Role;
1;
