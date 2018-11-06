#!/usr/bin/perl -w
use strict;
use warnings;
use File::Basename;

####################################step1
my @file1=glob "/share/nas1/honghh/personality/BMK180316-I997/BMK_5_DEG_Analysis/BMK_3_T*/BMK_1_*/*DEG.final.xls";
my @file2=glob "/share/nas1/honghh/personality/BMK180316-I997/Analysis_TF/DEG/*_vs_*.DEG.final.xls";

mkdir "result" unless(-d "result");
my $count=0;
for my $file1(@file1){
	chomp $file1;
	my $basename1=basename($file1);
	#print $basename1,"\n";
	for my $file2(@file2){
		chomp $file2;
		my $basename2=basename($file2);
		#print $basename2,"\n";
		if($basename2 =~ /$basename1/){
			$count++;
			print "$count\n";
			open(IN1,$file1) or die $!;
			open(IN2,$file2) or die $!;
			open(OUT,">result/$basename2");
			my %file=();
			while(my $line=<IN2>){
				chomp $line;
				my ($gene_id,$left)=split /\s+/,$line,2;
				$file{$gene_id}=$left;
			}
			while(<IN1>){
				chomp;
				my ($gene_id,$regulated)=(split /\s+/,$_)[0,-1];
				for my $key(keys %file){
					if($key=~/$gene_id/){
						print OUT $key,"\t",$file{$key},"\t",$regulated,"\n";
					}
				}
			}
			 
		}
		close IN1;
		close IN2;
		close OUT;
	}
}

print "result dir output finished!\n";
print "statistic starting...\n";
sleep(2);
#################################################################step2
my @file3=glob "/share/nas1/honghh/personality/BMK180316-I997/Analysis_TF/DEG/scripts/result/*";
while(my $line=<@file3>){
	print $line,"\n";

}
my %statistic=();
mkdir "eventual_result" unless (-d "eventual_result");
for my $file_3(@file3){
	chomp $file_3;
	my $basename_3=basename($file_3);
	print $basename_3,"\n";
	open(IN,"$file_3") or die $!;
	open(OUT,">eventual_result/$basename_3");
	while(<IN>){
		chomp;
		my($tfname,$tfstyle,$regulated)=(split /\s+/,$_)[1,2,-1];
		next if($tfstyle eq "TR");
		$statistic{$regulated}{$tfstyle}{$tfname} +=1;
	}
	for my $key(sort {$b cmp $a} keys %statistic){
		if($key eq "up"){
			print OUT "UP statistic\n";
			for my $sec_key(keys %{$statistic{$key}}){
				for my $thir_key(keys %{$statistic{$key}{$sec_key}}){
					 print OUT  $thir_key,"\t",$statistic{$key}{$sec_key}{$thir_key},"\t","up","\n";
				}
			}
			
			
		}else{
			print OUT "########################################\n";
			print OUT "DOWN statistic\n";
			for my $sec_key(keys %{$statistic{$key}}){
                                for my $thir_key(keys %{$statistic{$key}{$sec_key}}){
                                         print OUT  $thir_key,"\t",$statistic{$key}{$sec_key}{$thir_key},"\t","down","\n";
                                }
                        }                  

		}	
	}
	%statistic=();
	close IN;
	close OUT;
}

###########################################################step3

print "Due to draw, merge file start..\n";
print "Merge start...\n";
my @file4= glob "/share/nas1/honghh/personality/BMK180316-I997/Analysis_TF/DEG/scripts/eventual_result/*";
my %readdata=();
my %all=();
my $counttime=0;
mkdir "final_result" unless -d "final_result";
for my $file_4(@file4){
	chomp$file_4;	
	$counttime++;
	print $counttime,"\n";
	my $basename_4=basename($file_4);
	open(IN,"$file_4") or die $!;
	open(OUT,">final_result/$basename_4");
	while(<IN>){
	    chomp;
	    next if(/\#/);next if(/UP/);next if(/DOWN/);
	    my $mark=(split /\s+/,$_)[2];
            if($mark eq "up"){
		my ($name,$num)=(split /\s+/,$_);
		$readdata{"up"}{$name}=$num;	
		$all{$name}++;
	    }else{
		my($name,$num)=(split /\s+/,$_);
		$readdata{"down"}{$name}=$num;
		$all{$name}++;
	    }

	}
	close IN;
	print OUT "TF_name","\t","Up","\t","Down","\n";
	for my $key(sort{$all{$a}<=>$all{$b}} keys %all){
		if(exists $readdata{"up"}{$key}){   #string "up" marked the up-regulation and the sec_key was recognized by exists
			print OUT $key,"\t",$readdata{"up"}{$key},"\t";
		}else{
			print OUT $key,"\t","0","\t";
		}
		if(exists $readdata{"down"}{$key}){
			print OUT $readdata{"down"}{$key},"\n";
		}else{
			print OUT "0","\n";
		}
	
	}
	%readdata=();   #empty the hash
close OUT;				
}
	
#############################################################################step4

print "All works finished, the result show below:\n";
my $cmd="ls /share/nas1/honghh/personality/BMK180316-I997/Analysis_TF/DEG/scripts/final_result";
system($cmd);
