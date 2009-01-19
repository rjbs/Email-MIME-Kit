use strict;
use warnings;

use Test::More 'no_plan';

use Email::MIME::Kit;

my $kit = Email::MIME::Kit->new({ source => 't/test.mkit' });

my $manifest = $kit->manifest;
ok($manifest, 'got a manifest');

{
  package TestFriend;
  sub new  { bless { name => $_[1] } => $_[0] }
  sub name { return $_[0]->{name} }
}

my $output = $kit->assemble({
  friend   => TestFriend->new('Jimbo Johnson'),
  how_long => '10 years',
});


