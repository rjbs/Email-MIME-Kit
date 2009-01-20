package Email::MIME::Kit::Role::ManifestDesugarer;
use Moose::Role;

around read_manifest => sub {
  my ($orig, $self, @args) = @_;
  my $content = $self->$orig(@args);

  for my $thing (qw(alternatives attachments)) {
    for my $part (@{ $content->{ $thing } }) {
      my $headers = $part->{header} ||= [];
      if (my $type = delete $part->{type}) {
        confess "specified both type and content_type attribute"
          if $part->{attributes}{content_type};

        $part->{attributes}{content_type} = $type;
      }
    }
  }

  return $content;
};

no Moose::Role;
1;
