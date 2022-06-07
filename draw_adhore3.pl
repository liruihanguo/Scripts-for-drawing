#!/usr/bin/perl
use strict;
use lib "/zfssz3/NASCT_BACKUP/MS_PMO2017/bianchao/bianchao_ifs1/perl/4_dtv";
use Data::Dumper;
use SVG;
use FontSize;

die "usage $0 sizeA sizeB block.pos speciesA speciesB speciesA_speciesB.svg\n" unless @ARGV;
##########################################################
##########################################################
open SIZEXX,$ARGV[0] or die "$!";
my (%chrom_length_x,%chrom_length_y);
my $chrom_id;
my @chrom_y;my @chrom_x;

my ($x_len,$y_len);
while(<SIZEXX>){
        chomp;
        split;
        push @chrom_x,[$_[0],$_[1]];
        $x_len+=$_[1];
}
close SIZEXX;

open SIZEYY,$ARGV[1] or die "$!";
while(<SIZEYY>){
        chomp;
        split;
        push @chrom_y,[$_[0],$_[1]];
        #$chrom_length_y{$_[0]}=$_[1];
        $y_len+=$_[1];
}
close SIZEYY;

my ($x_divider,$y_divider);
$x_divider=$x_len/4000;
$y_divider=$y_len/($y_len/$x_len*4000);
my $huaban_y;
$huaban_y=$y_len/$x_len*4000+200;
my $svg = SVG->new('width',4200,'height',$huaban_y);
my $xx=100;
my $kk=$huaban_y-100;
my $yy=$huaban_y-100;
my $yy1=$huaban_y-100-$y_len/$x_len*4000;
my $chrom_x=@chrom_x+1;
my $chrom_y=@chrom_y+1;
my (%chrom_length_xx,%chrom_length_yy);
my $kk1=$kk+50;
for (my $i=0;$i<$chrom_x;$i++){
        $chrom_length_xx{$chrom_x[$i][0]}=$xx;
        $svg->line('x1',$xx,'y1',$yy1,'x2',$xx,'y2',$kk,'stroke','black');
        my $scofford_num=$chrom_x[$i][0];
        $scofford_num=~s/\D+//g;
        $svg->text( x=>$xx+$chrom_x[$i][1]/(2*$x_divider), 'y'=>$kk1, -cdata=>$scofford_num,'font-size',30);
        $xx+=$chrom_x[$i][1]/$x_divider;
       # print "$xx\n";
}

#my @aa=split(/\./,$ARGV[0]);
my $qq=$ARGV[3];
my $kk2=$kk1+40;
$svg->text( x=>2000, 'y'=>$kk2, -cdata=>$qq,'font-size',50);
$svg->line('x1',100,'y1',$yy,'x2',4100,'y2',$yy,'stroke','black');
for (my $j=0;$j<$chrom_y;$j++){
        $chrom_length_yy{$chrom_y[$j][0]}=$yy;
        $svg->line('x1',100,'y1',$yy,'x2',4100,'y2',$yy,'stroke','black');
        my $scofford_num=$chrom_y[$j][0];
        $scofford_num=~s/\D+//g;
        $svg->text( x=>40, 'y'=>$yy-$chrom_y[$j][1]/(2*$y_divider)+20, -cdata=>$scofford_num,'font-size',70);
        $yy-=$chrom_y[$j][1]/$y_divider;
}

#my @bb=split(/\./,$ARGV[1]);
my $qq1=$ARGV[4];
my $yy2=$kk-$y_len/$x_len*($kk-100)/2;
$svg->text( x=>10, 'y'=>$yy2, -cdata=>$qq1,'font-size',50);
$svg->line('x1',100,'y1',$yy,'x2',4100,'y2',$yy,'stroke','black');
my $color='red';

open NET,$ARGV[2] or die "$!";
while(<NET>){
chomp;
split;
my $end=$_[3];
my $end1=$_[6];
if(defined $chrom_length_xx{$_[1]} && defined $chrom_length_yy{$_[4]}){
my $x1=$chrom_length_xx{$_[1]}+$_[2]/$x_divider;
my $x2=$chrom_length_xx{$_[1]}+$end/$x_divider;
my $y1=$chrom_length_yy{$_[4]}-$_[5]/$y_divider;
my $y2=$chrom_length_yy{$_[4]}-$end1/$y_divider;
#$color='blue' if(($_[1]-$end)*($_[4]-$end1)<0);
#$svg->line('x1',$x1,'y1',$y1,'x2',$x2,'y2',$y2,'stroke',$color,'stroke-width',6);
$svg->circle('cx'=>$x1,'cy'=>$y1,'r'=>4,'stroke','red','fill','red');
}}
open  OUT, ">@ARGV[5]" || die "fail create";
print OUT $svg->xmlify();
close OUT;
