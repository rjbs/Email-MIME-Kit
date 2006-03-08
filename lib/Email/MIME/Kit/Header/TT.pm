package Email::MIME::Kit::Header::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Header);

use Email::MIME::Kit::Renderer::TT;

__PACKAGE__->renderer('Email::MIME::Kit::Renderer::TT');

1;
