package Email::MIME::Kit::ManifestReader::YAML;
# ABSTRACT: read manifest.yaml files

use Moose;

with 'Email::MIME::Kit::Role::ManifestReader';
with 'Email::MIME::Kit::Role::ManifestDesugarer';

use YAML::XS ();

sub read_manifest {
  my ($self) = @_;

  my $yaml_ref = $self->kit->kit_reader->get_kit_entry('manifest.yaml');

  # YAML::XS is documented as expecting UTF-8 bytes, which we give it.
  my ($content) = YAML::XS::Load($$yaml_ref);

  return $content;
}

no Moose;
1;
