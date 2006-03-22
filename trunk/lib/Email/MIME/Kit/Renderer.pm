package Email::MIME::Kit::Renderer;

use strict;
use warnings;
use base qw(Email::MIME::Kit::Component);

=head1 NAME

Email::MIME::Kit::Renderer

=head1 DESCRIPTION

EMK renderers should have a 'render' method, invoked thusly:

  $output = $renderer->render($input, \%vars, \@args);

where C<< %vars >> are content variables and C<< @args >>
are extra arguments to the renderer.

=head1 RENDERERS

=over 4

=item *

B<Plain> returns values unchanged (default)

=item *

B<TT> treats input as a TT template string

=back

=head1 SEE ALSO

L<Email::MIME::Kit::Component>

L<Email::MIME::Kit::Renderer::Plain>

L<Email::MIME::Kit::Renderer::TT>

=cut

1;
