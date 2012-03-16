#!/usr/bin/env perl

use strict;
use warnings;
use MongoDB;


my $connection = MongoDB::Connection->new(
    host => 'mbdb-ynonp-data-0.dotcloud.com', 
    port => 22756,
    username => 'root',
    password => 'hwQGTPLW9Qcj6aU0Z1Ih');

my $database   = $connection->foo;
my $collection = $database->bar;
my $id         = $collection->insert({ some => 'data' });

my $obj = $collection->find_one({ some => 'data' });

use Data::Dumper;
print "$id\n";
print Dumper($obj), "\n";