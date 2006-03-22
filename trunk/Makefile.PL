use strict;
use warnings;

use inc::Module::Install;

name   'Email-MIME-Kit';
author 'Hans Dieter Pearcey <hdp@cpan.org>';
all_from;

build_requires 'Test::More'          => 0;

requires 'Params::Validate'          => '0.74';
requires 'YAML::Syck'                => '0.33';
requires 'Module::Pluggable'         => '2.96';
requires 'Template'                  => 0;
requires 'Class::Accessor::Fast'     => 0;
requires 'Class::Data::Inheritable'  => 0;
requires 'Scalar::Util'              => 0;
requires 'Email::MIME::Creator'      => 0;
requires 'File::Spec'                => 0;
requires 'Object::Array'             => 0;

install_script 'bin/mkit';

auto_install;

WriteAll;
