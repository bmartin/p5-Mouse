#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 5;
use lib 't/lib';

do {
    package Class;
    use Mouse;

    package Child;
    use Mouse;
    extends 'Class';

    package Mouse::TestClass;
    use Mouse;
    extends 'Anti::Mouse';

    sub mouse { 1 }
};

can_ok(Child => 'new');

my $child = Child->new;

isa_ok($child => 'Child');
isa_ok($child => 'Class');
isa_ok($child => 'Mouse::Object');

can_ok('Mouse::TestClass' => qw(mouse antimouse));
