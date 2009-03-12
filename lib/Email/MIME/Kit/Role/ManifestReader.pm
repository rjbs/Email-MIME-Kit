package Email::MIME::Kit::Role::ManifestReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

our $VERSION = '2.003';

=head1 NAME

Email::MIME::Kit::Role::ManifestReader - things that read kit manifests

=cut

requires 'read_manifest';

no Moose::Role;
1;
