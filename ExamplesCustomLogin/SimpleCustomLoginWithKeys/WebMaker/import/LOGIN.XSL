<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">
<xsl:output method="html" version="5.0" encoding="UTF-8"/>
<xsl:template match='/LOGIN'>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta name="author" content="Teco a.s." />
<meta name="robots" content="noindex, nofollow" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache, must-revalidate" />
<meta http-equiv="expires" content="0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable = no" />
<link href="PLCFORM.CSS?cache=keycustlogkeysv.5" rel="stylesheet" type="text/css" />
<script src="SHA1.JS?cache=keycustlogkeysv.5" language="JavaScript" charset="utf-8" />
<title>Login</title>
</head>
<body onload="LoadUser()">
<xsl:attribute name="onload">
LoadUser(<xsl:value-of select="ACER/@VALUE" />);
</xsl:attribute>
<form id="PassForm" action="LOGIN.XML" method="POST" onsubmit="return ProccessLogin(this);">
<div id="PassLoginSec">
<p id="pmess"><span id="message" class="cblue">Welcome and login, please.</span></p>
<div id="wrapper" class="border">
<p class="ptit"></p>
<div id="wrap">
<div class="outwrap">
<input type="text" class="inptext noborder" id="SHOW" name="SHOW" value="" readonly="true"/>
<input placeholder="User name" type="text" class="hidden inptext noborder" id="USER" name="USER" value="" />
<input placeholder="Password" type="password" class="hidden inptext noborder" id="PASS" name="PASS" value="" />
<br />
<input type="button" class="theButton border" value="7" onclick="AddVal('7')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="8" onclick="AddVal('8')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="9" onclick="AddVal('9')" />
<br />
<input type="button" class="theButton border" value="4" onclick="AddVal('4')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="5" onclick="AddVal('5')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="6" onclick="AddVal('6')" />
<br />
<input type="button" class="theButton border" value="1" onclick="AddVal('1')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="2" onclick="AddVal('2')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="3" onclick="AddVal('3')" />
<br />
<input type="button" class="theButton border" value="0" onclick="AddVal('0')" /><span class="theSpan">&#xA0;</span>
<input type="button" class="theButton border" value="Cancel" onclick="AddVal('')"/><span class="theSpan">&#xA0;</span>
<input id="SUBMIT" type="submit" class="theButton border" value="Login" />
</div>
</div>
<p class="ptit">
</p>
</div>
</div>
</form>
<script type="text/javascript">//<![CDATA[
StyleForMob();
if (document.createElement("input").placeholder == undefined) {
    var labels = document.getElementsByTagName("label");
    for (i = 0; i < labels.length; i++) {
        labels[i].style.display = "inline"
    }
}
//]]></script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
