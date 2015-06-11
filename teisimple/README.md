#oXygen framework for TEI Simple

##Installation##

Unpack teisimple.zip in your oxygen frameworks subdirectory (eg. C:\Program Files (x86)\Oxygen XML Editor 16\frameworks)
A new subdirectory called teisimple should appear and after you restart oXygen it should recognise any TEI document
that contains editorialDecl with methodology="teisimple"  as TEI Simple, validating and adding default transformation accordingly.

##TEI Simple document type declaration##

Add <editorialDecl> with methodology="teisimple" to TEI document to be recognizable as TEI Simple document.

~~~~
        <encodingDesc>
              <editorialDecl methodology="teisimple">
                <interpretation><p>This is a tei simple document</p></interpretation>
              </editorialDecl>
        </encodingDesc>
~~~~

>Please note that first time you change <editorialDecl> it may require to reopen the file to recognise it as TEI Simple.

##CustomRule Java class##

This framework relies on extension to oXygen functionality provided by CustomRule.java class that tries to find
a section of the teiHeader that matches path, attribute name and attribute value given by config/teisimple.xml config file in TEI Simple framework.
Default contents of this file is as follows:

~~~~
    <config>
        <param name="path">TEI/teiHeader/encodingDesc/editorialDecl</param>
        <param name="attributeName">methodology</param>
        <param name="attributeValue">teisimple</param>
    </config>
~~~~

