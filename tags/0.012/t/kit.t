#!perl

use strict;
use warnings;

use Test::More tests => 11;
use Email::MIME::Kit;

my $kit = Email::MIME::Kit->new("./t/test.kit");
isa_ok($kit, "Email::MIME::Kit");

Email::MIME::Kit->kit_load_path("./t");
$kit = Email::MIME::Kit->new('test.kit');
isa_ok($kit, "Email::MIME::Kit");

eval {
  $kit->assemble;
};
like($@, qr/mandatory parameter 'friend'/i, "assemble error: required param");

eval {
  $kit->assemble({ friend => { name => "foo" }, enemy => "bar" });
};
like($@, qr/not listed.+: enemy/, "assemble error: unwanted param");

eval {
  $kit->assemble({ friend => { name => 'foo' }});
};
like($@, qr/friendname: not found/, "can't find file");

$kit->renderer('TT')->include_path->push('./t/test.kit/extra');

my $mime = eval {
  $kit->assemble({ friend => { name => "foo" } });
};
is($@, "", "no assemble error");
isa_ok($mime, "Email::MIME");

like($mime->content_type, qr!^multipart/mixed;!);
my @parts = $mime->parts;
is(
  @parts, 2,
  "mime has two parts",
);

is($mime->header('Subject'), "Hello foo", "mime has TT-rendered subject");

like(
  ($parts[0]->parts)[1]->body,
  qr{<body>\nHello, foo!\n</body>},
  "deep mime file part has TT-rendered content",
);
