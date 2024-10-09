
use List::Util qw(max);

 $sequence1 = "ACGCTG";
 $sequence2 = "CATGT";

 $match = 1;
 $mismatch = -1;
 $gap = -2;

 @main_matrix;
 @match_checker_matrix;

my @characters1 = split("",$sequence1);
my @characters2 = split("",$sequence2);

for(my $i=0;$i<length($sequence1);$i++){
	for(my $j=0;$j<length($sequence2);$j++){
		if($characters1[$i] eq $characters2[$j]){
			$match_checker_matrix[$i][$j] = $match;
			print (" ",$match_checker_matrix[$i][$j]," ");
		}
		else{
			$match_checker_matrix[$i][$j] = $mismatch;
			print ($match_checker_matrix[$i][$j]," ");
		}
	}
	print ("\n");
}
print ("\n\n");
for(my $i=0;$i<=length($sequence1);$i++){
	$main_matrix[$i][0] = $i * $gap;
}
for(my $j=0;$j<=length($sequence2);$j++){
	$main_matrix[0][$j] = $j * $gap;
}

for(my $i=1;$i<=length($sequence1);$i++){
	for(my $j=1;$j<=length($sequence2);$j++){
		$main_matrix[$i][$j] = max($main_matrix[$i-1][$j]+$gap,$main_matrix[$i][$j-1]+$gap,$match_checker_matrix[$i-1][$j-1]+$main_matrix[$i-1][$j-1]);
		print (" ",$main_matrix[$i][$j]);
	}
	print "\n";
}

print "\n\n";
$alinged1 = "";
$aligned2 = "";
$ti = length($sequence1);
$tj = length($sequence2);

while($ti>0 or $tj>0){
	if($ti>0 and $tj>0 and $main_matrix[$ti][$tj] == $main_matrix[$ti-1][$tj-1]+$match_checker_matrix[$ti-1][$tj-1]){
		$aligned1 = $characters1[$ti-1].$aligned1;
		$aligned2 = $characters2[$tj-1].$aligned2;
		$ti = $ti-1;
		$tj = $tj-1;
	}
	elsif($ti>0 and $main_matrix[$ti][$tj]== $main_matrix[$ti-1][$tj]+$gap){
		$aligned1 = $characters1[$ti-1].$aligned1;
		$aligned2 = "-".$aligned2;
		$ti = $ti-1;
	}
	else{
		$aligned1 = "-".$aligned1;
		$aligned2 = $characters2[$tj-1].$aligned2;
		$tj= $tj-1;
	}
}

print ($aligned1,"\n");
print $aligned2;


my $seq1 = "AGCTTGTTCCA"; 
my $seq2 = "GCTGTTCA";    


my $MATCH    =  1;
my $MISMATCH = -1;
my $GAP      = -1;


my @matrix;
$matrix[0][0]{score}   = 0;
$matrix[0][0]{pointer} = "none";
for (my $j = 1; $j <= length($seq1); $j++) {
    $matrix[0][$j]{score}   = 0;
    $matrix[0][$j]{pointer} = "none";
}


for (my $i = 1; $i <= length($seq2); $i++) {
    $matrix[$i][0]{score}   = 0;
    $matrix[$i][0]{pointer} = "none";
}



my $max_i = 0;
my $max_j = 0;
my $max_score = 0;

for (my $i = 1; $i <= length($seq2); $i++) {
    for (my $j = 1; $j <= length($seq1); $j++) {
        my ($diagonal_score, $left_score, $up_score);
        
        
        my $letter1 = substr($seq1, $j-1, 1);
        my $letter2 = substr($seq2, $i-1, 1);
        
       
        if ($letter1 eq $letter2) {
            $diagonal_score = $matrix[$i-1][$j-1]{score} + $MATCH;
        }
        else {
            $diagonal_score = $matrix[$i-1][$j-1]{score} + $MISMATCH;
        }
		
		
        
        $up_score   = $matrix[$i-1][$j]{score} + $GAP;
        $left_score = $matrix[$i][$j-1]{score} + $GAP;
        
        if ($diagonal_score <= 0 and $up_score <= 0 and $left_score <= 0) {
            $matrix[$i][$j]{score}   = 0;
            $matrix[$i][$j]{pointer} = "none";
            next;
        }
        
        
        if ($diagonal_score >= $up_score) {
            if ($diagonal_score >= $left_score) {
                $matrix[$i][$j]{score}   = $diagonal_score;
                $matrix[$i][$j]{pointer} = "diagonal";
            } else {
                $matrix[$i][$j]{score}   = $left_score;
                $matrix[$i][$j]{pointer} = "left";
            }
        } else {
            if ($up_score >= $left_score) {
                $matrix[$i][$j]{score}   = $up_score;
                $matrix[$i][$j]{pointer} = "up";
            } else {
                $matrix[$i][$j]{score}   = $left_score;
                $matrix[$i][$j]{pointer} = "left";
            }
        }
        
        if ($matrix[$i][$j]{score} >= $max_score) {
            $max_i     = $i;
            $max_j     = $j;
            $max_score = $matrix[$i][$j]{score};
        }
    }
}



my $align1 = "";
my $align2 = "";

my $j = $max_j;
my $i = $max_i;

while (1) {
    last if $matrix[$i][$j]{pointer} eq "none";
    
    if ($matrix[$i][$j]{pointer} eq "diagonal") {
        $align1 .= substr($seq1, $j-1, 1);
        $align2 .= substr($seq2, $i-1, 1);
        $i--; $j--;
    } elsif ($matrix[$i][$j]{pointer} eq "left") {
        $align1 .= substr($seq1, $j-1, 1);
        $align2 .= "-";
        $j--;
    } elsif ($matrix[$i][$j]{pointer} eq "up") {
        $align1 .= "-";
        $align2 .= substr($seq2, $i-1, 1);
        $i--;
    }
}


$align1 = reverse $align1;
$align2 = reverse $align2;


print "$align1\n";
print "$align2\n";