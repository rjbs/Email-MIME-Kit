#!perl 

use strict;
use warnings;

my @modules;
BEGIN {
  @modules = qw(
                   Email::MIME::Kit::Component
                   Email::MIME::Kit::Component::Data
                   Email::MIME::Kit::Renderer
                   Email::MIME::Kit::Renderer::Plain
                   Email::MIME::Kit::Renderer::TT
                   Email::MIME::Kit::Header
                   Email::MIME::Kit::Header::TT
                   Email::MIME::Kit::Part
                   Email::MIME::Kit::Part::File
                   Email::MIME::Kit::Part::TT
                   Email::MIME::Kit::Part::File::TT
                   Email::MIME::Kit
                 );
}

use Test::More tests => scalar @modules;

BEGIN {
  for my $m (@modules) {
    use_ok($m);
  }
}

diag( "Testing Email::MIME::Kit $Email::MIME::Kit::VERSION, Perl $], $^X" );
