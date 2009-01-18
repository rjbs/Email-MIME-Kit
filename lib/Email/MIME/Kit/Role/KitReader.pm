package Email::MIME::Kit::Role::KitReader;
use Moose::Role;

requires 'get_kit_entry';

has kit => (
  is  => 'ro',
  isa => 'Email::MIME::Kit',
  required => 1,
  weak_ref => 1,
);

no Moose::Role;
1;
