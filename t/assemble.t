use strict;
use warnings;

use Test::More tests => 42;
use lib 't/lib';

use Email::MIME::Kit;

# because there's no E:M method for this... ugh! -- rjbs, 2009-01-22
my $bare_ct = sub { shift->content_type =~ /\A(.+?)(?:;|\z)/; $1 };

{
  package TestFriend;
  sub new  { bless { name => $_[1] } => $_[0] }
  sub name { return $_[0]->{name} }
}

for my $args (
  [ yaml => [ manifest_reader_class => 'YAML' ] ],
  [ none => [ ] ],
) {
  pass("NOW BEGINNING TO TEST WITH FOLLOWING ARG SET: $args->[0]");
  my $kit = Email::MIME::Kit->new({
    @{ $args->[1] },
    source => 't/test.mkit'
  });

  my $manifest = $kit->manifest;
  ok($manifest, 'got a manifest');

  my $email = $kit->assemble({
    friend   => TestFriend->new('Jimbo Johnson'),
    how_long => '10 years',
  });

  isa_ok($email, 'Email::MIME', 'product of kit assembly');
  is($email->header('Subject'), 'Hello Jimbo Johnson', 'subject was rendered');

  ok(
    (defined scalar $email->header('Message-Id')),
    "we have a message-id on the top level",
  );

  like(
    $email->header('X-Test'),
    qr{\Qunrendered [% friend %] test},
    'we can override header rendering per-header',
  );
  is($email->$bare_ct, 'multipart/mixed', "alts + parts = multipart/mixed");
  my ($mp_alt, $pdf, @top_rest) = $email->subparts;

  is(@top_rest, 0, "we got exactly 2 top-level parts");
  is($mp_alt->$bare_ct, 'multipart/alternative', 'first subpart is mp/a');
  is($pdf->$bare_ct, 'application/pdf', '2nd subpart is application/pdf');

  {
    my ($txt, $html, $mp_rel, @alt_rest) = $mp_alt->subparts;

    is(@alt_rest, 0, "we got exactly 3 subparts of the mp/a part");
    is($txt->$bare_ct,    'text/plain',        'first subsubpart is t/plain');
    is($html->$bare_ct,   'text/html',         '2nd subsubpart is t/html');
    is($mp_rel->$bare_ct, 'multipart/related', '3nd subsubpart is mp/rel');

    like(
      $html->body,
      qr{\Qthe unrendered [% friend %] HTML part},
      "per-part renderer override works",
    );

    like(
      $html->header('x-cantata'),
      qr{\Q[% friend %] canta},
      "per-part renderer override also affects the assembler's hdr render",
    );


    {
      my ($better_html, $jpeg, @rel_rest) = $mp_rel->subparts;

      is(@rel_rest, 0, "we got exactly 2 subparts of the mp/rel part");
      is($better_html->$bare_ct, 'text/html',  'mp/rel subpart 1 = t/html');
      is($jpeg->$bare_ct,        'image/jpeg', 'mp/rel subpart 2 = i/jpeg');

      like(
        $better_html->body,
        qr{Hello, Jimbo Johnson.  It's},
        "html body rendered",
      );

      my ($cid) = $better_html->body =~ m/src='cid:(.+?)'/;
      is(
        $cid,
        $jpeg->header('content-id'),
        "the html body references the jpeg's content id",
      );
    }
  }
}
