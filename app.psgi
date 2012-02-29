use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Amon2::Lite;
use Cwd;
use URI::Escape;
use Plack::Builder;

our $VERSION = '0.01';

my $current_dir = Cwd::getcwd();

sub load_config {
    my $c = shift;
    my $mode = $c->mode_name || 'development';
}

get '/' => sub {
    my $c = shift;

    my @files = map { glob $_ } ('*.jpg', '*.jpeg', '*.png', '*.gif');

    return $c->render('index.tt', {
        dir_path => Cwd::getcwd(),
        files    => [map { uri_escape($_) } @files],
    });
};

builder {
    enable "Plack::Middleware::Static",
        path => qr{^/.+\.(png|jpe?g|gif)$}, root => Cwd::getcwd();
    __PACKAGE__->to_app(handle_static => 1);
};

__DATA__

@@ index.tt
<!doctype html>
<html>

<head>
<met charst="utf-8">
<title>Gallery</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="[% uri_for('/static/css/main.css') %]">
</head>

<body>
<div class="container">
<header><h1>Gallery at [% dir_path %]</h1></header>
    [% FOREACH file IN files %]
    <div class="image"><img src="/[% file %]" width="175" /></div>
    [% END %]
</div>
</body>

</html>

@@ /static/css/main.css
footer {
    text-align: right;
}

div.image {
    float: left;
    margin: 5px;
}
