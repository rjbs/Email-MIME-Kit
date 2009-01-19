package Email::MIME::Kit;
use Moose;
use Moose::Autobox;

use Data::GUID ();
use Email::MIME;
use String::RewritePrefix;

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

  $self->_choose_assembler;
  # $self->_setup_default_renderer;
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

sub assemble {
  my ($self) = @_;
  my $stash = { %{ $_[1] || {} } };

  my @alternatives = $self->manifest->{alteratives}->flatten;
  if (@alternatives == 1) {
    return $self->_assemble_singlepart($stash);
  } else {
    return $self->_assemble_multipart_alternatives($stash);
  }
}

## Thoughts on how to pick a type:
# 
# body | alts | attach | result
#      |      |        | throw
#      |      |   X    | throw
#      |   X  |        | alternative
#      |   X  |   X    | mixed(alternative, ...)
#   X  |      |        | single part
#   X  |      |   X    | mixed(body type, ...)
#   X  |   X  |        | throw
#   X  |   X  |   X    | throw

sub _choose_assembler {
  my ($self) = @_;
  return if $self->_has_assembler;

  my $assembler_class;

  if ($assembler_class = $self->manifest->{assembler}) {
    $assembler_class = String::RewritePrefix->rewrite(
      { '=' => '', '' => 'Email::MIME::Kit::Assembler::' },
      $assembler_class,
    );
  } else {
    my $has_body = defined $self->manifest->{body};
    my $has_alts = @{$self->manifest->{alternatives} || []};
    my $has_att  = @{$self->manifest->{attachments} || []};

    Carp::croak("neither body nor alternatives provided")
      unless $has_body or $has_alts;

    Carp::croak("you must provide only body or alternatives, not both")
      if $has_body and $has_alts;

    $assembler_class = 'Email::MIME::Kit::Assembler::Simple';
  }

  eval "require $assembler_class; 1" or die $@;
  return $assembler_class->new({ kit => $self });
}

has assembler => (
  reader    => 'assembler',
  writer    => '_set_assembler',
  predicate => '_has_assembler',
  does      => 'Email::MIME::Kit::Role::Assembler',
  required  => 1,
  lazy      => 1,
  default   => sub { confess "no assembler supplied or guessable" },
);

sub _assemble_multipart_alternatives {
  my ($self, $stash) = @_;
  
  my @alt_parts;
  for my $alt ($self->manifest->{alternatives}->flatten) {
    push @alt_parts, Email::MIME->new(
      header => 
    );
  }
}

1;
