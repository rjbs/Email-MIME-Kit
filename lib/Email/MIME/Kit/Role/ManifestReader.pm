package Email::MIME::Kit::Role::ManifestReader;
# ABSTRACT: things that read kit manifests

use v5.20.0;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role must provide a C<read_manifest> method, which is
expected to locate and read a manifest for the kit.  Classes implementing this
role should probably include L<Email::MIME::Kit::Role::ManifestDesugarer>, too.

=cut

requires 'read_manifest';

no Moose::Role;
1;
