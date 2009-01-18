package Email::MIME::Kit;
use Moose;

use Data::GUID ();

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
  handles => [ qw(read_manifest) ],
);

has manifest => (reader => 'manifest', writer => '_set_manifest');

sub kit_reader_class { 'Email::MIME::Kit::KitReader::Dir' }

has kit_reader => (
  is   => 'ro',
  does => 'Email::MIME::Kit::Role::KitReader',
  required => 1,
  default  => sub {
    my ($self) = @_;
    my $class = $self->kit_reader_class;
    eval "require $class; 1" or die $@;
    $class->new($self->source, { kit => $self });
  },
  handles => [ qw(get_kit_entry) ],
);

has _cid_registry => (
  is       => 'ro',
  init_arg => undef,
  default  => sub { { } },
);

sub BUILD {
  my ($self) = @_;

  my $manifest = $self->read_manifest;
  $self->_set_manifest($manifest);

  $self->_setup_content_ids;
}

sub _setup_content_ids {
  my ($self) = @_;

  for my $att (@{ $self->manifest->{attachments} || [] }) {
    next unless $att->{path};

    for my $header (@{ $att->{header} }) {
      my ($header) = grep { /^[^:]/ } keys %$header;
      Carp::croak("attachments must not supply content-id")
        if lc $header eq 'content-id';
    }

    my $guid = Data::GUID->new->as_string;
    push @{ $att->{header} }, {
      'Content-Id' => $guid,
      ':renderer'  => undef,
    };

    $self->_cid_registry->{ $att->{path} } = $guid;
  }
}

1;
