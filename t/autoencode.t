use strict;
use warnings;
use utf8;

use Test::More tests => 6;
use lib 't/lib';

use Encode qw(decode_utf8);
use Email::MIME::Kit;

{
  package TestFriend;
  sub new  { bless { name => $_[1] } => $_[0] }
  sub name { return $_[0]->{name} }
}

{
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
      qr{(?m:^Subject: Hello Jimbo Johnson$)},
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
      "encoded words in the subject with Unicode friend.name",
    );

    like(
      $email->body_raw,
      qr{This goes out to J=C3=BFmbo}, # \xCF\xBF == U+00FF, ÿ
      "q-p encoded body",
    );

    like(
      $email->body_str,
      qr{This goes out to Jÿmbo},
      "...and it reverses properly...",
    );
  }
}

{
  my $kit = Email::MIME::Kit->new({
    source     => 't/kits/encode-tm.mkit',
  });

  my $email = $kit->assemble;

  my $subj = $email->header('Subject');
  my $str  = decode_utf8($subj);

  is($str, "Thing™", "our UTF-8 manifest's subject round-tripped");
  # sdiag $email->header('Subject');
  # as_string;
}
