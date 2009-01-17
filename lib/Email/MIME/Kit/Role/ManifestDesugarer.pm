package Email::MIME::Kit::Role::ManifestDesugarer;
use Moose::Role;

around read_manifest => sub {
  my ($orig, $self, @args) = @_;
  my $content = $self->$orig(@args);
  print ">> desugaring manifest <<\n";
};

no Moose::Role;
1;
