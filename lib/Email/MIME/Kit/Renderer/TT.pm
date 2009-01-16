package Email::MIME::Kit::Renderer::TT;

use strict;
use warnings;
use Template;
use Object::Array;

use base qw(Email::MIME::Kit::Renderer);

__PACKAGE__->mk_accessors(
  '_include_path',
  '_include_path_ref',
  '_tt',
);

=head1 NAME

Email::MIME::Kit::Renderer::TT

=head1 METHODS

=head2 new

Overridden to set C<< include_path >> based on the containing kit.

=head2 render

  my $text = $renderer->render($input, $stash, [ $output, %opt ]);

Passes arguments (flattening as necessary) to Template->process.

If C<< $output >> is undef, defaults to returning a string
rather than printing to STDOUT (unlike Template).

=head2 tt

Return the Template object for this renderer, auto-creating it if necessary.

=head2 include_path

  $renderer->include_path->push("/some/dir");

Arrayref accessor.  See L<Template> for details on INCLUDE_PATH.

See L<Object::Array> for details on how to manipulate C<<
include_path >>, if you don't want to just use normal array
access.

By default, the include path is set to the directory the kit
was loaded from.

=cut

sub new {
  my $class = shift;
  my $self  = $class->SUPER::new(@_);
  $self->include_path->push($self->kit->dir);
  return $self;
}

sub render {
  my ($self, $input, $stash, $args) = @_;
  $stash ||= {};
  my ($output, %opt) = @{ $args || [] };
  my $return;
  unless ($output) {
    $output = \$return;
  }
  $self->tt->process(\$input, $stash, $output, %opt)
    or die $self->tt->error, "\n";
  return $return;
}

sub tt {
  my $self = shift;
  return $self->_tt || $self->_tt(Template->new({
    ABSOLUTE => 1,
    RELATIVE => 1,
    INCLUDE_PATH => $self->_include_path_ref,
  }));
}

# we fiddle around with a reference because Template uses
# 'ref' to determine whether or not its INCLUDE_PATH is an
# array, and that breaks with Object::Array
sub include_path {
  my $self = shift;
  return $self->_include_path if $self->_include_path;
  $self->_include_path_ref([]);
  $self->_include_path(
    Object::Array->new($self->_include_path_ref),
  );
}

1;

