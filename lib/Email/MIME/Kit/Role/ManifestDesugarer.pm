package Email::MIME::Kit::Role::ManifestDesugarer;
use Moose::Role;

around read_manifest => sub {
  my ($orig, $self, @args) = @_;
  my $content = $self->$orig(@args);

  for my $thing (qw(alternatives attachments)) {
    for my $part (@{ $content->{ $thing } }) {
      my $headers = $part->{header} ||= [];
      if (my $type = delete $part->{type}) {
        push @$headers, { 'Content-Type' => $type };
      }
    }
  }

  return $content;
};

no Moose::Role;
1;
