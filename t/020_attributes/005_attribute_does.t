#!/usr/bin/perl
# This is automatically generated by author/import-moose-test.pl.
# DO NOT EDIT THIS FILE. ANY CHANGES WILL BE LOST!!!
use t::lib::MooseCompat;

use strict;
use warnings;

use Test::More;
use Test::Exception;


{
    package Foo::Role;
    use Mouse::Role;
    use Mouse::Util::TypeConstraints;

    # if does() exists on its own, then
    # we create a type constraint for
    # it, just as we do for isa()
    has 'bar' => (is => 'rw', does => 'Bar::Role');
    has 'baz' => (
        is   => 'rw',
        does => role_type('Bar::Role')
    );

    package Foo::Class;
    use Mouse;

    with 'Foo::Role';

    package Bar::Role;
    use Mouse::Role;

    # if isa and does appear together, then see if Class->does(Role)
    # if it does work... then the does() check is actually not needed
    # since the isa() check will imply the does() check
    has 'foo' => (is => 'rw', isa => 'Foo::Class', does => 'Foo::Role');

    package Bar::Class;
    use Mouse;

    with 'Bar::Role';
}

my $foo = Foo::Class->new;
isa_ok($foo, 'Foo::Class');

my $bar = Bar::Class->new;
isa_ok($bar, 'Bar::Class');

lives_ok {
    $foo->bar($bar);
} '... bar passed the type constraint okay';

dies_ok {
    $foo->bar($foo);
} '... foo did not pass the type constraint okay';

lives_ok {
    $foo->baz($bar);
} '... baz passed the type constraint okay';

dies_ok {
    $foo->baz($foo);
} '... foo did not pass the type constraint okay';

lives_ok {
    $bar->foo($foo);
} '... foo passed the type constraint okay';



# some error conditions

{
    package Baz::Class;
    use Mouse;

    # if isa and does appear together, then see if Class->does(Role)
    # if it does not,.. we have a conflict... so we die loudly
    ::dies_ok {
        has 'foo' => (isa => 'Foo::Class', does => 'Bar::Class');
    } '... cannot have a does() which is not done by the isa()';
}

{
    package Bling;
    use strict;
    use warnings;

    sub bling { 'Bling::bling' }

    package Bling::Bling;
    use Mouse;

    # if isa and does appear together, then see if Class->does(Role)
    # if it does not,.. we have a conflict... so we die loudly
    ::dies_ok {
        has 'foo' => (isa => 'Bling', does => 'Bar::Class');
    } '... cannot have a isa() which is cannot does()';
}

done_testing;
