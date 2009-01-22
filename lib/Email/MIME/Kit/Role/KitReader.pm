package Email::MIME::Kit::Role::KitReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

our $VERSION = '0.001';

requires 'get_kit_entry';

no Moose::Role;
1;
