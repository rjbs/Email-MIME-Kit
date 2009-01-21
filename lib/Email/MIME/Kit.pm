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

has manifest_reader_class => (
  is          => 'ro',
  default     => '=Email::MIME::Kit::ManifestReader::JSON',
  required    => 1,
  initializer => sub {
    my ($self, $value, $set) = @_;

    $value = String::RewritePrefix->rewrite(
      { '=' => '', '' => 'Email::MIME::Kit::ManifestReader::' },
      $value,
    );

    $set->($value);
  },
);

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

has kit_reader_class => (
  is          => 'ro',
  default     => '=Email::MIME::Kit::KitReader::Dir',
  required    => 1,
  initializer => sub {
    my ($self, $value, $set) = @_;

    $value = String::RewritePrefix->rewrite(
      { '=' => '', '' => 'Email::MIME::Kit::KitReader::' },
      $value,
    );

    $set->($value);
  },
);

has kit_reader => (
  is   => 'ro',
  does => 'Email::MIME::Kit::Role::KitReader',
  required => 1,
  default  => sub {
    my ($self) = @_;
    my $class = $self->kit_reader_class;
    eval "require $class; 1" or die $@;
    $class->new({ kit => $self });
  },
  handles => [ qw(get_kit_entry) ],
);

has validator_class => (
  is          => 'ro',
  lazy        => 1,
  default     => sub { $_[0]->manifest->{validator} },
  initializer => sub {
    my ($self, $value, $set) = @_;
    return unless defined $value;

    $value = String::RewritePrefix->rewrite(
      { '=' => '', '' => 'Email::MIME::Kit::Validator::' },
      $value,
    );

    $set->($value);
  },
);

has validator => (
  is   => 'ro',
  does => 'Email::MIME::Kit::Role::Validator',
  lazy    => 1, # is this really needed? -- rjbs, 2009-01-20
  default => sub {
    my ($self) = @_;
    return unless my $class = $self->validator_class;

    eval "require $class; 1" or die $@;
    $class->new({ kit => $self });
  },
);

sub BUILD {
  my ($self) = @_;

  my $manifest = $self->read_manifest;
  $self->_set_manifest($manifest);

  $self->_setup_default_renderer;
}

sub _setup_default_renderer {
  my ($self) = @_;
  return unless my $renderer_class = $self->manifest->{renderer};

  $renderer_class = String::RewritePrefix->rewrite(
    { '=' => '', '' => 'Email::MIME::Kit::Renderer::' },
    $renderer_class,
  );

  eval "require $renderer_class; 1" or die $@;
  my $renderer = $renderer_class->new({ kit => $self->kit });
  $self->_set_default_renderer($renderer);
}

sub assemble {
  my ($self, $stash) = @_;

  $self->validator->validate($stash) if $self->validator;

  # Do I really need or want to do this?  Anything that alters the stash should
  # do so via localization. -- rjbs, 2009-01-20
  my $copied_stash = { %{ $stash || {} } };

  $self->assembler->assemble($copied_stash);   
}

sub kit { $_[0] }

sub _assembler_from_manifest {
  my ($self, $manifest, $parent) = @_;

  my $assembler_class;

  if ($assembler_class = $manifest->{assembler}) {
    $assembler_class = String::RewritePrefix->rewrite(
      { '=' => '', '' => 'Email::MIME::Kit::Assembler::' },
      $assembler_class,
    );
  } else {
    my $has_body = defined $manifest->{body};
    my $has_path = defined $manifest->{path};
    my $has_alts = @{ $manifest->{alternatives} || [] };
    my $has_att  = @{ $manifest->{attachments}  || [] };

    Carp::croak("neither body, path, nor alternatives provided")
      unless $has_body or $has_path or $has_alts;

    Carp::croak("you must provide only one of body, path, or alternatives")
      unless (grep {$_} $has_body, $has_path, $has_alts) == 1;

    $assembler_class = $has_body ? 'Email::MIME::Kit::Assembler::FromString'
                     : $has_path ? 'Email::MIME::Kit::Assembler::FromFile'
                     : $has_alts ? 'Email::MIME::Kit::Assembler::Alts'
                     :             confess "unreachable code is a mistake";
  }

  eval "require $assembler_class; 1" or die $@;
  return $assembler_class->new({
    kit      => $self->kit,
    manifest => $manifest,
    parent   => $parent,
  });
}

has default_renderer => (
  reader => 'default_renderer',
  writer => '_set_default_renderer',
  does   => 'Email::MIME::Kit::Role::Renderer',
);

has assembler => (
  reader    => 'assembler',
  does      => 'Email::MIME::Kit::Role::Assembler',
  required  => 1,
  lazy      => 1,
  default   => sub {
    my ($self) = @_;
    return $self->_assembler_from_manifest($self->manifest);
  }
);

1;
