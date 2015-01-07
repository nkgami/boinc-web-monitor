#!/usr/local/rbenv/shims/ruby

require 'date'
require 'digest/md5'
require File.dirname(__FILE__) + '/colorcomp.rb'

#edit this section for your environment
pathProjectlist = ARGV[0] + "projectlist.html"
pathCss = ARGV[0] + "boinc.css"
#if this is the first script, true(for css file)
firstFlag = false

class Projects
	@id = -1
	@name = ""
	@masterUrl = ""
	@userName = ""
	@teamName = ""
	@resourceShare = ""
	@userTotalCredit = ""
	@userExpavgCredit = ""
	@hostTotalCredit = ""
	@hostExpavgCredit = ""
	@nrpcFailures = ""
	@masterFetchFailures = ""
	@masterFetchPending = ""
	@schedulerRpcPending = ""
	@trickleUploadPending = ""
	@attachedViaAccountManager = ""
	@ended = ""
	@suspendedViaGui = ""
	@dontRequestMoreWork = ""
	@diskUsage = ""
	@lastRpc = ""
	@projectFilesDownloaded = ""
	def initialize(id = 0)
		@id = id
	end
	attr_accessor :id, :name
	attr_accessor :masterUrl, :userName, :teamName , :resourceShare ,:userTotalCredit
	attr_accessor :userExpavgCredit, :hostTotalCredit, :hostExpavgCredit, :nrpcFailures
	attr_accessor :masterFetchFailures, :masterFetchPending, :schedulerRpcPending
	attr_accessor :trickleUploadPending, :attachedViaAccountManager, :ended
	attr_accessor :suspendedViaGui, :dontRequestMoreWork, :diskUsage
	attr_accessor :lastRpc, :projectFilesDownloaded
end

projectlist = []
tproject = nil
projectflag = false
while str = STDIN.gets
	if str.include?("-----------")
		task_id = str.split(")")[0]
		tproject = Projects.new()
		tproject.id = task_id
		projectflag = true
	end
	if projectflag
		if str.include?("name:") && !str.include?("user_name:") && !str.include?("team_name:")
			tproject.name = str.gsub(/name:/,"").strip
		elsif str.include?("master URL:")
			tproject.masterUrl = str.gsub(/master URL:/,"").strip
		elsif str.include?("user_name:")
			tproject.userName = str.gsub(/user_name:/,"").strip
		elsif str.include?("team_name:")
			tproject.teamName = str.gsub(/team_name:/,"").strip
		elsif str.include?("resource share:")
			tproject.resourceShare = str.gsub(/resource share:/,"").strip
		elsif str.include?("user_total_credit:")
			tproject.userTotalCredit = str.gsub(/user_total_credit:/,"").strip
		elsif str.include?("user_expavg_credit:")
			tproject.userExpavgCredit = str.gsub(/user_expavg_credit:/,"").strip
		elsif str.include?("host_total_credit:")
			tproject.hostTotalCredit = str.gsub(/host_total_credit:/,"").strip
		elsif str.include?("host_expavg_credit:")
			tproject.hostExpavgCredit = str.gsub(/host_expavg_credit:/,"").strip
		elsif str.include?("nrpc_failures:")
			tproject.nrpcFailures = str.gsub(/nrpc_failures:/,"").strip
		elsif str.include?("master_fetch_failures:")
			tproject.masterFetchFailures = str.gsub(/master_fetch_failures:/,"").strip
		elsif str.include?("master fetch pending:")
			tproject.masterFetchPending = str.gsub(/master fetch pending:/,"").strip
		elsif str.include?("scheduler RPC pending:")
			tproject.schedulerRpcPending = str.gsub(/scheduler RPC pending:/,"").strip
		elsif str.include?("trickle upload pending:")
			tproject.trickleUploadPending = str.gsub(/trickle upload pending:/,"").strip
		elsif str.include?("attached via Account Manager:")
			tproject.attachedViaAccountManager = str.gsub(/attached via Account Manager:/,"").strip
		elsif str.include?("ended:")
			tproject.ended = str.gsub(/ended:/,"").strip
		elsif str.include?("suspended via GUI:")
			tproject.suspendedViaGui = str.gsub(/suspended via GUI:/,"").strip
		elsif str.include?("don't request more work:")
			tproject.dontRequestMoreWork = str.gsub(/don't request more work:/,"").strip
		elsif str.include?("disk usage:")
			tproject.diskUsage = str.gsub(/disk usage:/,"").strip
		elsif str.include?("last RPC:")
			tproject.lastRpc = str.gsub(/last RPC:/,"").strip
		elsif str.include?("project files downloaded:")
			tproject.projectFilesDownloaded = str.gsub(/project files downloaded:/,"").strip
			projectflag = false
			projectlist.push(tproject)
		end
	end
end
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

now = Time.now
nowStr = now.strftime("%Y/%m/%d %H:%M:%S")
html = <<"EOS"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="refresh" content="60">
<link rel="stylesheet" type="text/css" href="boinc.css"/> 
<link rel="stylesheet" type="text/css" href="./js/style.css"/> 
<script src="./js/jquery.min.js"></script>
<script src="./js/tsort.min.js"></script>
<script>
  $(document).ready(function() {
    $('table.tableSorter').tableSort({
        animation : 'none',
        speed: 0,
				distance: '200px',
				delay: 50
    });
  });
</script>
<title>Project List</title>
</head>
<body>
<h2>Project List</h2>
Last update:#{nowStr}
<table class="tableSorter">
<tr class="header"><th>ID</th><th>name</th><th>total(user)</th><th>average(user)</th><th>total(host)</th><th>average(host)</th><th>project Url</th></tr>
EOS
projectlist.each do |projects|
	if projects.id.to_i < 0
		next
	end
	cc = ColorComp.new(projects.masterUrl,"000000")
	color = cc.getcolor()
	css += <<"EOS"
tr.project-#{color}{
	background-color:\##{color};
	margin-bottom:2px;
}
EOS
	html += "<tr class=\"project-#{color}\">"
	html += "<td>#{projects.id}</td>"
	html += "<td>#{projects.name}</td>"
	html += "<td>#{projects.userTotalCredit}</td>"
	html += "<td>#{projects.userExpavgCredit}</td>"
	html += "<td>#{projects.hostTotalCredit}</td>"
	html += "<td>#{projects.hostExpavgCredit}</td>"
	html += "<td>#{projects.masterUrl}</td>"
	html += "</tr>\n"
end
html += <<"EOS"
</table>
</body>
</html>
EOS
open(pathProjectlist, "w") {|f| f.write html}
open(pathCss, "w") {|f| f.write css}
