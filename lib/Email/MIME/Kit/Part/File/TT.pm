package Email::MIME::Kit::Part::File::TT;

use strict;
use warnings;

use base qw(Email::MIME::Kit::Part::File);

use Email::MIME::Kit::Renderer::TT;
__PACKAGE__->renderer('Email::MIME::Kit::Renderer::TT');

1;
