package Email::MIME::Kit::Role::Renderer;
use Moose::Role;
with 'Email::MIME::Kit::Role::Component';

our $VERSION = '2.004';

=head1 NAME

Email::MIME::Kit::Role::Renderer - things that render templates into contents

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

Classes implementing this role must provide a C<render> method, which is
expected to turn a template and arguments into rendered output.  The method is
used like this:

  my $output_ref = $renderer->render($input_ref, \%arg);

=cut

requires 'render';

no Moose::Role;
1;
