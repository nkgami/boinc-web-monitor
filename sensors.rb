#!/usr/local/rbenv/shims/ruby

#edit this section for your environment
pathProjectlist = ARGV[0] + "sensors.html"
pathCss = ARGV[0] + "boinc.css"
#if this is the first script, true(for css file)
firstFlag = false

htmlBase = "<div class=\"sensors\">"
while str = STDIN.gets
	htmlBase += str + "<br>"
end
htmlBase += "</div>"

if firstFlag
	css = <<"EOS"
body{
	background-color: #87ceeb;
}

tr.header{
	background-color: #d3d3d3;
	margin-bottom:2px;
}

tr.normal{
	background-color: #ffffff;
	margin-bottom:2px;
}
EOS
else
	css = File.read(pathCss, :encoding => Encoding::UTF_8)
end
css += <<"EOS"
div.sensors{
	background-color: #e0e0e0;
}
EOS

now = Time.now
nowStr = now.strftime("%Y/%m/%d %H:%M:%S")
html = <<"EOS"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="refresh" content="60">
<link rel="stylesheet" type="text/css" href="boinc.css"/> 
<title>Sensors</title>
</head>
<body>
<h2>Sensors</h2>
Last update:#{nowStr}
EOS
html += htmlBase
html += <<"EOS"
</body>
</html>
EOS
open(pathProjectlist, "w") {|f| f.write html}
open(pathCss, "w") {|f| f.write css}
