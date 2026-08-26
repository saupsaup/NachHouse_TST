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
<link href="PLCFORM.CSS?cache=custlogv.7" rel="stylesheet" type="text/css" />
<script src="SHA1.JS?cache=custlogv.4" language="JavaScript" charset="utf-8" />
<title>Login</title>
</head>
<body onload="LoadUser()">
<xsl:attribute name="onload">
LoadUser(<xsl:value-of select="ACER/@VALUE" />);
</xsl:attribute>
<form id="noPassForm" action="LOGIN.XML" method="POST" onsubmit="return ProccessLogin(this);">
<div id="NoPassLoginSec">
<input type="hidden" name="USER" value="nopass" />
<input type="hidden" name="PASS" value="nopass" />
<input id="UNLOCK" type="button" class="theSubmit" value=""/><br />
<input id="NOPASS" type="submit" class="theSubmit border" value="Enter"/>
</div>
</form>
<form id="PassForm" action="LOGIN.XML" method="POST" onsubmit="return ProccessLogin(this);">
<div id="PassLoginSec">
<p id="pmess"><span id="message" class="cblue">Welcome and login, please.</span></p>
<div id="wrapper" class="border">
<p class="ptit"></p>
<div id="wrap">
<div class="outwrap">
<label id="username" for="USER">User name</label>
<xsl:apply-templates select='USER' />
<label id="password" for="PASS">Password</label>
<xsl:apply-templates select='PASS' />
<input id="SUBMIT" type="submit" class="theSubmit border" value="Login"/>
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
<xsl:template match='USER'>
<input placeholder="User name" type="text" class="inptext noborder" id="USER" name="USER" value="{@VALUE}" autocomplete="username" />
</xsl:template>
<xsl:template match='PASS'>
<input placeholder="Password" type="password" class="inptext noborder" id="PASS" name="PASS" value="{@VALUE}" autocomplete="current-password" />
</xsl:template>
</xsl:stylesheet>
