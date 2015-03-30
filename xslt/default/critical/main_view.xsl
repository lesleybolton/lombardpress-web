<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
  <xsl:output method="html"/>
  <!-- params -->  
  <xsl:param name="default-ms-image">reims</xsl:param>
  
  <!-- variables-->
  <xsl:variable name="itemid"><xsl:value-of select="/tei:TEI/tei:text/tei:body/tei:div/@xml:id"/></xsl:variable>
  
  <!-- root template -->
  <xsl:template match="/">
    <!-- title/publication info -->
    <xsl:call-template name="teiHeaderInfo"/>
    
    <!-- transform body of text -->
    <xsl:apply-templates/>
    
    <!-- prepare footnotes -->
    <div class="footnotes">
      <h1>Apparatus Fontium</h1>
      <xsl:call-template name="footnotes"/>
    </div>
    <!-- prepare variants -->
    <div class="variants">
      <h1>Apparatus Criticus</h1>
      <xsl:call-template name="variants"/>
    </div>
  </xsl:template>
  
  <!-- clear teiHeader -->
  <xsl:template match="tei:teiHeader"></xsl:template>
  
  <!-- heading template -->
  <xsl:template match="tei:head">
    <xsl:variable name="number" select="count(ancestor::tei:div)" />
    <xsl:variable name="id"><xsl:value-of select="@xml:id"/></xsl:variable>
    
    <xsl:element name="h{$number}"><xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:div">
    <div id="{@xml:id}" class="plaoulparagraph"><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <xsl:variable name="pn"><xsl:number level="any" from="tei:text"/></xsl:variable>
    <xsl:variable name="pid"><xsl:value-of select="@xml:id"/></xsl:variable>
    
    <div class='para_wrap' id='pwrap_{@xml:id}' style="clear: both; float: none;">
      <p id="{@xml:id}" class="plaoulparagraph"><span id="pn{$pn}" class="paragraphnumber"><xsl:number level="any" from="tei:text"/></span><xsl:apply-templates/><span class="paragraphmenu"><a class="paragraphmenu"><span class="glyphicon glyphicon-menu-hamburger"/> Menu</a></span></p>
      <nav class="navbar navbar-default paradiv" id="menu_{@xml:id}" style="display: none;">
        <div class="navbar-header navbar-right">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#para-navbar-collapse-{$pid}">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
        </div>
        <div class="collapse navbar-collapse" id="para-navbar-collapse-{$pid}">
          <ul class="nav navbar-nav">
            <li><a class="js-show-comments-window">Comments</a></li>
            <li><a class="js-show-para-image-window" data-itemid="{$itemid}" data-pid="{@xml:id}" data-msslug="{$default-ms-image}">Ms Images</a></li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Paragraph Text Tools<span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu">
                <li><a class='js-show-xml'>Test1</a></li>
                <li><a class='js-show-text-comparison'>Test2</a></li>
                <li><a class='js-show-variants'>Test2</a></li>
              </ul>
            </li>
            <li><a>How To Cite</a></li>
          </ul>
        </div>
      </nav>
    </div>
  </xsl:template>
  
  <!-- name template -->
  <xsl:template match="tei:name">
    <xsl:variable name="ref"><xsl:value-of select="./@ref"/></xsl:variable>
    <xsl:variable name="refID"><xsl:value-of select="substring-after($ref, '#')"/></xsl:variable>
    <span class="lbp-name" data-name="{$refID}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- title template -->
  <xsl:template match="tei:title">
    <xsl:variable name="ref"><xsl:value-of select="./@ref"/></xsl:variable>
    <xsl:variable name="refID"><xsl:value-of select="substring-after($ref, '#')"/></xsl:variable>
    <span class="lbp-title" data-title="{$refID}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- quote template -->
  <xsl:template match="tei:quote">
      <xsl:variable name="quoterefid" select="translate(./@ana, '#', '')"/>
    <span id="{@xml:id}" class="lbp-quote" data-quoterefid="{$quoterefid}">
      <xsl:text/>
      <xsl:apply-templates/>
      <xsl:text/>
    </span>
  </xsl:template>
  
  <!-- ref template -->
  <xsl:template match="tei:ref">
    <xsl:variable name="refid" select="translate(./@ana, '#', '')"/>
    <span id="{@xml:id}" class="lbp-ref" data-quoterefid="{$refid}">
      <xsl:text/>
      <xsl:apply-templates/>
      <xsl:text/>
    </span>
  </xsl:template>
  
  <!-- unclear template -->
  <xsl:template match="tei:unclear">
    <xsl:variable name="text"><xsl:value-of select="./text()"/></xsl:variable>
    <span style="background-color: #F3F3F3;" class="unclear" data-text="{$text}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- app template -->
  <xsl:template match="tei:app">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- clear rdg template -->
  <xsl:template match="tei:rdg"></xsl:template>
  
  <!-- clear note desc bib template -->
  <xsl:template match=" tei:note | tei:desc | tei:bibl"></xsl:template>
  
  <xsl:template match="tei:cb">
    <xsl:variable name="hashms"><xsl:value-of select="@ed"/></xsl:variable>
    <xsl:variable name="ms"><xsl:value-of select="translate($hashms, '#', '')"/></xsl:variable>
    <xsl:variable name="fullcn"><xsl:value-of select="@n"/></xsl:variable>
    <xsl:variable name="length"><xsl:value-of select="string-length($fullcn)-2"/></xsl:variable>
    <xsl:variable name="folionumber"><xsl:value-of select="substring($fullcn,1, $length)"/></xsl:variable>
    <xsl:variable name="side_column"><xsl:value-of select="substring($fullcn, $length+1)"/></xsl:variable>
    <xsl:variable name="just_column"><xsl:value-of select="substring($fullcn, $length+2, 1)"/></xsl:variable>
    <xsl:variable name="justSide"><xsl:value-of select="substring($fullcn, $length+1, 1)"/></xsl:variable>
    <span class="lbp-folionumber">
      <xsl:value-of select="$ms"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$folionumber"/>
      <xsl:value-of select="$side_column"/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:pb">
    <xsl:variable name="hashms"><xsl:value-of select="@ed"/></xsl:variable>
    <xsl:variable name="ms"><xsl:value-of select="translate($hashms, '#', '')"/></xsl:variable>
    <xsl:variable name="fullcn"><xsl:value-of select="@n"/></xsl:variable>
    <!-- this variable gets length of Ms abbrev and folio number after substracting side -->
    <xsl:variable name="length"><xsl:value-of select="string-length($fullcn)-1"/></xsl:variable>
    <!-- this variable separates isolates folio number by skipping msAbbrev and then not including side designation -->
    <xsl:variable name="folionumber"><xsl:value-of select="substring($fullcn,1, $length)"/></xsl:variable>
    <!-- this desgination gets side by skipping lenghth of msAbbrev and folio number and then getting the first character that occurs -->
    <xsl:variable name="justSide"><xsl:value-of select="substring($fullcn, $length+1, 1)"/></xsl:variable>
    <span class="lbp-folionumber">
      <xsl:value-of select="$ms"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$folionumber"/>
      <xsl:value-of select="$justSide"/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:supplied">
    <span class="lbp-supplied">[<xsl:apply-templates></xsl:apply-templates>]</span>
  </xsl:template>
    
  <!-- notes template -->
  <xsl:template match="tei:bibl">
    <xsl:variable name="id">
      <xsl:number count="//tei:bibl" level="any" format="a"/></xsl:variable>
      <xsl:text> </xsl:text>
      <a href="#footnote{$id}" name="footnotereference{$id}" class="footnote">
        <sup>[<xsl:value-of select="$id"/>]</sup>
      </a>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <!-- app template -->
  <xsl:template match="tei:app">
    <span class="lemma"><xsl:apply-templates select="tei:lem"/></span>
    <xsl:variable name="id"><xsl:number count="//tei:app" level="any" format="1"/></xsl:variable>
    <xsl:text> </xsl:text>
    <sup><a href="#variant{$id}" name="variantreference{$id}" class="appnote">[<xsl:value-of select="$id"/>]</a></sup>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <!-- clear apparatus editorial notes -->
  <xsl:template match="tei:app/tei:note"></xsl:template>
      
  <!-- named templates -->
  
  <!-- header info -->
  <xsl:template name="teiHeaderInfo">
    <div id="lbp-pub-info">
      <h2><span id="sectionTitle" class="sectionTitle"><xsl:value-of select="//tei:titleStmt/tei:title"/></span></h2>
      <h4>By <xsl:value-of select="//tei:titleStmt/tei:author"/></h4>
      <p>Edited by: 
        <xsl:for-each select="//tei:titleStmt/tei:editor">
          <span><xsl:value-of select="//tei:titleStmt/tei:editor"/></span><xsl:text/>  
        </xsl:for-each>
      </p>
      <p>Edition: <span id="editionNumber"><xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/@n"/></span> | <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:date"/></p>
      <p>Original Publication: <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher"/>, <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace"/>, <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/></p>
      <p>License Availablity: <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/@status"/>, <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:p"/> </p>
      <p style="display: none;"><span id="filestem"><xsl:value-of select="//tei:body/tei:div/@xml:id"/></span></p>
      
    </div>
  </xsl:template>  
  
  <xsl:template name="footnotes">
    <ul>
      <xsl:for-each select="//tei:bibl">
      <xsl:variable name="id"><xsl:number count="//tei:bibl" level="any" format="a"/></xsl:variable>
      <li id="lbp-footnote{$id}">
        <a href="#lbp-footnotereference{$id}">
          <xsl:copy-of select="$id"/>
        </a> -- <xsl:apply-templates/>
      </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  <xsl:template name="variants">
    <ul class="variantlist">
      <xsl:for-each select="//tei:app">
        <xsl:variable name="id">
          <xsl:number count="//tei:app" level="any" format="1"/>
        </xsl:variable>
        
        <li id="lbp-variant{$id}">
          <a href="#lbp-variantreference{$id}">
            <xsl:copy-of select="$id"/>
          </a>
          <text> -- </text>
          
          <xsl:value-of select="tei:lem"/>
            <xsl:text> ] </xsl:text>                         
          <xsl:for-each select="tei:rdg">
            <xsl:choose>
              <xsl:when test="contains(@type, 'om.')">
                <xsl:value-of select="."/><xsl:text> </xsl:text>
                <em>om.</em><xsl:text> </xsl:text>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text>   </xsl:text>
              </xsl:when>
              <xsl:when test="./@type='corrAddition'"> <!-- eventually the "contains" options should be removed as "corrDeletion, corrAddition" becomes the standard in the app schema -->
                <xsl:value-of select="."/><xsl:text> </xsl:text>
                <em>add.</em><xsl:text> </xsl:text>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text>   </xsl:text>
              </xsl:when>
              <xsl:when test="./@type='corrDeletion'">
                <xsl:value-of select="tei:corr/tei:del"/><xsl:text> </xsl:text>
                <em>add. sed del.</em><xsl:text> </xsl:text>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text>   </xsl:text>
              </xsl:when>
              <xsl:when test="./@type='corrReplace'">
                <xsl:value-of select="tei:corr/tei:add"/><xsl:text> </xsl:text>
                <em>corr. ex</em><xsl:text> </xsl:text>
                <xsl:value-of select="tei:corr/tei:del"/><xsl:text> </xsl:text>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text>   </xsl:text>
              </xsl:when>
              <xsl:when test="contains(@type, 'rep.')">
                <xsl:text> </xsl:text>
                <em>rep.</em>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:when test="contains(@type, 'intextu')">
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/><xsl:text> </xsl:text>
                <em>in textu</em><xsl:text> </xsl:text>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/><xsl:text> </xsl:text>
                <xsl:value-of select="translate(@wit, '#', '')"/><xsl:text>   </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </li>  
      </xsl:for-each>
    </ul>
  </xsl:template>

</xsl:stylesheet>
