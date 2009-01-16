use strict;
use warnings;

use Test::More 'no_plan';

use Email::MIME::Kit;

my $kit = Email::MIME::Kit->new({ source => 't/test.mkit' });

