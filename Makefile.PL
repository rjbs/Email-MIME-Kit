use inc::Module::Install;

name   'Email-MIME-Kit';
author 'Ricardo SIGNES <rjbs@cpan.org>';
all_from 'lib/Email/MIME/Kit.pm';

test_requires 'Test::More'          => 0;

requires 'JSON' => 2; # the new API
requires 'Email::MIME::Creator' => 1.455; # content-type fix

auto_manifest;

WriteAll;
