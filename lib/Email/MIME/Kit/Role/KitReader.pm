package Email::MIME::Kit::Role::KitReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';
# ABSTRACT: things that can read kit contents

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role must provide a C<get_kit_entry> method.  It will
be called with one parameter, the name of a path to an entry in the kit.  It
should return a reference to a scalar holding the contents of the named entry.
If no entry is found, it should raise an exception.

=cut

requires 'get_kit_entry';

no Moose::Role;
1;
