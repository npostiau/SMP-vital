<?php
function getFiles(){
    $files=array();
    if($dir=opendir('.')){
        while($file=readdir($dir)){
            if($file!='.' && $file!='..' && $file!=basename(__FILE__)){
                $files[]=$file;
            }   
        }
        closedir($dir);
    }
	natsort($files); //sort
    return $files;
}
?>

<html>
<head>
<title>Tools/scripts/command lines used for validation</title>
<style>
  html { font-family: sans-serif; }
  img { border: 0; }
  a { text-decoration: none; font-weight: bold; }
</style>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {inlineMath: [["$","$"]]}
});
</script>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
</head>
<body><h2>Select a file</h2>

<p style="font-size:large;">Select a CMSSW release</p>

<ul class="dir">
	<? foreach(getFiles() as $file){
		$file_name = basename($file, ".html");
		echo "<li name='$file'><a href=$file>$file_name</a></li>";
		}
	?>
</ul>

</body>
</html>
