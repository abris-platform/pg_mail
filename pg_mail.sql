--CREATE LANGUAGE pltclu;
create or replace function pg_mail(text, text, text, text, text default '') returns int4 as '
set mailfrom $1
set mailto $2
set mailsubject $3
set mailmessage $4
set mailmessage_html $5
if {$mailmessage ne "" && $mailmessage_html ne ""} {
	set multipart true
} else {
	set multipart false
}
set myHost "<<yourmailserver>>"
set myPort 25
set mySock [socket $myHost $myPort]

fileevent $mySock writable [list svcHandler $mySock]
fconfigure $mySock -buffering line
puts $mySock "HELO <<yourdatabaseaddress>>"
gets $mySock name
puts $mySock "MAIL FROM: $mailfrom"
gets $mySock name
puts $mySock "RCPT TO: $mailto"
gets $mySock name
puts $mySock "DATA"
gets $mySock name
puts $mySock "Date: [clock format [clock seconds] -format {%a, %d %b %Y %H:%M:%S +0000} -gmt true]"
puts $mySock "From: $mailfrom"
puts $mySock "To: $mailto"
puts $mySock "Subject: $mailsubject"
puts $mySock "MIME-Version: 1.0"
if {$multipart} {
	puts $mySock {Content-type: multipart/mixed; boundary="just_a_simple_boundary"}
}
if {$mailmessage ne ""} {
	if {$multipart} {puts $mySock "--just_a_simple_boundary"}
	puts $mySock "Content-type: text/plain; charset=UTF-8"
	puts $mySock "Content-Transfer-Encoding: 8bit"
	puts $mySock ""
	puts $mySock "$mailmessage"
}
if {$mailmessage_html ne ""} {
	if {$multipart} {puts $mySock "--just_a_simple_boundary"}
	puts $mySock "Content-type: text/html; charset=UTF-8"
	puts $mySock "Content-Transfer-Encoding: 8bit"
	puts $mySock ""
	puts $mySock "$mailmessage_html"
}
if {$multipart} {puts $mySock "--just_a_simple_boundary--"}
puts $mySock "\x13\x10"
puts $mySock "."
puts $mySock "\x13\x10"
gets $mySock name
puts $mySock "QUIT"
gets $mySock name
close $mySock
return 1'
language 'pltclu';
