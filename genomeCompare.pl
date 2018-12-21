#genome compare- jack sebring 2018
use warnings;
use strict;
use Cwd;
use File::Basename;
use Excel::Writer::XLSX;    
my @lines1;
my @lines2;
my @chromosomeArray1;
my @chromosomeArray2;
my @positionArray1;
my @positionArray2;
my @pairsArray1;
my @pairsArray2;
my @compareArray;
my $chromosome;
my $position;
my $pairs;
my $one_line;

open(FILE, "<", "genome_Jack_Sebring_v5_Full_20181217065644.txt") or die("Can't open file");
@lines1 = <FILE>;
close(FILE);

foreach $one_line (@lines1)
{
	if ($one_line !~ /\#\s.*/){
		if( $one_line =~/\w+\s(\w+)\s(\w+)\s(\S+)/)		#rs2272757	1	881627	AA
		{
			$chromosome = $1;
			$position = $2;
			$pairs = $3;
			push(@chromosomeArray1,$chromosome);
			push(@positionArray1,$position);
			push(@pairsArray1,$pairs);
		}
	}
}
open(FILE, "<", "genome_Melissa_Sebring_v5_Full_20181217103818.txt") or die("Can't open file");
@lines2 = <FILE>;
close(FILE);

foreach $one_line (@lines2)
{
	if ($one_line !~ /\#\s.*/)
	{
		if( $one_line =~/\w+\s(\w+)\s(\w+)\s(\S+)/)		#rs2272757	1	881627	AA
		{
			$chromosome = $1;
			$position = $2;
			$pairs = $3;
			push(@chromosomeArray2,$chromosome);
			push(@positionArray2,$position);
			push(@pairsArray2,$pairs);
		}
	}
}

my $i = 0; #number of genes
my $counter = 0; #number of same genes
my $colcounter = 1;
my $rowcounter = 1;
my $workbook  = Excel::Writer::XLSX->new( 'genes.xlsx');
my $worksheet = $workbook->add_worksheet();
my $breakFormat = $workbook->add_format();
$breakFormat ->set_bg_color('black');
my $matchFormat = $workbook->add_format();
$matchFormat ->set_bg_color('green');
my $missFormat = $workbook->add_format();
$missFormat ->set_bg_color('red');

 while($chromosomeArray1[$i]){
	if ($pairsArray1[$i] eq $pairsArray2[$i]){
		 push(@compareArray,"1");
	 $counter++
	}
	elsif ($pairsArray1[$i] ne $pairsArray2[$i]){
		push(@compareArray,"0");
	}
	$i++;
 }
$worksheet->write(0,0, "Chromosomes");
$worksheet->write(0,1, "Matches: ".$counter );
$worksheet->write(0,2,, "Total: ".$i);
my $percent = $counter / $i;
$worksheet->write(0,3,, "Percentage: ".$percent );

my $tempChrome = 1;
$i = 0;
$worksheet->write(1,0, $tempChrome);
foreach (@compareArray)
{
	if ($chromosomeArray1[$i] ne $tempChrome) #checks if the chromosome number has changed
	{
		$colcounter = 0;
		$tempChrome = $chromosomeArray1[$i];
		$worksheet->write($rowcounter,$colcounter, $tempChrome);#chromosome number on left
		$rowcounter = $rowcounter + 1;
		$colcounter++;
	}
	if ($_ eq 1){ #is the compare 1 or 0, match or miss
		$worksheet->write($rowcounter,$colcounter, $positionArray1[$i], $matchFormat);
	}
	else{
		$worksheet->write($rowcounter,$colcounter, $positionArray1[$i], $missFormat);
	}
	$colcounter++;
	$i++;
}
print "Excel File has been writen to: genes.xlsx\n";
$workbook -> close;


