use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use url_shortner::Model::URL;

my $t = Test::Mojo->new(url_shortner => {test_mode => 1});

my $test_url = $t->ua->server->url->to_string;

diag "Testing URL methods";
{
  my $url = url_shortner::Model::URL->new();
  my $short_url = $url->GenerateShortenedURL($test_url."dogs");
}
ok(1);
done_testing();