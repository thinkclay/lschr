#!/usr/bin/perl

use CGI qw(:all);

print "Content-type: text/html\n\n";

print <<all_page_end;
<html>
<head>
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<style>
body,td {font:normal 14px Verdana,"DejaVu Sans","Bitstream Vera Sans","Lucida Sans",Arial,sans-serif; background-color:#f7f7f7; text-align:justify}
p		{margin:8px 0px 0px}
p.16	{margin:16px 0px 0px}
h2		{font-weight:normal; font-size:19px; text-align:center}
small	{font-size:12px}
table	{background-color:white}
tr.cols	{height:125px}
td		{border:6px solid #f7f7f7}
tr.cols td	{border-width:12px}
.inter	{margin:8px 0px 12px 32px}
.link	{text-align:right; font-weight:bold; font-size:12px}
a		{text-decoration:none}
</style>
all_page_end

$data=param('data');
if (! param)
	{page0();}
elsif (defined param('start'))
	{page(1);}
elsif ((length($data) == 8) && check($data))
	{page(2);}
elsif ((length($data) == 16) && check(substr($data,0,8)) && check(substr($data,8)))
	{page4();}

else
	{wrong();}

#
# show introduction
#

sub page0 {

print <<intro_page_end
<title>L&uuml;scher Colour Test</title>
</head>
<body>
<table>
<tr>
<td>
<h2>L&uuml;scher Colour Test</h2>
<center><small>
Test (C) by Test Verlag, Basel, 1948.<br>
Program (C) by Kai Arste, 2000.
</small></center>
</td>
</tr>
<tr>
<td>
Welcome to my on-line version of the (shorter) personality test designed by Dr. Max L&uuml;scher, based on colour choices. In this test, the subject twice selects eight colours in the order of liking them, and the interpretation is based on these choices. For further details of the test, and of the theory behind it, you are referred to one of the books in which the test has been published.<p>
This is a 'deep' test, in that the interpretations can be quite personal, and so it is advisable to be cautious with the outcome; not only can it occasionally be upsetting, it can also be 'far off the mark'. The test should not be treated as a game or used as a weapon in personal disputes; but it can serve as an interesting starting point for conversations -- if only about the ways in which the test's interpretations may <u>not</u> apply in a particular case.<p>
Note that the transactions over the Internet are not secure, and that your choices and the page of the interpretation may be kept in your local cache, but that no results will be stored on the server where the program is running.<p>
Click here to <a href=lschr.pl?start=><b>start the test,</b></a> (or you can <a href=# onclick=\"window.close()\"><b>close the window.</b></a>) Thank you for your interest in my little programming exercise. Enjoy.
<blockquote style="margin-bottom:0px"><small>
Note: in this version the test only works on browsers that are DOM-compliant, which should include IE 5.5 or above and NN 6.0 or above, (but not NN 4.7.)
</small></blockquote>
</td>
</tr>
</table>
</body>
</html>
intro_page_end
}

#
# display colour choice page 1 or 2
#

sub page {
$pn = $_[0];

$old = "01234567";
for ($i=8; $i>0; $i=$i-1) {
    $take = int(rand $i);
    @ra = (@ra,substr($old,$take,1));
    $new = substr($old,0,$take).substr($old,$take+1);
    $old = $new;
}

# @col = qw(#909090 #002080 #106040 #ff3118 #ffeb00 #c00070 #c06020 #000000);

@col = qw(#909090 #002080 #208050 #ff3118 #ffeb00 #c00070 #c06020 #000000);

if ($pn ==1) {
	$toptext = "1. Choose the following colours by clicking on them, in the order in which they appeal to you, starting with the one you like most. Or finish the test and <a href=# onclick=\"window.close()\"><b>close the window</b></a> at any time.";
	$bottext = "After you have chosen your last colour, you will be asked to choose again from the same colours. This is not a memory test, so there is no need to select colours in the same order. (You may have to wait for the next screen to be obtained from the server.)";
}
else {
	$toptext = "2. Thank you. Please choose again from the same colours. There is no need to choose them in the same order as before. Or finish the test and <a href=# onclick=\"window.close()\"><b>close the window</b></a> at any time.";
	$bottext = "After you have finished choosing the second time, the program on the server will return an interpretation based on your colour choices. (You may have to wait for the next screen to be obtained from the server.)";
}

print <<choice_page_end;
<title>L&uuml;scher Colour Test: Colour Choices $pn</title>
<script>
var choices="";
var count=0;
function choose(str) {
count=count+1;
choices=choices+str;
spanname='span'+str;
document.getElementById(spanname).style.backgroundColor='#efefef';
if (count==8) {
x=window.setTimeout('show()',1000); } }
function show() {
self.location.href='lschr.pl?data=$data'+choices; }
</script>
</head>
<body>
<table width=100% cellspacing=3>
<tr>
<td colspan=4>
<h2>L&uuml;scher Colour Test</h2>
<p>
$toptext
</td>
</tr>
<tr class=cols>
<td id=span$ra[0] style="background-color:$col[$ra[0]]" onclick="choose($ra[0])">&nbsp;</td>
<td id=span$ra[1] style="background-color:$col[$ra[1]]" onclick="choose($ra[1])">&nbsp;</td>
<td id=span$ra[2] style="background-color:$col[$ra[2]]" onclick="choose($ra[2])">&nbsp;</td>
<td id=span$ra[3] style="background-color:$col[$ra[3]]" onclick="choose($ra[3])">&nbsp;</td>
</tr>
<tr class=cols>
<td id=span$ra[4] style="background-color:$col[$ra[4]]" onclick="choose($ra[4])">&nbsp;</td>
<td id=span$ra[5] style="background-color:$col[$ra[5]]" onclick="choose($ra[5])">&nbsp;</td>
<td id=span$ra[6] style="background-color:$col[$ra[6]]" onclick="choose($ra[6])">&nbsp;</td>
<td id=span$ra[7] style="background-color:$col[$ra[7]]" onclick="choose($ra[7])">&nbsp;</td>
</tr>
<tr>
<td colspan=4>
$bottext
</td>
</tr>
</table>
</body>
</html>
choice_page_end
print "\n";
}

#
# process data and display interpretation
#

sub page4 {

$inter = substr($ENV{SCRIPT_FILENAME}, 0, length($ENV{SCRIPT_FILENAME})-2).'txt';
open (Inter,$inter);
@lines = <Inter>;
close(Inter);

$x0 = substr($data,0,8);
@x = split(//,$x0);
$y0 = substr($data,8);
@y = split(//,$y0);
$allx = $x0.join('',reverse(split(//,$x0)));

sub line {
    return $lines[$_[0]*64+$_[1]*8+$_[2]];
}

###

$done4 = $done5 = $done6 = $done7 = 0;

if (index($allx,$y[0].$y[1]) != -1) {
    $dobj = line(5,$y[0],$y[1]);
    if (index($allx,$y[1].$y[2]) != -1) {
        $exst = line(0,$y[1],$y[2]);
        $rstr = line(4,$y[3],$y[4])."<br>";
        $done5 = 1;
    }
    elsif (index($allx,$y[2].$y[3]) != -1) {
        $exst = line(0,$y[2],$y[3]);
        $done4 = 1;
    }
    elsif (index($allx,$y[3].$y[4]) != -1) {
        $exst = line(0,$y[2],$y[2]);
        $rstr = line(4,$y[3],$y[4])."<br>";
        $done5 = 1;
    }
    else {
        $exst = line(0,$y[2],$y[3]);
        $done4 = 1;
    }
}
elsif (index($allx,$y[1].$y[2]) != -1) {
    $dobj = line(5,$y[0],$y[0]);
    $exst = line(0,$y[1],$y[2]);
    $rstr = line(4,$y[3],$y[4])."<br>";
    $done5 = 1;
}
else {
    $dobj = line(5,$y[0],$y[1]);
    $exst = line(0,$y[2],$y[3]);
    $done4 = 1;
}

if (index($allx,$y[6].$y[7]) != -1) {
    $phys = line(1,$y[6],$y[7]);
    $psyc = line(2,$y[6],$y[7]);
    $inbr = line(3,$y[6],$y[7]);
    $done7 = 1;
}
elsif (index($allx,$y[5].$y[6]) != -1) {
    $phys = line(1,$y[7],$y[7]);
    $psyc = line(2,$y[7],$y[7]);
    $inbr = line(3,$y[7],$y[7]);
    $rstr = $rstr.line(4,$y[5],$y[6])."<br>";
    $done6 = 1;
}
else {
    $phys = line(1,$y[6],$y[7]);
    $psyc = line(2,$y[6],$y[7]);
    $inbr = line(3,$y[6],$y[7]);
    $done7 = 1;
}

if ($done5 && $done6) {
    if (index($allx,$y[4].$y[5]) != -1) {
        $rstr = $rstr.line(4,$y[4],$y[5])."<br>";
    }
}
  
if ($done5 && $done7) {
    if (index($allx,$y[4].$y[5]) != -1) {
        $rstr = $rstr.line(4,$y[4],$y[5])."<br>";
    }
    else {
        if (index($allx,$y[5].$y[6]) != -1) {
            $rstr = $rstr.line(4,$y[5],$y[6])."<br>";
        }
        else {
            $rstr = $rstr.line(4,$y[5],$y[5])."<br>";
        }
    }
}

if ($done4 && $done6) {
    if (index($allx,$y[4].$y[5]) != -1) {
        $rstr = $rstr.line(4,$y[4],$y[5])."<br>";
    }
    else {
        if (index($allx,$y[3].$y[4]) != -1) {
            $rstr = $rstr.line(4,$y[3],$y[4])."<br>";
        }
        else {
            $rstr = $rstr.line(4,$y[4],$y[4])."<br>";
        }
    }
}

if ($done4 && $done7) {
    if (index($allx,$y[4].$y[5]) != -1) {
        $rstr = $rstr.line(4,$y[4],$y[5])."<br>";
    }
    else {
        if (index($allx,$y[3].$y[4]) != -1) {
            $rstr = $rstr.line(4,$y[3],$y[4])."<br>";
            if (index($allx,$y[5].$y[6]) != -1) {
                $rstr = $rstr.line(4,$y[5],$y[6])."<br>";
            }
            else {
                $rstr = $rstr.line(4,$y[5],$y[5])."<br>";
            }
        }
        elsif (index($allx,$y[5].$y[6]) != -1) {
            $rstr = $rstr.line(4,$y[4],$y[4])."<br>";
            $rstr = $rstr.line(4,$y[5],$y[6])."<br>";
        }
        else {
            $rstr = $rstr.line(4,$y[4],$y[5])."<br>";
        }
    }
}

if (substr($rstr,-4,4) eq "<br>") {$rstr = substr($rstr,0,length($rstr)-4);}

###

$actp = line(6,$y[0],$y[7]);

###

$ambi = "";
$val = 0;

if (index($x[6].$x[7],$y[0]) != -1) {
    $ambi=line(6,$y[0],$y[0])."<br>";
    $val++;
}
if (index($x[0].$x[1],$y[7]) != -1) {
    $ambi=$ambi.line(6,$y[7],$y[7])."<br>";
    $val++;
}
if ((index($x[6].$x[7],$y[1]) != -1) && ($val < 2)) {
    $ambi=$ambi.line(6,$y[1],$y[1])."<br>";
    $val++;
}
if ((index($x[1].$x[1],$y[6]) != -1) && ($val < 2)) {
    $ambi=$ambi.line(6,$y[6],$y[6]);
}

if (substr($ambi,-4,4) eq "<br>") {$ambi = substr($ambi,0,length($ambi)-4);}
if ($ambi eq "") {$ambi = "The colour choices do not suggest any particular ambivalences."};

###

$work = "The colour choices do not suggest a particular approach to work.";
$y01234 = substr($data,8,5);
if ( ((index($y01234,"234")) != -1) or ((index($y01234,"243")) != -1) ) {
    $work = line(7,0,0);
}
if ( ((index($y01234,"324")) != -1) or ((index($y01234,"342")) != -1) ) {
    $work = line(7,0,1);
}
if ( ((index($y01234,"423")) != -1) or ((index($y01234,"432")) != -1) ) {
    $work = line(7,0,2);
}

###

$anxi=0;
if (index("1234",$y[5]) != -1) {$anxi=$anxi+1};
if (index("1234",$y[6]) != -1) {$anxi=$anxi+2};
if (index("1234",$y[7]) != -1) {$anxi=$anxi+3};

$comp=0;
if (index("067",$y[2]) != -1) {$comp=$comp+1};
if (index("067",$y[1]) != -1) {$comp=$comp+2};
if (index("067",$y[0]) != -1) {$comp=$comp+3};

###

print <<inter_page_end;
<title>L&uuml;scher Colour Test: Interpretation</title>
</head>
<body>
<table>
<tr><td>
<h2>L&uuml;scher Colour Test: Interpretation</h2>
Thank you. You will now be able to read the interpretation of your choices of colours according to Dr. Max L&uuml;scher's test. Where the words "he, him, himself" occur, they should be replaced by "she, her, herself" when appropriate.<br>
Again remember to treat the interpretations, both your own and those of other people, with the caution they require: while they can be interesting, and are sometimes rather close to the bone, they can also be far off the mark.
<div class=link><a href='' onclick=\"window.close(); return false\">Close.</a>
</tr>
</td>
<tr><td>
<b>Existing Situation:</b>
	<div class=inter>$exst</div>
</td></tr>
<tr><td>
<b>Stress Sources:</b>
<div class=inter>
	<b>Physiological Interpretation:</b><br>
	$phys</div>
<div class=inter><b>Psychological Interpretation:</b><br>
	$psyc</div>
<div class=inter><b>In Brief:</b><br>
	$inbr</div>
</td></tr>
<tr><td>
<b>Restrained Characteristics:</b>
	<div class=inter>$rstr</div>
</td></tr>
<tr><td>
<b>Desired Objective:</b>
	<div class=inter>$dobj</div>
</td></tr>
<tr><td>
<b>Actual Problems:</b>
	<div class=inter>$actp</div>
</td></tr>
<tr><td>
<b>Ambivalence(s):</b>
	<div class=inter>$ambi</div>
</td></tr>
<tr><td>
<b>Approach to Work:</b>
	<div class=inter>$work</div>
</td></tr>
<tr><td>
<b>Anxiety,</b> on a scale of 0 (lowest) to 6 (highest): &nbsp;
	$anxi .
<p class=16>
<b>Compulsiveness</b> of compensations (from 0 to 6): &nbsp;
	$comp .
<p class=16>
<div class=link><a href='' onclick=\"window.close(); return false\">Close.</a></div>
</td></tr>
</table>
<small>Test (C) by Test Verlag, Basel, 1948. Program (C) by Kai Arste, 2000.</small>
</body>
</html>
inter_page_end
print "\n";
}

#
# to show in case of bad data
#

sub wrong {
print <<wrong_page_end;
<title>Luuml;scher Colour Test: Error</title>
</head>
<body>
<hr><p>
<h2>The data string submitted was not of the right format.</h2>
<div class=link><a href='' onclick=\"window.close(); return false\">Close.</a></div>
<p><hr>
</body>
</html>
wrong_page_end
}

sub check {
    if (join('',sort(split(//,$_[0]))) eq "01234567") {return 1}
    else {return 0};
}
