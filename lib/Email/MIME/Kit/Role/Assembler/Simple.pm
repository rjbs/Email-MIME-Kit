package Email::MIME::Kit::Role::Assembler::Simple;
use Moose::Role;

with 'Email::MIME::Kit::Role::Assembler';

use Data::GUID;

sub BUILD {
  my ($self, $ARG) = @_;
  $self->_setup_content_ids;
  $self->_pick_renderer($ARG);
  $self->_build_subassemblies;
}

has parent => (
  is   => 'ro',
  does => 'Maybe[Email::MIME::Kit::Role::Assembler]',
);

has renderer => (
  reader   => 'renderer',
  writer   => '_set_renderer',
  clearer  => '_unset_renderer',
  does     => 'Email::MIME::Kit::Renderer',
  init_arg => undef,
);

sub _pick_renderer {
  my ($self, $ARG) = @_;

  my $renderer = $self->kit->default_renderer;
  
  # We check ->parent because we do not want to re-set the renderer on
  # the top-level assembler. -- rjbs, 2009-01-19
  if (exists $self->manifest->{renderer} and $self->parent) {
    if (! defined $self->manifest->{renderer}) {
      # Allow an explicit undef to mean "no rendering is to be done." -- rjbs,
      # 2009-01-19
      return;
    }

    my $renderer_class = String::RewritePrefix->rewrite(
      { '=' => '', '' => 'Email::MIME::Kit::Renderer::' },
      $self->manifest->{renderer},
    );

    eval "require $renderer_class; 1" or die $@;
    $renderer = $renderer_class->new({ kit => $self->kit });
  }

  $self->_set_renderer($renderer);
}

has manifest => (
  is       => 'ro',
  required => 1,
);

has [ qw(_attachments _alternatives) ] => (
  is  => 'ro',
  isa => 'ArrayRef',
  init_arg   => undef,
  default    => sub { [] },
  auto_deref => 1,
);

has _body => (
  reader => 'body',
  writer => '_set_body',
);

sub _build_subassemblies {
  my ($self) = @_;
  
  if (my $body = $self->manifest->{body}) {
    $self->_set_body($body);
  }

  for my $attach (@{ $self->manifest->{attachments} || [] }) {
    push @{ $self->_attachments },
      $self->kit->_assembler_from_manifest($attach, $self);
  }

  for my $alt (@{ $self->manifest->{alternatives} || [] }) {
    push @{ $self->_alternatives },
      $self->kit->_assembler_from_manifest($alt, $self);
  }
}

has renderer => (
  reader => 'renderer',
  writer => '_set_renderer',
  does   => 'Email::MIME::Kit::Role::Renderer',
);

sub render {
  my ($self, $input_ref, $stash) = @_;
  return $input_ref unless my $renderer = $self->renderer;
  return $renderer->render($input_ref, $stash);
}

sub _prep_header {
  my ($self, $header, $stash) = @_;

  my @done_header;
  for my $entry (@$header) {
    confess "no field name candidates"
      unless my (@hval) = grep { /^[^:]/ } keys %$entry;
    confess "multiple field name candidates: @hval" if @hval > 1;
    my $value = $entry->{ $hval[ 0 ] };

    if (ref $value) {
      my ($v, $p) = @$value;
      $value = join q{; }, $v, map { "$_=$p->{$_}" } keys %$p;
    } else {
      # XXX: respect the ":renderer" entry -- rjbs, 2009-01-19
      $value = ${ $self->render(\$value, $stash) };
    }

    push @done_header, $hval[0] => $value;
  }

  return \@done_header;
}

has _cid_registry => (
  is       => 'ro',
  init_arg => undef,
  default  => sub { { } },
);

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

no Moose::Role;
1;
