package Email::MIME::Kit::Role::ManifestReader;
use Moose::Role;

requires 'read_manifest';

has kit => (
  is  => 'ro',
  isa => 'Email::MIME::Kit',
  required => 1,
  weak_ref => 1,
);

no Moose::Role;
1;
