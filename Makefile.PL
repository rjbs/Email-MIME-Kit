use inc::Module::Install;

name   'Email-MIME-Kit';
author 'Ricardo SIGNES <rjbs@cpan.org>';
all_from 'lib/Email/MIME/Kit.pm';

test_requires 'Test::More'          => 0;

requires 'Email::MIME::Creator' => 1.455; # content-type fix
requires 'Email::MessageID'     => 1.400; # for the in_brackets method
requires 'JSON' => 2;                     # the new API
requires 'Moose' => 0.65                  # maybe_type
requires 'String::RewritePrefix';

# This is for the YAML manifest reader, which will probably go into its own
# dist later. -- rjbs, 2009-01-22
requires 'YAML::XS';

requires 'File::Basename';  # core! used for picking filename for attachments
requires 'File::Spec';      # core!

test_requires 'Test::Deep';

auto_manifest;

WriteAll;
