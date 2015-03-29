#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny;

my $contents = path("./makeEmscripten.bat")->slurp_utf8;
$contents =~ s{\Aemcc\.bat }{emcc};
$contents =~ s{ && del ([a-zA-Z\.\\/]+)(?:\s*)\z}{my $s = $1; $s =~ tr#\\#/#; "&& rm -f $s\n"}e or die "Cannot match.";

$contents =~ s{\A}{#!/bin/bash\n};

path("./makeEmscripten.sh")->spew_utf8($contents);
