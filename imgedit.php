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

//  Add the text
imagettftext($image, 15, 0, 20, 1060, $colour, $font, $text);

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
