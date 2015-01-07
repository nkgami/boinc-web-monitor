#!/usr/local/rbenv/shims/ruby

require 'date'
require 'digest/md5'
require File.dirname(__FILE__) + '/colorcomp.rb'

#edit this section for your environment
pathTasklist = ARGV[0] + "tasklist.html"
pathCss = ARGV[0] + "boinc.css"
#if this is the first script, true(for css file)
firstFlag = true

class Tasks
	@id = -1
	@name = ""
	@wuName = ""
	@projectUrl = ""
	@reportDeadline = ""
	@readyToReport = ""
	@gotServerAck = ""
	@finalCpuTime = ""
	@state = ""
	@schedulerState = ""
	@exitStatus = ""
	@signal = ""
	@suspendedViaGui = ""
	@activeTaskState = ""
	@appVersionNum = ""
	@checkpointCpuTime = ""
	@currentCpuTime = ""
	@fractionDone = ""
	@swapSize = ""
	@workingSetSize = ""
	@estimatedCpuTimeRemaining = ""
	def initialize(id = 0)
		@id = id
	end
	attr_accessor :id, :name
	attr_accessor :wuName, :projectUrl, :reportDeadline, :readyToReport, :gotServerAck
	attr_accessor :finalCpuTime, :state, :schedulerState, :exitStatus, :signal
	attr_accessor :suspendedViaGui, :activeTaskState, :appVersionNum, :checkpointCpuTime
	attr_accessor :currentCpuTime, :fractionDone, :swapSize, :workingSetSize, :estimatedCpuTimeRemaining
end

tasklist = []
ttask = nil
taskflag = false
while str = STDIN.gets
	if str.include?("======== Tasks ========")
		taskflag = true
	end
	if taskflag
		if str.include?("-----------")
			task_id = str.split(")")[0]
			ttask = Tasks.new()
			ttask.id = task_id
		elsif str.include?("name:") && !str.include?("WU name:")
			ttask.name = str.gsub(/name:/,"").strip
		elsif str.include?("WU name:")
			ttask.wuName = str.gsub(/WU name:/,"").strip
		elsif str.include?("project URL:")
			ttask.projectUrl = str.gsub(/project URL:/,"").strip
		elsif str.include?("report deadline:")
			ttask.reportDeadline = str.gsub(/report deadline:/,"").strip
		elsif str.include?("ready to report:")
			ttask.readyToReport = str.gsub(/ready to report:/,"").strip
		elsif str.include?("got server ack:")
			ttask.gotServerAck = str.gsub(/got server ack:/,"").strip
		elsif str.include?("final CPU time:")
			ttask.finalCpuTime = str.gsub(/final CPU time:/,"").strip
		elsif str.include?("state:") && !str.include?("scheduler state:") && !str.include?("active_task_state:")
			ttask.state = str.gsub(/state:/,"").strip
		elsif str.include?("scheduler state:")
			ttask.schedulerState = str.gsub(/scheduler state:/,"").strip
		elsif str.include?("exit_status:")
			ttask.exitStatus = str.gsub(/exit_status:/,"").strip
		elsif str.include?("signal:")
			ttask.signal = str.gsub(/signal:/,"").strip
		elsif str.include?("suspended via GUI:")
			ttask.suspendedViaGui = str.gsub(/suspended via GUI:/,"").strip
		elsif str.include?("active_task_state:")
			ttask.activeTaskState = str.gsub(/active_task_state:/,"").strip
		elsif str.include?("app version num:")
			ttask.appVersionNum = str.gsub(/app version num:/,"").strip
		elsif str.include?("checkpoint CPU time:")
			ttask.checkpointCpuTime = str.gsub(/checkpoint CPU time:/,"").strip
		elsif str.include?("current CPU time:")
			ttask.currentCpuTime = str.gsub(/current CPU time:/,"").strip
		elsif str.include?("fraction done:")
			ttask.fractionDone = str.gsub(/fraction done:/,"").strip
		elsif str.include?("swap size:")
			ttask.swapSize = str.gsub(/swap size:/,"").strip
		elsif str.include?("working set size:")
			ttask.workingSetSize = str.gsub(/working set size:/,"").strip
		elsif str.include?("estimated CPU time remaining:")
			ttask.estimatedCpuTimeRemaining = str.gsub(/estimated CPU time remaining:/,"").strip
			tasklist.push(ttask)
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
<title>Task List</title>
</head>
<body>
<h2>Task List</h2>
Last update:#{nowStr}
<table class="tableSorter">
<tr class="header"><th>ID</th><th>WU name</th><th>state</th><th>active</th><th>report deadline</th><th>fraction done</th><th>project Url</th></tr>
EOS
tasklist.each do |tasks|
	if tasks.id.to_i < 0
		next
	end
	cc = ColorComp.new(tasks.projectUrl,"000000")
	color = cc.getcolor()
	css += <<"EOS"
tr.task-#{color}{
	background-color:\##{color};
	margin-bottom:2px;
}
EOS
	html += "<tr class=\"task-#{color}\">"
	html += "<td>#{tasks.id}</td>"
	html += "<td>#{tasks.wuName}</td>"
	html += "<td>#{tasks.state}</td>"
	html += "<td>#{tasks.activeTaskState}</td>"
	deadline = DateTime.parse(tasks.reportDeadline)
	html += "<td>#{deadline.strftime("%Y/%m/%d %H:%M:%S")}</td>"
	if tasks.state == "5" && tasks.exitStatus == "0"
		html += "<td>#{sprintf("%2.6f",100)}%</td>"
	else
		html += "<td>#{sprintf("%2.6f",((tasks.fractionDone).to_f * 100))}%</td>"
	end
	html += "<td>#{tasks.projectUrl}</td>"
	html += "</tr>\n"
end
html += <<"EOS"
</table>
</body>
</html>
EOS
open(pathTasklist, "w") {|f| f.write html}
open(pathCss, "w") {|f| f.write css}
