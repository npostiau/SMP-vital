<?php
//if (isset($argv[1])) then
//		   $name = $argv[1]; // use the command line argument for ID
//} else {
//		   print("Enter file name: "
//				      $name = fgets(STDIN); // prompt the user for an ID
//}


$name = "NAME_OF_FILE";//will be edited by sed


$path = "/afs/cern.ch/user/n/npostiau/www/HLT_SMP_Validations/";
// set source file name and path
//$source = $path . "Validations/" . $name . ".txt";
$source = $path . "Validations/" . $name;

$output_path = $path . "html_validations/";

// read raw text as array
$raw = file($source) or die("Cannot read file");

// retrieve first and second lines (title and author)
$slug = array_shift($raw);
$byline = array_shift($raw);

// join remaining data into string
$data = join('', $raw);


// replace special characters with HTML entities
// replace line breaks with <br />
$html = nl2br(htmlspecialchars($data));

// replace multiple spaces with single spaces
//$html = preg_replace('/\s\s+/', ' ', $html);

// replace URLs with <a href...> elements
$html = preg_replace('/\s(\w+:\/\/)(.*)(<br \/>)/', ' <a href="\\1\\2" target="_blank">\\1\\2</a>\\3', $html);
//$html = preg_replace('/\s(\w+:\/\/)(\S+)/', ' <a href="\\1">\\1\\2</a>', $html);

// start building output page
// add page header
$output =<<< HEADER
<html>
<head>
<style>
.slug {font-size: 15pt; font-weight: bold}
.byline { font-style: italic }
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
function openUrls()
{
		    $('a').each(function(){ window.open($(this).attr('href'),'_blank'); });
}
</script>
</head>
<body>
<input type="button" onclick="javascript:openUrls()" value='Open all Urls' />
HEADER;

// add page content
$output .= "<div class='slug'>$slug</div>";
//$output .= "<div class='byline'>By $byline</div><p />";
$output .= "<div>$html</div>";

// add page footer
$output .=<<< FOOTER
</body>
</html>
FOOTER;

// display in browser
//echo $output;

// AND/OR

// write output to a new .html file
//file_put_contents(basename($output_path, substr($output_path, strpos($output_path, '.'))) . ".html", $output) or die("Cannot write file");
file_put_contents($output_path . basename($source, ".txt") . ".html", $output) or die("Cannot write file");
?>
