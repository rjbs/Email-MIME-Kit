package Email::MIME::Kit::BundleReader::Dir;
use Moose;
with 'Email::MIME::Kit::Role::BundleReader';

use File::Spec;

has dir => (is => 'ro', required => 1);

sub BUILDARGS {
  my ($self, @args) = @_;
  return $self->SUPER::BUILDARGS(@args)
    unless (@args == 1 and ! ref $args[0])
        or (@args == 1 and ! ref $args[0] and ref $args[1] eq 'HASH');

  return { %{ $args[1] }, dir => $args[0] };
}

sub read_bundle {
  my ($class, $dir) = @_;
  $class->new({ dir => $dir });
}

# cache sometimes
sub get_bundle_entry {
  my ($self, $path) = @_;
  
  my $fullpath = File::Spec->catfile($self->dir, $path);

  open my $fh, '<', $fullpath or die "can't open $fullpath for reading: $!";
  my $content = do { local $/; <$fh> };

  return \$content;
}

1;
