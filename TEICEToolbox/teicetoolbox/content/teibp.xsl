<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
	xmlns:exsl="http://exslt.org/common"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:x="http://www.w3.org/1999/xhtml"
	extension-element-prefixes="exsl msxsl"
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="xsl tei xd eg fn #default x exsl">
	<xd:doc  scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Nov 17, 2011</xd:p>
			<xd:p><xd:b>Author:</xd:b> John A. Walsh</xd:p>
			<xd:p>TEI Boilerplate stylesheet: Copies TEI document, with a very few modifications
				into an html shell, which provides access to javascript and other features from the
				html/browser environment.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:include href="xml-to-string.xsl"/>

	<xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>
	
	<xsl:param name="teibpHome" select="'http://dcl.slis.indiana.edu/teibp/'"/>
	<xsl:param name="inlineCSS" select="true()"/>
	<xsl:param name="includeToolbox" select="true()"/>
	<xsl:param name="includeAnalytics" select="true()"/>
	<xsl:param name="displayPageBreaks" select="true()"/>
	
	
	
	<!-- special characters -->
	<xsl:param name="quot"><text>"</text></xsl:param>
	<xsl:param name="apos"><text>'</text></xsl:param>
	
	<!-- interface text -->
	<xsl:param name="pbNote"><text>f. </text></xsl:param>
	<xsl:param name="altTextPbFacs"><text>view page image(s)</text></xsl:param>
	
	<!-- parameters for file paths or URLs -->
	<!-- modify filePrefix to point to files on your own server, 
		or to specify a relatie path, e.g.:
		<xsl:param name="filePrefix" select="'http://dcl.slis.indiana.edu/teibp'"/>
		
	-->
	<xsl:param name="filePrefix" select="'..'"/>
	
	<xsl:param name="teibpCSS" select="concat($filePrefix,'/css/teibp.css')"/>
	<xsl:param name="customCSS" select="concat($filePrefix,'/css/custom.css')"/>
	<xsl:param name="jqueryJS" select="concat($filePrefix,'/js/jquery/jquery.min.js')"/>
	<xsl:param name="jqueryBlockUIJS" select="concat($filePrefix,'/js/jquery/plugins/jquery.blockUI.js')"/>
	<xsl:param name="teibpJS" select="concat($filePrefix,'/js/teibp.js')"/>
	<xsl:param name="theme.default" select="concat($filePrefix,'/css/teibp.css')"/>
	<xsl:param name="theme.sleepytime" select="concat($filePrefix,'/css/sleepy.css')"/>
	<xsl:param name="theme.terminal" select="concat($filePrefix,'/css/terminal.css')"/>
	
	<!-- global variables -->
	<xsl:variable name="listWitnesses">
		<xsl:for-each select="/tei:TEI/tei:teiHeader//tei:listWit/tei:witness">
			<xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
			<xsl:value-of select="@xml:id"/>
		</xsl:for-each>				
	</xsl:variable>			
	
	<xsl:variable name="tokens1">
		<xsl:call-template name="tokenizeWit">
			<xsl:with-param name="srcWit" select="normalize-space($listWitnesses)"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="listWitnesses2">
		<xsl:for-each select="exsl:node-set($tokens1)//x:*"> 
			<xsl:sort select="." data-type="text" order="ascending"/>
			<xsl:if test="not(position() = 1)">
				<xsl:text>|</xsl:text>
			</xsl:if>
			<xsl:value-of select="."></xsl:value-of>            
		</xsl:for-each>
	</xsl:variable>		
	
	
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Match document root and create and html5 wrapper for the TEI document, which is
				copied, with some modification, into the HTML document.</xd:p>
		</xd:desc>
	</xd:doc>

	<xsl:key name="ids" match="//*" use="@xml:id"/>

	<xsl:template match="/" name="htmlShell" priority="98">
		
				<xsl:if test="$includeToolbox = true()">
					<xsl:call-template name="teibpToolbox"/>
				</xsl:if>
				<div id="tei_wrapper">					
					<xsl:apply-templates/>
				</div>
				<xsl:copy-of select="$htmlFooter"/>
	</xsl:template>
	
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Basic copy template, copies all nodes from source XML tree to output
				document.</xd:p>
		</xd:desc>
	</xd:doc>
	
	<xsl:template match="@*">
		<!-- copy select elements -->
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Template for elements, which adds an @xml:id to every element. Existing @xml:id
				attributes are retained unchanged.</xd:p>
		</xd:desc>
	</xd:doc>

	<xsl:template match="*"> 
		<xsl:element name="{local-name()}">
			<xsl:call-template name="addID"/>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Marjorie fiddling with TEIPB: beginning -->


	<xsl:template match="tei:listWit">
		<p class="listWit">
<ul>		<xsl:for-each select="./tei:witness">
			<li><xsl:value-of select="@xml:id"/> - <xsl:apply-templates/></li>
		</xsl:for-each>		
</ul>	</p>
	</xsl:template>
		
	<xsl:template match="tei:app">
		<xsl:param name="srcWit"></xsl:param>
		
		<xsl:element name="span">
			<xsl:variable name="listValueWit">
				<xsl:for-each select="child::node()[@wit] | ./tei:rdgGrp/child::node()[@wit]">
					<xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
					<xsl:value-of select="translate(@wit,'#','')"/>
				</xsl:for-each>
			</xsl:variable>
			
			<xsl:variable name="tokens2">
				<xsl:call-template name="tokenizeWit">
					<xsl:with-param name="srcWit" select="normalize-space($listValueWit)"/>
				</xsl:call-template>
			</xsl:variable>
			
			<!-- iterate over each token -->
			<xsl:variable name="listValueWit2">
				<xsl:for-each select="exsl:node-set($tokens2)//x:*"> 
					<xsl:sort select="." data-type="text" order="ascending"/>
					<xsl:if test="not(position() = 1)">
						<xsl:text>|</xsl:text>
					</xsl:if>
					<xsl:value-of select="."></xsl:value-of>            
				</xsl:for-each>
			</xsl:variable>	
			
			<!-- check if maybe witnesses are mentioned more than once -->
			
			<xsl:variable name="listValueWit3">
				<xsl:for-each select="exsl:node-set($tokens2)//x:*"> 							
					<xsl:sort select="." data-type="text" order="ascending"/>
					<xsl:if test="not(text() = preceding::text())">
						<xsl:if test="not(position() = 1)">
							<xsl:text>|</xsl:text>
						</xsl:if>
						<xsl:value-of select="text()"/>
					</xsl:if>            																		
				</xsl:for-each>
			</xsl:variable>	


			<xsl:choose>
				<xsl:when test="$listValueWit3 = $listWitnesses2 and $listValueWit2 != $listWitnesses2">
					<!-- This app entry uses all the available witnesses -->
					<xsl:attribute name="class">app doubles</xsl:attribute>					
					<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>					
				</xsl:when>
				<xsl:when test="$listValueWit2 = $listWitnesses2">
					<!-- This app entry uses all the available witnesses -->
					<xsl:attribute name="class">app</xsl:attribute>					
					<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>
				</xsl:when>
				<xsl:when test="./tei:lem[not(@wit)]">
					<!-- This entry uses a lemma without @wit, it is therefore impossible to check whether all witnesses are used (the lemma contains, by default, the text 
					supposed to be written in mss not listed in the @wit of the rdg). Let us consider that this app has already been checked by the editor and is therefore OK.
					UNLESS it has no @wit at all in the rdg
					-->
					<xsl:choose>
						<xsl:when test="$listValueWit3 = $listValueWit2 and $listValueWit2 = ''">
							<xsl:attribute name="class">app incomplete doubles</xsl:attribute>
							<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>							
						</xsl:when>
						<xsl:when test="$listValueWit2 = ''">
							<xsl:attribute name="class">app incomplete</xsl:attribute>
							<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>							
						</xsl:when>
						<xsl:when test="$listValueWit3 = $listWitnesses2">
						<xsl:attribute name="class">app doubles</xsl:attribute>
						<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">app</xsl:attribute>					
							<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- Test if this is a subvariant (app within a rdg or lem) -->
					<xsl:choose>
						<xsl:when test="ancestor::tei:rdg or ancestor::tei:lem">
							<xsl:variable name="tokens3">
								<xsl:call-template name="tokenizeWit">
									<xsl:with-param name="srcWit" select="normalize-space(translate(concat(ancestor::tei:rdg/@wit, ancestor::tei:lem/@wit), '#', ''))"/>
								</xsl:call-template>
							</xsl:variable>					
							<xsl:variable name="listValueSubWit">
								<xsl:for-each select="exsl:node-set($tokens3)//x:*"> 
									<xsl:sort select="." data-type="text" order="ascending"/>
									<xsl:if test="not(position() = 1)">
										<xsl:text>|</xsl:text>
									</xsl:if>
									<xsl:value-of select="."></xsl:value-of>            
								</xsl:for-each>
							</xsl:variable>
							
							<xsl:choose>
								<xsl:when test="$listValueSubWit = $listValueWit2">
									<!-- This app contains all the witnesses used in the rdg or lem to which it belongs -->
									<xsl:attribute name="class">app</xsl:attribute>	
									<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<!-- This app entry does NOT use all the available witnesses, it is incomplete -->
									<xsl:attribute name="class">app incomplete</xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$listValueWit3 != $listValueWit2">
									<xsl:attribute name="class">app incomplete doubles</xsl:attribute>		
									<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
								<!-- This app entry does NOT use all the available witnesses, it is incomplete -->
								<xsl:attribute name="class">app incomplete</xsl:attribute>		
								<xsl:attribute name="title"><xsl:value-of select="$listValueWit2"></xsl:value-of></xsl:attribute>
								</xsl:otherwise>								
							</xsl:choose>
						</xsl:otherwise>						
					</xsl:choose>
					
				</xsl:otherwise>
			</xsl:choose>
			
			
			
			
		<xsl:choose>
			
			<xsl:when test="tei:lem">
				
				<span class="lem">
					<xsl:attribute name="class">simpleLem</xsl:attribute>
					<xsl:attribute name="id">lem_<xsl:number count="tei:lem" level="any"/></xsl:attribute>
					<xsl:apply-templates select="tei:lem"/>		
				</span>
				
				<span class="call">
					<xsl:element name="a">
						<xsl:attribute name="class">critApp</xsl:attribute>
						<xsl:attribute name="onmouseover">document.getElementById('app_<xsl:number count="tei:lem" level="any"/>').style.visibility = 'visible'; document.getElementById('lem_<xsl:number count="tei:lem" level="any"/>').className = 'highlightLem';</xsl:attribute>
						<xsl:attribute name="onmouseout">document.getElementById('app_<xsl:number count="tei:lem" level="any"/>').style.visibility = 'hidden'; document.getElementById('lem_<xsl:number count="tei:lem" level="any"/>').className = 'simpleLem';</xsl:attribute>
						<sup>&#8593;</sup>
					</xsl:element>
				</span>
				
				<xsl:element name="span">
					<xsl:attribute name="class">variants</xsl:attribute>
					<xsl:attribute name="id">app_<xsl:number count="tei:lem" level="any"/></xsl:attribute>
					
					<b><xsl:apply-templates select="tei:lem"/>
						<xsl:if test="tei:lem/@wit">
							&#160;<i><xsl:value-of select="translate(tei:lem/@wit,'#','')"/></i>
						</xsl:if>
						]</b>&#160;
					
					<xsl:for-each select="tei:rdg">
						<xsl:apply-templates/>
						<xsl:if test="../tei:lem = ''">&#160;<i>add.</i></xsl:if>
						<xsl:if test=". = ''"><i>om.</i></xsl:if>
						&#160;<i><xsl:value-of select="translate(@wit,'#','')"/></i>
						<xsl:choose>
							<xsl:when test="following-sibling::*">; </xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					
					
					<xsl:for-each select="./tei:rdgGrp">
						<b>((</b>
						
						<xsl:for-each select="tei:lem">
							<u>										
								<xsl:choose>
									<xsl:when test=". = ''"><i>-</i></xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates/>
									</xsl:otherwise>
								</xsl:choose>
								&#160;<span class="wit"><xsl:value-of select="translate(@wit,'#','')"/></span>
							</u>
							<xsl:choose>
								<xsl:when test="following-sibling::*">; </xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>								
						</xsl:for-each>
						
						<xsl:for-each select="tei:rdg">
							<xsl:apply-templates/>
							<xsl:if test=". = ''"><i>-</i></xsl:if>
							&#160;<span class="wit"><xsl:value-of select="translate(@wit,'#','')"/></span>
							<xsl:choose>
								<xsl:when test="following-sibling::*">; </xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>																
						</xsl:for-each>
						<b>))</b>
						<xsl:choose>
							<xsl:when test="following-sibling::*">; </xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>						
					</xsl:for-each>
					
					
					
				</xsl:element>								
			</xsl:when>
			
			
			<xsl:otherwise>				

				<span class="readings">{
					
					<xsl:for-each select="./tei:rdg">
					<xsl:apply-templates/>
					<xsl:if test=". = ''"><i>-</i></xsl:if>
					&#160;<span class="wit"><xsl:value-of select="translate(@wit,'#','')"/></span>
					<xsl:choose>
						<xsl:when test="following-sibling::*">; </xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</xsl:for-each>	
					
					<xsl:for-each select="./tei:rdgGrp">
						<b>((</b>
						
							<xsl:for-each select="tei:lem">
								<u>										
									<xsl:choose>
										<xsl:when test=". = ''"><i>-</i></xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates/>
										</xsl:otherwise>
									</xsl:choose>
									&#160;<span class="wit"><xsl:value-of select="translate(@wit,'#','')"/></span>
								</u>
								<xsl:choose>
									<xsl:when test="following-sibling::*">; </xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>								
							</xsl:for-each>
						
							<xsl:for-each select="tei:rdg">
								<xsl:apply-templates/>
								<xsl:if test=". = ''"><i>-</i></xsl:if>
								&#160;<span class="wit"><xsl:value-of select="translate(@wit,'#','')"/></span>
								<xsl:choose>
									<xsl:when test="following-sibling::*">; </xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>																
							</xsl:for-each>
					<b>))</b>
					<xsl:choose>
							<xsl:when test="following-sibling::*">; </xsl:when>
							<xsl:otherwise></xsl:otherwise>
					</xsl:choose>						
				</xsl:for-each>
					
					}</span>				

			</xsl:otherwise>
			
		</xsl:choose>
		
		</xsl:element>
	</xsl:template>


	
	



	<xsl:template match="tei:note">
		
		<span class="call">
			<xsl:element name="a">
			<xsl:attribute name="class">critNote</xsl:attribute>
			<xsl:attribute name="onmouseover">document.getElementById('note_<xsl:number count="tei:note" level="any"/>').style.visibility = 'visible';</xsl:attribute>
			<xsl:attribute name="onmouseout">document.getElementById('note_<xsl:number count="tei:note" level="any"/>').style.visibility = 'hidden';</xsl:attribute>
			<sup>(<xsl:number count="tei:note" level="any"/>)</sup>
			</xsl:element>
		</span>
		
		<xsl:element name="span">
			<xsl:attribute name="class">notes</xsl:attribute>
			<xsl:attribute name="id">note_<xsl:number count="tei:note" level="any"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- Marjorie fiddling with TEIPB: end -->
	

	
	<xd:doc>
		<xd:desc>
			<xd:p>A hack because JavaScript was doing weird things with &lt;title>, probably due to confusion with HTML title. There is no TEI namespace in the TEI Boilerplate output because JavaScript, or at least JQuery, cannot manipulate the TEI elements/attributes if they are in the TEI namespace, so the TEI namespace is stripped from the output. As far as I know, &lt;title> elsewhere does not cause any problems, but we may need to extend this to other occurrences of &lt;title> outside the Header.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:teiHeader//tei:title">
		<tei-title>
			<xsl:call-template name="addID"/>
			<xsl:apply-templates select="@*|node()"/>
		</tei-title>
	</xsl:template>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Template to omit processing instructions from output.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" priority="10"/>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Template moves value of @rend into an html @style attribute. Stylesheet assumes
				CSS is used in @rend to describe renditions, i.e., styles.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="@rend">
		<xsl:choose>
			<xsl:when test="$inlineCSS = true()">
				<xsl:attribute name="style">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="rendition">
		<xsl:if test="@rendition">
			<xsl:attribute name="rendition">
				<xsl:value-of select="@rendition"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	

	<xsl:template match="@xml:id">
		<!-- @xml:id is copied to @id, which browsers can use
			for internal links.
		-->
		<!--
		<xsl:attribute name="xml:id">
			<xsl:value-of select="."/>
		</xsl:attribute>
		-->
		<xsl:attribute name="id">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Transforms TEI ref element to html a (link) element.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:ref[@target]" priority="99">
		<a href="{@target}">
			<xsl:call-template name="rendition"/>
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Transforms TEI ptr element to html a (link) element.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:ptr[@target]" priority="99">
		<a href="{@target}">
			<xsl:call-template name="rendition"/>
			<xsl:value-of select="normalize-space(@target)"/>
		</a>
	</xsl:template>


	<!-- need something else for images with captions -->
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Transforms TEI figure element to html img element.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:figure[tei:graphic[@url]]" priority="99">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:call-template name="addID"/>
			<figure>
			<img alt="{normalize-space(tei:figDesc)}" src="{tei:graphic/@url}"/>
			<xsl:apply-templates select="*[local-name() != 'graphic' and local-name() != 'figDesc']"/>
			</figure>
		</xsl:copy>
	</xsl:template>
	
	<!--
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Transforms TEI figure/head to HTML figcaption</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:figure/tei:head">
		<figcaption><xsl:apply-templates/></figcaption>
	</xsl:template>
	-->
    <!--
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Adds some javascript just before end of root tei element. Javascript sets the
				/html/head/title element to an appropriate title selected from the TEI document.
				This could also be achieved through XSLT but is here to demonstrate some simple
				javascript, using JQuery, to manipulate the DOM containing both html and TEI.</xd:p>
		</xd:desc>
	</xd:doc>
	
	
	<xsl:template match="tei:TEI" priority="99">
		<xsl:element name="{local-name()}">
			<xsl:call-template name="addID"/>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	-->
	
	<xsl:template name="addID">
		<xsl:if test="not(ancestor::eg:egXML)">
			<xsl:attribute name="id">
				<xsl:choose>
				<xsl:when test="@xml:id">
					<xsl:value-of select="@xml:id"/>
				</xsl:when>
				<xsl:otherwise>
				<xsl:call-template name="generate-unique-id">
					<xsl:with-param name="root" select="generate-id()"/>
				</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>The generate-id() function does not guarantee the generated id will not conflict
				with existing ids in the document. This template checks for conflicts and appends a
				number (hexedecimal 'f') to the id. The template is recursive and continues until no
				conflict is found</xd:p>
		</xd:desc>
		<xd:param name="root">The root, or base, id used to check for conflicts</xd:param>
		<xd:param name="suffix">The suffix added to the root id if a conflict is
			detected.</xd:param>
	</xd:doc>
	<xsl:template name="generate-unique-id">
		<xsl:param name="root"/>
		<xsl:param name="suffix"/>
		<xsl:variable name="id" select="concat($root,$suffix)"/>
		<xsl:choose>
			<xsl:when test="key('ids',$id)">
				<!--
				<xsl:message>
					<xsl:value-of select="concat('Found duplicate id: ',$id)"/>
				</xsl:message>
				-->
				<xsl:call-template name="generate-unique-id">
					<xsl:with-param name="root" select="$root"/>
					<xsl:with-param name="suffix" select="concat($suffix,'f')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Template for adding /html/head content.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template name="htmlHead">
		<head>
			<meta charset="UTF-8"/>

			<link id="maincss" rel="stylesheet" type="text/css" href="{$teibpCSS}"/>
			<link id="customcss" rel="stylesheet" type="text/css" href="{$customCSS}"/>
			<script type="text/javascript" src="{$jqueryJS}"></script>
			<script type="text/javascript" src="{$jqueryBlockUIJS}"></script>
			<script type="text/javascript" src="{$teibpJS}"></script>
			<script type="text/javascript">
				$(document).ready(function() {
					$("html > head > title").text($("TEI > teiHeader > fileDesc > titleStmt > title:first").text());
					$.unblockUI();	
				});
			</script>
<script>
  $(function() {
    $( "#teibpToolbox" ).draggable();
  });
</script>
		  <xsl:call-template name="tagUsage2style"/>
			<xsl:call-template name="rendition2style"/>
			<title><!-- don't leave empty. --></title>
			<xsl:if test="$includeAnalytics = true()">
				<xsl:call-template name="analytics"/>
			</xsl:if>
		</head>
	</xsl:template>

	<xsl:template name="rendition2style">
		<style type="text/css">
            <xsl:apply-templates select="//tei:rendition" mode="rendition2style"/>
        </style>
	</xsl:template>
  
  <!-- tag usage support -->
  
  <xsl:template name="tagUsage2style">
    <style type="text/css" id="tagusage-css">
      <xsl:for-each select="//tei:namespace[@name ='http://www.tei-c.org/ns/1.0']/tei:tagUsage">
        <xsl:value-of select="concat('&#x000a;',@gi,' { ')"/>
        <xsl:call-template name="tokenize">
          <xsl:with-param name="string" select="@render" />
        </xsl:call-template>
        <xsl:value-of select="'}&#x000a;'"/>
      </xsl:for-each>
    </style>
  </xsl:template>
  
  <xsl:template name="tokenize">
    <xsl:param name="string" />
    <xsl:param name="delimiter" select="' '" />
    <xsl:choose>
      <xsl:when test="$delimiter and contains($string, $delimiter)">
        <xsl:call-template name="grab-css">
          <xsl:with-param name="rendition-id" select="substring-after(substring-before($string, $delimiter),'#')" />
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:call-template name="tokenize">
          <xsl:with-param name="string" 
            select="substring-after($string, $delimiter)" />
          <xsl:with-param name="delimiter" select="$delimiter" /> 
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="grab-css">
          <xsl:with-param name="rendition-id" select="substring-after($string,'#')"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="grab-css">
    <xsl:param name="rendition-id"/>
    <xsl:value-of select="normalize-space(key('ids',$rendition-id)/text())"/>
  </xsl:template>
	
	<xsl:template match="tei:rendition[@xml:id and @scheme = 'css']" mode="rendition2style">
		<xsl:value-of select="concat('[rendition~=&quot;#',@xml:id,'&quot;]')"/>
		<xsl:if test="@scope">
			<xsl:value-of select="concat(':',@scope)"/>
		</xsl:if>
		<xsl:value-of select="concat('{ ',normalize-space(.),'}&#x000A;')"/>
	</xsl:template>
	
	<xsl:template match="tei:rendition[not(@xml:id) and @scheme = 'css' and @corresp]" mode="rendition2style">
		<xsl:value-of select="concat('[rendition~=&quot;#',substring-after(@corresp,'#'),'&quot;]')"/>
		<xsl:if test="@scope">
			<xsl:value-of select="concat(':',@scope)"/>
		</xsl:if>
		<xsl:value-of select="concat('{ ',normalize-space(.),'}&#x000A;')"/>
	</xsl:template>
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Template for adding footer to html document.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:variable name="htmlFooter">
		<footer> 
		</footer>
	</xsl:variable>

	<xsl:template name="teibpToolbox">
		<div id="teibpToolbox">
			<h1>Toolbox</h1>
			<label for="pbToggle">Hide page breaks</label>
			<input type="checkbox" id="pbToggle" /> 
			<div>
				<h3>Themes:</h3>

				<select id="themeBox" onchange="switchThemes(this);">
					<option value="{$theme.default}" >Default</option>
					<option value="{$theme.sleepytime}">Sleepy Time</option>
					<option value="{$theme.terminal}">Terminal</option>
				</select>			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="analytics">
		<script type="text/javascript">
		  var _gaq = _gaq || [];
		  //include analytics account below.
		  _gaq.push(['_setAccount', 'UA-XXXXXXXX-X']);
		  _gaq.push(['_trackPageview']);
		
		  (function() {
		    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
		</script>
	</xsl:template>
	
	<xsl:template name="pb-handler">
		<xsl:param name="n"/>
		<xsl:param name="facs"/>
		<xsl:param name="id"/>
		
		<span class="-teibp-pageNum">
			<!-- <xsl:call-template name="atts"/> -->
			[<span class="-teibp-pbNote"><i><xsl:value-of select="@ed"/></i>:
				<xsl:value-of select="$pbNote"/></span>
			<xsl:value-of select="@n"/>]
			<xsl:text> </xsl:text>
		</span>
			<span class="-teibp-pbFacs">
				<a class="gallery-facs" rel="prettyPhoto[gallery1]">
					<xsl:attribute name="onclick">
						<xsl:value-of select="concat('showFacs(',$apos,$n,$apos,',',$apos,$facs,$apos,',',$apos,$id,$apos,')')"/>
					</xsl:attribute>
					<img  alt="{$altTextPbFacs}" class="-teibp-thumbnail">
						<xsl:attribute name="src">
							<xsl:value-of select="@facs"/>
						</xsl:attribute>
					</img>
				</a>
			</span>

	</xsl:template>
	
	<xsl:template match="tei:pb[@facs]">
		<xsl:param name="pn">
			<xsl:number count="//tei:pb" level="any"/>    
		</xsl:param>
		<xsl:choose>
		<xsl:when test="$displayPageBreaks = true()">
					<span class="-teibp-pb">
						<xsl:call-template name="addID"/>
						<xsl:call-template name="pb-handler">
							<xsl:with-param name="n" select="@n"/>
							<xsl:with-param name="facs" select="@facs"/>
							<xsl:with-param name="id">
								<xsl:choose>
								<xsl:when test="@xml:id">
									<xsl:value-of select="@xml:id"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="generate-id()"/>
								</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</span>
		</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	

	<xsl:template match="eg:egXML">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:call-template name="addID"/>
			<xsl:call-template name="xml-to-string">
				<xsl:with-param name="node-set">
					<xsl:copy-of select="node()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="eg:egXML//comment()">
		<xsl:comment><xsl:value-of select="."/></xsl:comment>
	</xsl:template>

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<!-- recursively splits string into <token> elements -->
	<xsl:template name="tokenizeWit">
		<xsl:param name="srcWit"/>
		
		   <xsl:choose>
			  <xsl:when test="contains($srcWit,' ')">
				
				         <!-- build first token element -->
				         <xsl:element name="x:Token">
					               <xsl:value-of select="substring-before($srcWit,' ')"/>
					         </xsl:element>
				
				         <!-- recurse -->
				        <xsl:call-template name="tokenizeWit">
				               <xsl:with-param name="srcWit" select="substring-after($srcWit,' ')"/>
					         </xsl:call-template>
				
				   </xsl:when>
			   <xsl:otherwise>				
				         <!-- last token, end recursion -->
				         <xsl:element name="x:Token">
					               <xsl:value-of select="$srcWit"/>
					         </xsl:element>				
				  </xsl:otherwise>
			   </xsl:choose>
			</xsl:template>
	
	
	
	
	
</xsl:stylesheet>
