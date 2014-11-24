<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    extension-element-prefixes="exsl msxsl" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl tei xd eg fn #default">

    <!-- import teibp.xsl, which allows templates, 
         variables, and parameters from teibp.xsl 
         to be overridden here. -->
    <xsl:import href="teibp.xsl"/>
    <xsl:output method="html"/>

    <xsl:template match="/" name="htmlShell" priority="99">
        <html encoding="UTF-8">
            <HEAD>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <link rel="stylesheet" type="text/css" href="./css/teibp.css" /> 
                <link rel="stylesheet" type="text/css" href="./css/custom.css" />
                <TITLE>TEI Critical Edition Checker</TITLE>
                <script type="text/javascript" src="./js/jquery/jquery.min.js"/>
                <script type="text/javascript" src="./js/jquery/plugins/jquery.blockUI.js"/>
                <script type="text/javascript" src="./js/teibp.js"/>
                <script type="text/javascript" src="./js/teibpCustom.js"/>
                <script type="text/javascript" src="./js/dragDrop.js"/>
                <script type="text/javascript" src="./js/addEventSimple.js"/>
                
                <script type="text/javascript" src="./js/togglemenu.js"/>
                
                <script type="text/javascript">
                    <!--
function init() {
	dragDrop.initElement('teibpToolbox');
}

// -->
                </script>
            </HEAD>
            <body onload="javascript:init();">
                
                <div id="maincontainer">
                    
                    <div id="mainBanner">
                        
                        <div class="innertube">
                            <h1 style="text-align: left;">TEI Critical Edition Checker</h1>
                        </div>
                        
                        
                    </div>
                    
                    
        
        
        <xsl:if test="$includeToolbox = true()">
            <xsl:call-template name="teibpToolbox"/>
        </xsl:if>
        <div id="tei_wrapper">					
            <xsl:apply-templates/>
        </div>
        <xsl:copy-of select="$htmlFooter"/>
                    
                </div>
            </body>
        </html>
    
    </xsl:template>
    

    <xsl:template match="tei:pb">
        <xsl:element name="span">
            <xsl:attribute name="class">msPb pb_<xsl:value-of select="translate(@ed,'#','')"
                /></xsl:attribute> [<xsl:if test="@ed"><i><xsl:value-of
                        select="translate(@ed,'#','')"/></i> : </xsl:if>
            <xsl:value-of select="@n"/>] </xsl:element>
    </xsl:template>

    <xsl:template match="tei:title[ancestor::tei:body]">

        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="tei:head">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>


    <xsl:template name="teibpToolbox">



        <div id="teibpToolbox">
            <h1>Toolbox</h1>

         
            <ul class="menuCollapse">
                <li>
                    <label onclick="javascript:toggleMenu.toggle(this.parentNode.getElementsByTagName('ul')[0], 'hidden');">Show page breaks ?</label>
                    <ul id="menu0">
                        <li>
                            <br/>All <xsl:element name="input">
                                <xsl:attribute name="type">checkbox</xsl:attribute>
                                <xsl:attribute name="onclick">handleClick(this,
                                    'msPb');</xsl:attribute>
                            </xsl:element>
                            <br/>Only for: <xsl:for-each
                                select="//tei:listWit/tei:witness">
                                <br/><xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="onclick">handleClick(this,
                                            'pb_<xsl:value-of select="@xml:id"/>');</xsl:attribute>
                                </xsl:element>
                                <xsl:value-of select="@xml:id"/>
                            </xsl:for-each>
                        </li>
                    </ul>
                </li>
                <li>
                    <label onclick="javascript:toggleMenu.toggle(this.parentNode.getElementsByTagName('ul')[0], 'hidden');">Highlight apparatus entries that do not use all witnesses?</label>
                    <ul id="menu1">
                        <li>
                            <br/><span id="menu1All">All <input id="menu1AllChk" type="checkbox" onclick="handleClickAppCheck(this);"/></span>
                    <span id="menu1Options"><br/>Only the app. not listing:
                        
                        <br/>
                        <span>
                            <input type="checkbox" value="" onclick="handleClickAppCheckSingle(this,'', '1');"/> any witness at all
                        </span>
                        
                        <xsl:for-each select="//tei:listWit/tei:witness">
                        <br/>
                        <span>
                        <xsl:element name="input">
                            <xsl:attribute name="type">checkbox</xsl:attribute>        
                            <xsl:attribute name="value"><xsl:value-of select="@xml:id"/></xsl:attribute>
                            <xsl:attribute name="onclick">handleClickAppCheckSingle(this,
                                '<xsl:value-of select="@xml:id"/>', '<xsl:value-of select="position()"/>');</xsl:attribute>
                        </xsl:element>
                        <xsl:value-of select="@xml:id"/>
                        </span>
                        </xsl:for-each>
                    </span>
                        </li>
                    </ul>
                </li>
                <li>
                    <label onclick="javascript:toggleMenu.toggle(this.parentNode.getElementsByTagName('ul')[0], 'hidden');">Highlight apparatus entries that mention a particular witness?</label>
                    <ul id="menu2">
                        <li>
                            <span id="menu2Options">
                    <xsl:for-each select="//tei:listWit/tei:witness">
                        <br/>
                       <span><xsl:element name="input">
                            <xsl:attribute name="type">checkbox</xsl:attribute>
                           <xsl:attribute name="value"><xsl:value-of select="@xml:id"/></xsl:attribute>
                            <xsl:attribute name="onclick">handleClickAppCheckPresence(this,
                                '<xsl:value-of select="@xml:id"/>', '<xsl:value-of select="position()"/>');</xsl:attribute>
                        </xsl:element>
                        <xsl:value-of select="@xml:id"/>  
                       </span>
                    </xsl:for-each>
                            </span>
                        </li>                        
                </ul>
                </li>
                
                <li>
                    <label onclick="javascript:toggleMenu.toggle(this.parentNode.getElementsByTagName('ul')[0], 'hidden');">Various controls</label>
                    <ul id="menu3">
                        <li>
                            <span id="menu3Options">              
                                Highlight &lt;app/&gt;s: 
                                <span><br/><input type="checkbox" value="lem" onclick="showAppType(this, 'lem');"/>with a &lt;lem/&gt;</span>
                                <span><br/><input type="checkbox" value="rdg" onclick="showAppType(this, 'rdg');"/>with only &lt;rdg/&gt;s</span>                               
                                <span><br/><input type="checkbox" value="doubles" onclick="showDoubles(this);"/>where at least one witness is mentioned more than once</span>
                            </span>
                        </li>
                    </ul>
                </li>
                
                
            </ul>
        </div>



    </xsl:template>























</xsl:stylesheet>
