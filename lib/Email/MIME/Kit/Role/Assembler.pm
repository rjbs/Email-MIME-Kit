package Email::MIME::Kit::Role::Assembler;
# ABSTRACT: things that assemble messages (or parts)

use v5.20.0;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role must provide an C<assemble> method.  This method
will be passed a hashref of assembly parameters, and should return the fully
assembled Email::MIME object.

=cut

requires 'assemble';

no Moose::Role;
1;
