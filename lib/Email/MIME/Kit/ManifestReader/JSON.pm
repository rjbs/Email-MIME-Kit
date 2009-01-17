package Email::MIME::Kit::ManifestReader::JSON;
use Moose;

with 'Email::MIME::Kit::Role::ManifestReader';
with 'Email::MIME::Kit::Role::ManifestDesugarer';

use JSON;

sub read_manifest {
  my ($self) = @_;

  my $json_ref = $self->kit->bundle_reader->get_bundle_entry('manifest.json');

  my $content = JSON->new->decode($$json_ref);
}

no Moose;
1;
