package Email::MIME::Kit::Role::Assembler;
use Moose::Role;

with 'Email::MIME::Kit::Role::Component';

requires 'assemble';

no Moose::Role;
1;
