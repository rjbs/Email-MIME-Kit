package Email::MIME::Kit::ManifestReader::JSON;
use Moose;

with 'Email::MIME::Kit::Role::ManifestReader';
with 'Email::MIME::Kit::Role::ManifestDesugarer';

our $VERSION = '0.001';

=head1 NAME

Email::MIME::Kit::ManifestReader::JSON - read manifest.json files

=cut

use JSON;

sub read_manifest {
  my ($self) = @_;

  my $json_ref = $self->kit->kit_reader->get_kit_entry('manifest.json');

  my $content = JSON->new->decode($$json_ref);
}

no Moose;
1;
