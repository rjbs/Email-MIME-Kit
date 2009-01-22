package Email::MIME::Kit::Role::Validator;
use Moose::Role;

our $VERSION = '0.001';

with 'Email::MIME::Kit::Role::Component';

requires 'validate';

no Moose::Role;
1;
