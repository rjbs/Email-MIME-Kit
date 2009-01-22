package Email::MIME::Kit::Role::ManifestReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

our $VERSION = '0.001';

requires 'read_manifest';

no Moose::Role;
1;
