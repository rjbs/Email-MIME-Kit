package Email::MIME::Kit::Role::KitReader;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

requires 'get_kit_entry';

no Moose::Role;
1;
