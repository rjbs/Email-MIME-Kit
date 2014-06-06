package Email::MIME::Kit::Role::Component;
# ABSTRACT: things that are kit components

use Moose::Role;

=head1 DESCRIPTION

All (or most, anyway) components of an Email::MIME::Kit will perform this role.
Its primary function is to provide a C<kit> attribute that refers back to the
Email::MIME::Kit into which the component was installed.

=cut

has kit => (
  is  => 'ro',
  isa => 'Email::MIME::Kit',
  required => 1,
  weak_ref => 1,
);

no Moose::Role;
1;
