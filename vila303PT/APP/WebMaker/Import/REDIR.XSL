<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">
<xsl:output doctype-public="-//W3C//DTD HTML 4.01 STRICT//EN" encoding="UTF-8" />
<xsl:template match="/PAGE">
<html>
<head>
<title>Redirect</title>
</head>
<body>
Redirecting to <span id="target"><xsl:value-of select="INPUT[1]/@VALUE" /></span>...
<script>
  window.location.href = document.getElementById('target').innerHTML;
</script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
