package Email::MIME::Kit::Role::KitReader;
# ABSTRACT: things that can read kit contents

use v5.20.0;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role must provide a C<get_kit_entry> method.  It will
be called with one parameter, the name of a path to an entry in the kit.  It
should return a reference to a scalar holding the contents (as octets) of the
named entry.  If no entry is found, it should raise an exception.

A method called C<get_decoded_kit_entry> is provided.  It behaves like
C<get_kit_entry>, but assumes that the entry for that name is stored in UTF-8
and will decode it to text before returning.

=cut

requires 'get_kit_entry';

sub get_decoded_kit_entry {
  my ($self, $name) = @_;
  my $content_ref = $self->get_kit_entry($name);

  require Encode;
  my $decoded = Encode::decode('utf-8', $$content_ref);
  return \$decoded;
}

no Moose::Role;
1;
