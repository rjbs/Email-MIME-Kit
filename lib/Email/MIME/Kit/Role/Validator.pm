package Email::MIME::Kit::Role::Validator;
use Moose::Role;

our $VERSION = '2.004';

=head1 NAME

Email::MIME::Kit::Role::Validator - things that validate assembly parameters

=cut

with 'Email::MIME::Kit::Role::Component';

requires 'validate';

no Moose::Role;
1;
