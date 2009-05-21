package Email::MIME::Kit::ManifestReader::YAML;
use Moose;
# ABSTRACT: read manifest.yaml files

with 'Email::MIME::Kit::Role::ManifestReader';
with 'Email::MIME::Kit::Role::ManifestDesugarer';

use YAML::XS ();

sub read_manifest {
  my ($self) = @_;

  my $yaml_ref = $self->kit->kit_reader->get_kit_entry('manifest.yaml');

  my ($content) = YAML::XS::Load($$yaml_ref);

  return $content;
}

no Moose;
1;
