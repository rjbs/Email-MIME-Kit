package Email::MIME::Kit::Role::ManifestDesugarer;
# ABSTRACT: helper for desugaring manifests

use v5.20.0;
use Moose::Role;

=head1 IMPLEMENTING

This role also performs L<Email::MIME::Kit::Role::Component>.

This is a role more likely to be consumed than implemented.  It wraps C<around>
the C<read_manifest> method in the consuming class, and "desugars" the contents
of the loaded manifest before returning it.

At present, desugaring is what allows the C<type> attribute in attachments and
alternatives to be given instead of a C<content_type> entry in the
C<attributes> entry.  In other words, desugaring turns:

  {
    header => [ ... ],
    type   => 'text/plain',
  }

Into:

  {
    header => [ ... ],
    attributes => { content_type => 'text/plain' },
  }

More behavior may be added to the desugarer later.

=cut

my $ct_desugar;
$ct_desugar = sub {
  my ($self, $content) = @_;

  for my $thing (qw(alternatives attachments)) {
    for my $part (@{ $content->{ $thing } }) {
      my $headers = $part->{header} ||= [];
      if (my $type = delete $part->{type}) {
        confess "specified both type and content_type attribute"
          if $part->{attributes}{content_type};

        $part->{attributes}{content_type} = $type;
      }

      $self->$ct_desugar($part);
    }
  }
};

around read_manifest => sub {
  my ($orig, $self, @args) = @_;
  my $content = $self->$orig(@args);

  $self->$ct_desugar($content);

  return $content;
};

no Moose::Role;
1;
