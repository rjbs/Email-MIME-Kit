package Email::MIME::Kit::Renderer::TT;

use strict;
use warnings;
use Template;

my $TT;

sub _tt {
  $TT ||= Template->new(
    ABSOLUTE => 1,
    RELATIVE => 1,
  );
}

=head1 NAME

Email::MIME::Kit::Renderer::TT

=head1 METHODS

=head2 C<< render >>

  my $text = $renderer->render($input, $stash, [ $output, %opt ]);

Passes arguments (flattening as necessary) to Template->process.

If C<< $output >> is undef, defaults to returning a string
rather than printing to STDOUT (unlike Template).

=cut

sub render {
  my ($self, $input, $stash, $args) = @_;
  $stash ||= {};
  my ($output, %opt) = @{ $args || [] };
  my $return;
  unless ($output) {
    $output = \$return;
  }
  $self->_tt->process(\$input, $stash, $output, %opt)
    or die $self->_tt->error, "\n";
  return $return;
}

1;

