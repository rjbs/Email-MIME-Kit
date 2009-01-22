package Email::MIME::Kit::Role::KitReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

our $VERSION = '0.001';

=head1 NAME

Email::MIME::Kit::Role::KitReader - things that can read kit contents

=cut

requires 'get_kit_entry';

no Moose::Role;
1;
