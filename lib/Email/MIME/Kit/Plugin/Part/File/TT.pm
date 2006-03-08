package Email::MIME::Kit::Plugin::Part::File::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Plugin::Part::File);

use Email::MIME::Kit::Renderer::TT;
__PACKAGE__->renderer('Email::MIME::Kit::Renderer::TT');

1;
