<?php

/*
Adapted from http://apple.stackexchange.com/questions/111012/place-text-over-image-without-imagemagick

Usage
php addtext.php input.png "The text"
*/

if ((strrchr($argv[1],"jpg") != FALSE) || (strrchr($argv[1],"jpeg") != FALSE)) {
	$jpg=1;
} else if (strrchr($argv[1],"png") != FALSE) {
	$jpg=0;
}
if ($jpg==1) {
	//  The source image (taken from the command line argument)
	$image = imagecreatefromjpeg($argv[1]);
} else {
	//  The source image (taken from the command line argument)
	$image = imagecreatefrompng($argv[1]);
}
//  The text (taken from the command line argument)
$text = $argv[2];

//  Red colour
$colour = imagecolorallocate($image, 255, 255, 255);

//  Change font as desired
$font = '/Library/Fonts/Georgia Italic.ttf';

$height=imagesy($image);
//  Add the text
if ($height <= 1280) {
	$fontsize=15;
} else {
	$fontsize=round($height * 15 / 1280);
}
imagettftext($image, $fontsize, 0, 20, $height-($height*0.05), $colour, $font, $text);

$filename='titled_'.$argv[1];
//  Save the image
if ($jpg==1) {
	imagejpeg($image, $filename);
} else {
	imagepng($image, $filename);
}

//  Free up memory
imagedestroy($image);

?>
