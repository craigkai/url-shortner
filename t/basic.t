use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('url_shortner');
$t->get_ok('/')->status_is(200)->content_like(qr/Welcome to Craigs URL Shortner!/i);



done_testing();
