#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Email::MIME::Kit' );
}

diag( "Testing Email::MIME::Kit $Email::MIME::Kit::VERSION, Perl $], $^X" );
