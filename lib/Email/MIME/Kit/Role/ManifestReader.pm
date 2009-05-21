package Email::MIME::Kit::Role::ManifestReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

our $VERSION = '2.004';

=head1 NAME

Email::MIME::Kit::Role::ManifestReader - things that read kit manifests

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role must provide a C<read_manifest> method, which is
expected to locate and read a manifest for the kit.  Classes implementing this
role should probably include L<Email::MIME::Kit::Role::ManifestDesugarer>, too.

=cut

requires 'read_manifest';

no Moose::Role;
1;
