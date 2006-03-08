package Email::MIME::Kit::Plugin::Header::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Plugin::Header);

use Email::MIME::Kit::Renderer::TT;

__PACKAGE__->renderer('Email::MIME::Kit::Renderer::TT');

1;
