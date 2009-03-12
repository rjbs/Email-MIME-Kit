package Email::MIME::Kit::KitReader::Dir;
use Moose;
with 'Email::MIME::Kit::Role::KitReader';

our $VERSION = '2.003';

=head1 NAME

Email::MIME::Kit::KitReader::Dir - read kit entries out of a directory

=cut

use File::Spec;

# cache sometimes
sub get_kit_entry {
  my ($self, $path) = @_;
  
  my $fullpath = File::Spec->catfile($self->kit->source, $path);

  open my $fh, '<', $fullpath or die "can't open $fullpath for reading: $!";
  my $content = do { local $/; <$fh> };

  return \$content;
}

1;
