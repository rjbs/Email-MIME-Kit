package Email::MIME::Kit::Role::Validator;
use Moose::Role;

with 'Email::MIME::Kit::Role::Component';

requires 'validate';

no Moose::Role;
1;
