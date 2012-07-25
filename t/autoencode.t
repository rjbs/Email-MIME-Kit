use strict;
use warnings;
use utf8;

use Test::More tests => 4;
use lib 't/lib';

use Email::MIME::Kit;

{
  package TestFriend;
  sub new  { bless { name => $_[1] } => $_[0] }
  sub name { return $_[0]->{name} }
}

my $kit = Email::MIME::Kit->new({
  source     => 't/kits/encode.mkit',
});

{
  my $email = $kit->assemble({
    friend   => TestFriend->new('Jimbo Johnson'),
    how_long => '10 years',
  });

  like(
    $email->as_string,
    qr{(?m:^Subject: Hello Jimbo Johnson[\x0d\x0a])},
    "plain ol' strings in the subject with 7-bit friend.name (qr{})",
  );

  like(
    $email->body_raw,
    qr{This goes out to Jimbo Johnson},
    "plain text body",
  );
}

{
  my $email = $kit->assemble({
    friend   => TestFriend->new('Jÿmbo Jºhnsøn'),
    how_long => '10 years',
  });

  like(
    $email->as_string,
    qr{^Subject: =\?UTF-8\?Q\?Hello\S+\?=}m,
    "encoded words in the subject with 8-bit friend.name",
  );

  like(
    $email->body_raw,
    qr{This goes out to J=[0-9A-Fa-f]{2}mbo},
    "q-p encoded body",
  );
}
