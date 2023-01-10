package Email::MIME::Kit::Role::Validator;
# ABSTRACT: things that validate assembly parameters

use v5.20.0;
use Moose::Role;

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role are used to validate that the arguments passed
to C<< $mkit->assemble >> are valid.  Classes must provide a C<validate> method
which will be called with the hashref of values passed to the kit's C<assemble>
method.  If the arguments are not valid for the kit, the C<validate> method
should raise an exception.

=cut

with 'Email::MIME::Kit::Role::Component';

requires 'validate';

no Moose::Role;
1;
