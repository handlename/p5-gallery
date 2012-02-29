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

our $VERSION = '0.01';

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

get '/image/{filename}' => sub {
    my ($c, $args) = @_;

    my $filepath = Cwd::getcwd() . '/' . $args->{filename};

    unless (-f $filepath) {
        return $c->res_404;
    }

    my $fh;
    open $fh, $filepath;

    my $content = do { local $/; <$fh> };

    my $res = $c->create_response(
        200, [
            'Content-Type'   => 'image/' . (split '\.', $filepath)[-1],
            'Content-Length' => -s $filepath,
        ],
        $content,
    );

    close $fh;

    return $res;
};

# load plugins
__PACKAGE__->to_app(handle_static => 1);

__DATA__

@@ index.tt
<!doctype html>
<html>

<head>
<met charst="utf-8">
<title>Gallary</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="[% uri_for('/static/css/main.css') %]">
</head>

<body>
<div class="container">
<header><h1>Gallary at [% dir_path %]</h1></header>
    [% FOREACH file IN files %]
    <div class="image"><img src="/image/[% file %]" width="175" /></div>
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
