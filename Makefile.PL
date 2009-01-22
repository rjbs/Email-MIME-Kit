use inc::Module::Install;

name   'Email-MIME-Kit';
author 'Ricardo SIGNES <rjbs@cpan.org>';
all_from 'lib/Email/MIME/Kit.pm';

test_requires 'Test::More'          => 0;

requires 'Data::GUID';                    # used to set content-ids as needed
requires 'Email::MIME::Creator' => 1.455; # content-type fix
requires 'JSON' => 2;                     # the new API
requires 'Moose' => 0.65                  # maybe_type
requires 'String::RewritePrefix';

# This is for the YAML manifest reader, which will probably go into its own
# dist later. -- rjbs, 2009-01-22
requires 'YAML::XS';

requires 'File::Basename';  # core! used for picking filename for attachments
requires 'File::Spec';      # core!

auto_manifest;

WriteAll;
