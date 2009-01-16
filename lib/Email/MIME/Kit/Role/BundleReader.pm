package Email::MIME::Kit::Role::BundleReader;
use Moose::Role;

requires 'read_bundle';
requires 'get_bundle_entry';

has kit => (
  is  => 'ro',
  isa => 'Email::MIME::Kit',
  required => 1,
  weak_ref => 1,
);

no Moose::Role;
1;
