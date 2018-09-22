#!/usr/bin/env perl

use strict;
use warnings;
use v5.012;
use utf8;
binmode STDOUT, ":utf8";

use Path::Tiny;
use YAML;
use Data::Dumper;

my $file = path('001.yaml')->slurp_utf8;
my $dict = [Load($file)];
say foreach keys %{ $dict->[0]->{kalamat} };
#print Dumper @dict;
#foreach my $hash (@{ $dict[0]->{kalamat} })
#{
#	foreach my $key (keys %$hash) {
#		say $key
#	}
#}



#foreach my $verb (sort farsi keys %$dict) {
#	say "\"$verb\": \"$dict->{$verb}\"";
#};


sub farsi {
	my @awords = split //, $a;
	my @bwords = split //, $b;
	my %fawords = (
		'۰' => 1,
		'۱' => 2,
		'۲' => 3,
		'۳' => 4,
		'۴' => 5,
		'۵' => 6,
		'۶' => 7,
		'۷' => 8,
		'۸' => 9,
		'۹' => 10,
		'آ' => 11,
		'ا' => 12,
		'اْ' => 13,
		'اَ' => 14,
		'اِ' => 15,
		'اُ' => 16,
		'اً' => 17,
		'اٍ' => 18,
		'اٌ' => 19,
		'أ' => 20,
		'إ' => 21,
		'ب' => 22,
		'پ' => 23,
		'ت' => 24,
		'ث' => 25,
		'ج' => 26,
		'چ' => 27,
		'ح' => 28,
		'خ' => 29,
		'د' => 30,
		'ذ' => 31,
		'ر' => 32,
		'ز' => 33,
		'ژ' => 34,
		'س' => 35,
		'ش' => 36,
		'ص' => 37,
		'ض' => 38,
		'ط' => 39,
		'ظ' => 40,
		'ع' => 41,
		'غ' => 42,
		'ف' => 43,
		'ق' => 44,
		'ک' => 45,
		'ك' => 46,
		'گ' => 47,
		'ل' => 48,
		'م' => 49,
		'ن' => 50,
		'و' => 51,
		'ؤ' => 52,
		'ه' => 53,
		'ة' => 54,
		'ی' => 55,
		'ي' => 56,
		'ئ' => 57,
	);

	my ($aword, $bword);
	while (1) {
		$aword = shift @awords || ''; #substr $a, 0, 1;
		$bword = shift @bwords || ''; #substr $b, 0, 1;
		last if ($aword ne $bword);
	}

	my $anum = $fawords{$aword} ? $fawords{$aword} : 44;
	my $bnum = $fawords{$bword} ? $fawords{$bword} : 44;

	return $anum <=> $bnum;
}
