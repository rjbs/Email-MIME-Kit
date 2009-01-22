package Email::MIME::Kit::Role::ManifestDesugarer;
use Moose::Role;

our $VERSION = '0.001';

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
