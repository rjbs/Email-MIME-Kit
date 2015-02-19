package Email::MIME::Kit::ManifestReader::JSON;
# ABSTRACT: read manifest.json files

use Moose;

with 'Email::MIME::Kit::Role::ManifestReader';
with 'Email::MIME::Kit::Role::ManifestDesugarer';

use JSON;

sub read_manifest {
  my ($self) = @_;

  my $json_ref = $self->kit->kit_reader->get_kit_entry('manifest.json');

  # We do not touch ->utf8 because we're reading the octets, and not decoding
  # them. -- rjbs, 2014-11-20
  my $content = JSON->new->decode($$json_ref);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
