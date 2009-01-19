package Email::MIME::Kit::Renderer::TestRenderer;
use Moose;

with 'Email::MIME::Kit::Role::Renderer';

sub render {
  my ($self, $content_ref, $stash) = @_;

  my $output = $$content_ref;
  for my $key (sort %$stash) {
    $output =~
      s<\[%\s+\Q$key\E(?:(?:\.(\w+))?\((.*?)\))?\s+%\]>
      [ defined $2
        ? ($1 ? $stash->{$key}->$1(eval $2) : $stash->{$key}->(eval $2))
        : $stash->{$key}
      ]ge;
  }

  return \$output;
}

no Moose;
1;
