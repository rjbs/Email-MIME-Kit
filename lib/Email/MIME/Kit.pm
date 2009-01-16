package Email::MIME::Kit;
use Moose;

=head1 NAME

Email::MIME::Kit - build messages from templates

=cut

has source => (is => 'ro', required => 1);

sub manifest_reader_class { 'Email::MIME::Kit::ManifestReader::JSON' }

has manifest_reader => (
  is   => 'ro',
  does => 'Email::MIME::Kit::Role::ManifestReader',
  required => 1,
  default  => sub {
    my $class = $_[0]->manifest_reader_class;
    eval "require $class; 1" or die $@;
    $class->new({ kit => $_[0] });
  },
);

sub bundle_reader_class { 'Email::MIME::Kit::BundleReader::Dir' }

has bundle_reader => (
  is   => 'ro',
  does => 'Email::MIME::Kit::Role::BundleReader',
  required => 1,
  default  => sub {
    my $class = $_[0]->bundle_reader_class;
    eval "require $class; 1" or die $@;
    $class->new($self->source, { kit => $_[0] });
  },
);

1;
