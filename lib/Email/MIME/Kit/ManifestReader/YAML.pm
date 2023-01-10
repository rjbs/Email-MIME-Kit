package Email::MIME::Kit::ManifestReader::YAML;
# ABSTRACT: read manifest.yaml files

use v5.20.0;
use Moose;

with 'Email::MIME::Kit::Role::ManifestReader',
     'Email::MIME::Kit::Role::ManifestDesugarer';

use YAML::XS ();

sub read_manifest {
  my ($self) = @_;

  my $yaml_ref = $self->kit->kit_reader->get_kit_entry('manifest.yaml');

  # YAML::XS is documented as expecting UTF-8 bytes, which we give it.
  my ($content) = YAML::XS::Load($$yaml_ref);

  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
