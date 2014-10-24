package Limper::SendJSON;
$Limper::SendJSON::VERSION = '0.002';
use base 'Limper';
use 5.10.0;
use strict;
use warnings;

package Limper;
$Limper::VERSION = '0.002';
use JSON::MaybeXS;
use Try::Tiny;

push @Limper::EXPORT, qw/send_json/;

sub send_json {
    my ($data, @options) = @_;
    my @headers = headers;
    headers 'Content-Type' => 'application/json', headers unless grep { $_ eq 'Content-Type' } keys %{{&headers}};
    try {
        JSON::MaybeXS->new(@options)->encode($data);
    } catch {
        warning $_;
        headers @headers;
        status 500;
        'Internal Server Error';
    };
}

1;

=for Pod::Coverage

=head1 NAME

Limper::SendJSON - adds a send_json function to Limper

=head1 VERSION

version 0.002

=head1 SYNOPSIS

  use Limper::SendJSON;
  use Limper;   # this must come after all extensions

  # some other routes

  get '/json' = sub {
      send_json { foo => 'bar' };
  };

  get '/json-pretty' = sub {
      send_json { foo => 'bar' }, pretty => 1;
  };

  limp;

=head1 DESCRIPTION

B<Limper::SendJSON> extends L<Limper> to easily return JSON, with the proper Content-Type header.

=head1 EXPORTS

The following are all additionally exported by default:

  send_json

=head1 FUNCTIONS

=head2 send_json

Sends the B<HASH> or B<ARRAY> given as JSON. If B<Content-Type> is not
already set, it will be set to B<application/json>.  Returns B<500> if the
scalar cannot be encoded by L<JSON::MaybeXS>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Ashley Willis E<lt>ashley+perl@gitable.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=head1 SEE ALSO

L<Limper>

L<Limper::Engine::PSGI>

L<Limper::SendFile>

=cut
