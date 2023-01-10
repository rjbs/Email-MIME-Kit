package Email::MIME::Kit::ManifestReader::JSON;
# ABSTRACT: read manifest.json files

use v5.20.0;
use Moose;

with 'Email::MIME::Kit::Role::ManifestReader';
with 'Email::MIME::Kit::Role::ManifestDesugarer';

use JSON 2;

sub read_manifest {
  my ($self) = @_;

  my $json_ref = $self->kit->kit_reader->get_kit_entry('manifest.json');

  my $content = JSON->new->utf8->decode($$json_ref);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
