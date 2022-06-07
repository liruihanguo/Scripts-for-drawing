#!usr/bin/perl
use strict;
use lib "/zfssz3/NASCT_BACKUP/MS_PMO2017/bianchao/bianchao_ifs1/perl/4_dtv";
use SVG;

die "Usage perl $0 size1 size2 block.pos outfile\n" unless @ARGV==4;
my $cattle_size=shift;
my $sheep_size=shift;
my $block_pos=shift;
my $outfile=shift;

my $svg=SVG -> new('width',6000,'height',600);
my $divider=20000;

open SH,$sheep_size or die "$!";
my @hash_sheep;
while(<SH>){
	chomp;
	split;
	push @hash_sheep,$_[1]}
close SH;

open CA,$cattle_size or die "$!";
my @hash_cattle;
while(<CA>){
	chomp;
	split;
	push @hash_cattle,$_[1]}
close CA;

###cattle chromosomes rectangle
my $wideth=$hash_cattle[0]/$divider;
	$svg -> rect('x'=>0,'y'=>50,'width'=>$wideth,height=>15,stroke=>'dodgerblue',fill=>'dodgerblue');
my $wideth1=$hash_cattle[1]/$divider;
#	my $x_pos=$wideth + 10;
#	$svg -> rect('x'=>$x_pos,'y'=>50,'width'=>$wideth1,height=>15,stroke=>'dodgerblue',fill=>'dodgerblue');
###cattle chromosomes coordinate
for(my $i=0;$i<$hash_cattle[0];$i+=2000000){
	my $x_co=$i/$divider;
	$svg -> line('x1'=>$x_co,'y1'=>45,'x2'=>$x_co,'y2'=>50,'stroke','black');}
for(my $i1=0;$i1<$hash_cattle[0];$i1+=10000000){
	my $x_text=$i1/$divider-2;
	my $num=$i1/1000000;
	$svg -> text('x'=>$x_text,'y'=>40,-cdata=>$num,'font-size',10)	}
						
#for(my $n=0;$n<$hash_cattle[1];$n+=2000000){
#	my $x_co1=$n/$divider+$x_pos;
#	$svg -> line('x1'=>$x_co1,'y1'=>45,'x2'=>$x_co1,'y2'=>50,'stroke','black');
#							}
#for(my $n1=0;$n1<$hash_cattle[1];$n1+=10000000){
#	my $x_text1=$n1/$divider+$x_pos-2;
#	my $num1=$n1/1000000;
#	$svg -> text('x'=>$x_text1,'y'=>40,-cdata=>$num1,'font-size',10);						
#							}
###sheep chromosome rectangle
my $wideth_sheep=$hash_sheep[0]/$divider;
	$svg -> rect('x'=>0,'y'=>300,'width'=>$wideth_sheep,height=>15,stroke=>'dodgerblue',fill=>'dodgerblue');
my $wideth_sheep1=$hash_sheep[1]/$divider;
my $wideth_sheep2=$wideth_sheep+50;
	$svg -> rect('x'=>$wideth_sheep2,'y'=>300,'width'=>$wideth_sheep1,height=>15,stroke=>'dodgerblue',fill=>'dodgerblue');
##sheep chromosome coordinate
for(my $k=0;$k<$hash_sheep[0];$k+=2000000){
	my $x_sh=$k/$divider;
	$svg -> line('x1'=>$x_sh,'y1'=>315,'x2'=>$x_sh,'y2'=>320,'stroke','black');						
						}	
for(my $k1=0;$k1<$hash_sheep[0];$k1+=10000000){
	my $x_text2=$k1/$divider-2;
	my $num2=$k1/1000000;
	$svg ->text('x'=>$x_text2,'y'=>330,-cdata=>$num2,'font-size',10);
								}	
##block polygon
open BL,$block_pos or die "$!";
while(<BL>){
	chomp;
	split;
	if($_[3] eq 'S_barcoo.hic_scaf_11'){
#	my $cattle_width=$_[2]-$_[1];
#	my $sheep_width=abs{$_[4]-$_[5]};
	my $cattle_blc_start=$_[1]/$divider;
	my $cattle_blc_end=$_[2]/$divider;
	my $sheep_blc_start=$_[4]/$divider;
	my $sheep_blc_end=$_[5]/$divider;
	$svg -> polygon('points',[$cattle_blc_start,65,$cattle_blc_end,65,$sheep_blc_end,300,$sheep_blc_start,300],fill=>'blue',stroke=>'blue');
#	$svg -> polygon('points',[$cattle_blc_start,65,$cattle_blc_end,65,$cattle_blc_end,50,$cattle_blc_start,50]);
#	$svg -> polygon('points',[$sheep_blc_end,300,$sheep_blc_start,300,$sheep_blc_start,285,$sheep_blc_start,285]);
				}
	if($_[3] eq 'S_barcoo.hic_scaf_21'){
        my $cattle_blc_start=$_[1]/$divider;
        my $cattle_blc_end=$_[2]/$divider;
        my $sheep_blc_start=$_[4]/$divider+$wideth_sheep+50;
        my $sheep_blc_end=$_[5]/$divider+$wideth_sheep+50;
        $svg -> polygon('points',[$cattle_blc_start,65,$cattle_blc_end,65,$sheep_blc_end,300,$sheep_blc_start,300],fill=>'green',stroke=>'green');
					}		
					}
open OUT,">$outfile" or die "$!";
print OUT $svg->xmlify();
close OUT;


