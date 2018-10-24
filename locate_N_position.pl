#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;


my (@fa,$outfile);
GetOptions(
	"h|?" => \&USAGE,
	"fa:s{,}" => \@fa,
	"o:s" => \$outfile,
	
) or &USAGE;

&USAGE unless (@fa or defined $outfile);

if(!scalar @fa >0){
	print STDERR "your input file number no enough\n";
	&USAGE;	
}
my $begin_time=time();
print "##########Work start################\n";
open(OUT,">$outfile");

for my $file(@fa){
	print "Input filename:",$file,"\n";
	$/=">";
	open(IN,$file) or die $!;
	while(<IN>){
		chomp;
		next if(/^$/);
		my ($gene_id,$seq)=split /\n/,$_,2;
		 $seq=~s/\n+//g;
		if($seq =~/N/g){
			my $seqlen=length($seq);
			my $start=index($seq,'N');my $end=rindex($seq,'N');
			if($start == 0 && $end != $seqlen-2){
				my $Nlen=&N_count($seq);
				print OUT ">",$gene_id,":On the seq of begin",":","N length:$Nlen","\n";
				print OUT $seq,"\n";	
			}elsif($end == $seqlen-2 && $start != 0){
				my $Nlen_1=&rev_N($seq);
				 print OUT ">",$gene_id,"On the seq of end",":","N length:$Nlen_1","\n";
                                print OUT $seq,"\n";
			}elsif($start == 0 && $end == $seqlen-2){
					my $Nlen_begin=&N_count($seq);
					my $Nlen_end=&rev_N($seq);
					print OUT ">",$gene_id,"On the seq of both",":","N begin length:$Nlen_begin;","N end length:$Nlen_end","\n";
					print OUT $seq,"\n";
			}else{
				 print OUT ">",$gene_id,"On the seq of mid","\n";
                                print OUT $seq,"\n";

			}
		}else{
			print OUT ">",$gene_id,"No 'N' in the seq","\n";
                        print OUT $seq,"\n";
		}
			
	}
	close IN;

}
$/="\n";
close OUT;
my $end_time=time();
my $elapse=$end_time-$begin_time;
print "Time elaspe:$elapse\n";

####statistic N number function
sub N_count{
	my $string=shift;
	my @word=();
	my $Ncount=0;
	for(my $i=0;$i<length($string);$i++){
		$word[$i]=substr($string,$i,1);
		if($word[$i] ne 'N'){
			return $Ncount;
		}else{
			$Ncount++;
		}
	}

}
################################
sub rev_N{
	my $string=shift;
	my $Ncount=0;
	my @word=split //,$string;
        for(my $i=length($string)-2;$i>=0;$i--){
                if($word[$i] ne 'N'){
                        return $Ncount;
                }else{
                        $Ncount++;
                }
        }

}


sub USAGE{
my $usage=<<USAGE;
	Contact:xiaohui\@princes_archase
	Usage:perl $0 -fa [fa1 fa2 fa3] -o [result]
USAGE
	print $usage;
	exit;
}
