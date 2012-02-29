use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Gallary',
    AUTHOR        => 'Some Person <person@example.com>',
    VERSION_FROM  => 'app.psgi',
    PREREQ_PM     => {
        'Amon2'                     => '3.28',
        'Amon2::Lite'               => '0.07',
        'Text::Xslate'              => '1.5006',
        'Plack::Session'            => '0.14',
        'URI::Escape'               => '3.31',
        'Plack::Middleware::Static' => '',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
