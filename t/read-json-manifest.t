use strict;
use warnings;

use Test::More 'no_plan';
use lib 't/lib';

use Email::MIME::Kit;

my $kit = Email::MIME::Kit->new({ source => 't/test.mkit' });

my $manifest = $kit->manifest;
ok($manifest, 'got a manifest');

