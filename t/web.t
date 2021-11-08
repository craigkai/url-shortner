use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new(url_shortner => {test_mode => 1});
my $test_url = $t->ua->server->url->to_string;

# Add a test route for us to redirect to:
$t->app->hook(before_dispatch => sub {
  my $c = shift;
  $c->render(json => {text => 'bark'}) if $c->req->url->path->contains('/dogs');
});

$t->get_ok('/')->status_is(200)->content_like(qr/Enter a URL to be shortened!/i);

# Lets create a new URL entry, we expect to see a valid link generated
$t->post_ok('/' => form => {newURL => $test_url."dogs"})
  ->status_is(200)
  ->content_like(qr{$test_url(.+)}i);

# Allow a redirect
$t->ua->max_redirects(10);

# Lets follow our new URL:
my $reditect_url = $t->tx->res->dom->at('input#newURL')->val;
$t->get_ok($reditect_url)->status_is(200)
  ->content_like(qr/bark/i);
# Confirm our content ^ is from the redirect URL

done_testing();
