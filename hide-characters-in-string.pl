#!/usr/bin/env perl

#
# Script to hide random characters with underscores
#

# TODO:
#   * instead of going character-by-character, hide entire word tokens
#   * Integrate with parts-of-speech (POS) database for smarter hiding,
#      e.g., hide all but the rare words, hide all but the nouns, verbs,
#      adjectives, proper nouns, etc.

use strict;
use List::Util qw(shuffle);

# Usage:
if (! defined($ARGV[0])) {
  print "Usage:
$0 filename [how-much-is-hidden]

how-much-is-hidden (the higher the value, the higher number of characters are hidden)
  -  1: no characters hidden
  -  2: half characters hidden
  - 10: most characters hidden
";
}

# Slurp the text file into a string
my $filename = $ARGV[0];
open my $fh, '<', $filename or die "Can't open file $!";
my $file_content = do { local $/; <$fh> };

# Fraction of characters to hide: 1 / ARGV[1]
my $hide_fraction_denominator = $ARGV[1] || 2;

my $len = length($file_content);
my @random_number_seq = shuffle 0..$len;

my $offset = ($len - int($len / $hide_fraction_denominator));
print "\noffset = $offset\n\n";
splice @random_number_seq, $offset;

my %hash = map { $_ => 1 } @random_number_seq;

my $i = 0;
while ($file_content =~ /(.|\n|\r)/g) {
    if (($hash{$i}) and ($& =~ /\w/)) {
      print "_";
    } else {
      print "$&";
    }
    $i++;
}
