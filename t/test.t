#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

subtest 'array test' => sub {
  my @arr = ();
  push(@arr, 1);
  is(@arr[0], 1, 'pushed');
};


done_testing();
