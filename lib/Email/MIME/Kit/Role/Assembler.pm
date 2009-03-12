package Email::MIME::Kit::Role::Assembler;
use Moose::Role;

with 'Email::MIME::Kit::Role::Component';

our $VERSION = '2.003';

=head1 NAME

Email::MIME::Kit::Role::Assembler - things that assemble messages (or parts)

=cut

requires 'assemble';

no Moose::Role;
1;
