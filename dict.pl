#!/usr/bin/env perl

use strict;
use warnings;
use v5.012;
use utf8;
binmode STDOUT, ":utf8";

use Path::Tiny;
use YAML qw(Load Bless Dump);
use Data::Dumper;

my $dict = {};

my @ghazalas = path("01-ghazal")->children( qr/.*/ );

foreach my $ghazal (sort @ghazalas)
{
	my $file = $ghazal->slurp_utf8;
	my $yaml = [Load($file)];
	my $kalamat = $yaml->[0]->{kalamat};

	my $i;
	for ($i=0; $i < scalar @$kalamat; ++$i ) {
		my ($key, $value) = each %{ $kalamat->[$i] };
		$dict->{$key} = $value if $value;
		$kalamat->[$i]->{$key} = $dict->{$key} if (not $value and $dict->{$key})
	}
######### comented area: if save kalamat in hash refrence ###########
#	while (my ($key, $value) = each $kalamat)
#	{
#		$dict->{$key} = $value if $kalamat->{$key};
#		$kalamat->{$key} = $dict->{$key} if (not $kalamat->{$key} and $dict->{$key})
#	}
#	Bless($kalamat)->keys( [sort farsi keys %$kalamat] );
	$ghazal->spew_utf8(formated($yaml));
}

Bless($dict)->keys( [sort farsi keys %$dict] );
path( 'dictionary.yaml' )->spew_utf8( Dump($dict) );

sub formated {
	my $yaml = shift;
	my $mesra;
		foreach ( @{ $yaml->[0]->{mesra} } )
		{
			$mesra .= "  - $_\n"
		}
	$mesra =~ s/\n+$//;


	(my $output = <<"	END_OUTPUT") =~ s/^\t\t//gm;
		utid: $yaml->[0]->{utid}
		title: $yaml->[0]->{title}
		_index: $yaml->[0]->{_index}
		poet: $yaml->[0]->{poet}
		list: $yaml->[0]->{list}
		alphabet: $yaml->[0]->{alphabet}
		mesra:
		$mesra
		vazn: $yaml->[0]->{vazn}
		bahr: $yaml->[0]->{bahr}
	END_OUTPUT

	my $esteghbal;
	do {
		foreach ( sort farsi keys %{ $yaml->[0]->{esteghbal} } )
		{
			$esteghbal .= "  $_: $yaml->[0]->{esteghbal}->{$_}\n";
		}
	} if $yaml->[0]->{esteghbal};
	#$esteghbal =~ s/\n+$//;
	$output .=
		$esteghbal
		? "esteghbal:\n$esteghbal"
		: "esteghbal:\n";


	my $tazmin;
	do {
		foreach ( sort farsi keys %{ $yaml->[0]->{tazmin} } )
		{
			$tazmin .= "  $_: $yaml->[0]->{tazmin}->{$_}\n";
		}
	} if $yaml->[0]->{tazmin};
	#$tazmin =~ s/\n+$//;
	$output .=
		$tazmin
		? "tazmin:\n$tazmin"
		: "tazmin:\n";


	my $arabi;
	if ($yaml->[0]->{arabi})
	{
		foreach ( sort farsi keys %{ $yaml->[0]->{arabi} } )
		{
			$arabi .= "  $_: $yaml->[0]->{arabi}->{$_}\n";
		}
	}
	#$arabi =~ s/\n+$//;
	$output .=
		$arabi
		? "arabi:\n$arabi"
		: "arabi:\n";


	my $kalamat;
		my $i;
		for ( $i = 0; $i < scalar @{$yaml->[0]->{kalamat}}; ++$i )
		{
			my ($key, $value) = %{$yaml->[0]->{kalamat}->[$i]};
			$kalamat .=
				$value
				? "  - $key: $value\n"
				: "  - $key:\n";

			$dict->{$key} = $value if $value;
			$yaml->[0]->{kalamat}->[$i]->{$key} = $dict->{$key} if (not $value and $dict->{$key})
		}
#		foreach ( sort farsi keys %{ $yaml->[0]->{kalamat} } )
#		{
#			$kalamat .=
#				$yaml->[0]->{kalamat}->{$_}
#				? "  $_: $yaml->[0]->{kalamat}->{$_}\n"
#				: "  $_:\n";
#		}
	#$kalamat =~ s/\n+$//;
	$output .= "kalamat:\n$kalamat";


	my $mani;
		foreach ( sort keys %{ $yaml->[0]->{mani} } )
		{
			$mani .=
				$yaml->[0]->{mani}->{$_}
				? "  $_: $yaml->[0]->{mani}->{$_}\n"
				: "  $_:\n";
		}
	#$mani =~ s/\n+$//;
	$output .= "mani:\n$mani";


	my $analyze;
		foreach ( sort farsi keys %{ $yaml->[0]->{analyze} } )
		{
			$analyze .=
				$yaml->[0]->{analyze}->{$_}
				? "  $_: $yaml->[0]->{analyze}->{$_}\n"
				: "  $_:\n";
		}
	#$analyze =~ s/\n+$//;
	$output .= "analyze:\n$analyze";


	$output .= "--- |";


	$output .= "\n$yaml->[1]" if $yaml->[1];


	return $output;
}

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

	my $anum = $fawords{$aword} ? $fawords{$aword} : 58;
	my $bnum = $fawords{$bword} ? $fawords{$bword} : 58;

	return $anum <=> $bnum;
}
