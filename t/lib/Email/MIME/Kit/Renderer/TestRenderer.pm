package Email::MIME::Kit::Renderer::TestRenderer;
use Moose;

with 'Email::MIME::Kit::Role::Renderer';

sub render {
  my ($self, $content_ref, $stash) = @_;

  my $output = $$content_ref;
  for my $key (%$stash) {
    $$content_ref =~ s<[%\s+\Q$key\E\s+%]>[$stash->{$key}]g;
  }

  return \$output;
}

no Moose;
1;
