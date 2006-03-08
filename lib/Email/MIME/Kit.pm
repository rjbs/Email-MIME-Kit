package Email::MIME::Kit;

use warnings;
use strict;
require 5.006001;

use base qw(Class::Data::Inheritable);

use Params::Validate ();
use YAML::Syck ();
use Scalar::Util ();

use Email::MIME::Creator;

use Module::Pluggable (require => 1);

sub _slurp {
  my $file = shift;
  my $fh;
  unless (open $fh, "<", $file) {
    my $err = $!;
    require Carp;
    Carp::croak("can't open $file for reading: $err");
  }
  local $/;
  return <$fh>;
}

__PACKAGE__->mk_classdata('kit_part_class');
__PACKAGE__->kit_part_class(__PACKAGE__ . "::Plugin::Part");
__PACKAGE__->plugins;

=head1 NAME

Email::MIME::Kit - build MIME messages using pre-fab parts

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

  use Email::MIME::Kit;

  my $kit = Email::MIME::Kit->new("./foo.kit", \%arg);
  print $kit->assemble({ name => "John Smith" })->as_string;

=head1 DESCRIPTION

Email::MIME::Kit makes it easy to assemble MIME messages
from separate template files, include images, and generally
separate your data from your code, while retaining a good
deal of flexibility.

=head1 CONFIGURATION

A kit is a directory (given a suffix of ".kit" by
convention).  Inside this directory are all the contents of
the kit (html, text, images, and so on), as well as the kit
YAML configuration file, C<< message.yml >>.

The message file is a mapping with two top-level mappings.

=head1 MESSAGE VALIDATION

  validate:
    object: { isa: "My::Object" }

This mapping (hashref) is used as a Params::Validate spec for all calls to C<< assemble >>.

=head1 MESSAGE CONTENT

  message:
    header:  ...
    content: ...

=head2 C<< header >>

=head2 C<< content >>

=head2 C<< parts >>

=head2 C<< body >>

=head2 tags

=head1 METHODS

=head2 C<< new >>

  my $kit = Email::MIME::Kit->new($dir, \%opt);

Create a new kit from the files inside the given directory,
with optional extra behavior specified by the given hashref.

=cut

sub new {
  my ($class, $dir, $opt) = @_;
  my $self = $class->load($dir, $opt);
  $self->normalize;
  $self->validate;
  return $self;
}

=head2 C<< load >>

=cut

sub load {
  my ($class, $dir, $opt) = @_;
  -e "$dir/message.yml" or die "no $dir/message.yml";
  my $self =  bless YAML::Syck::Load(
    _slurp("$dir/message.yml"),
  ) => $class;
  $self->{root} = $dir;
  return $self;
}

=head2 C<< normalize >>

=cut

sub normalize {
  my $self = shift;
  for my $key (keys %{$self->{validate}}) {
    my $type = $self->{validate}->{$key}->{type} || next;
    no strict 'refs';
    $self->{validate}->{$key}->{type} = &{"Params::Validate::$type"};
  }
  $self->{message}->{root} = $self->{root};
  $self->{message} = $self->kit_part_class->new($self->{message});
}

=head2 C<< validate >>

=cut

sub validate {
}

=head2 C<< assemble >>

  my $message = $kit->assemble(\%arg);

Process all templates (using the given argument as the
stash) and create an Email::MIME object from the parts.

=cut

sub assemble {
  my ($self, $stash) = @_;
  return $self->{message}->assemble($stash);
}

=head1 AUTHOR

Hans Dieter Pearcey, C<< <hdp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-email-mime-kit at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Email-MIME-Kit>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Email::MIME::Kit

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Email-MIME-Kit>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Email-MIME-Kit>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Email-MIME-Kit>

=item * Search CPAN

L<http://search.cpan.org/dist/Email-MIME-Kit>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Hans Dieter Pearcey, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Email::MIME::Kit
