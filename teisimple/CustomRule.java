package simple.documentation.framework;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Stack;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import ro.sync.ecss.extensions.api.DocumentTypeCustomRuleMatcher;
import ro.sync.xml.parser.ParserCreator;

/**
 * Matching rule to the SDF document type.
 *
 */
public class CustomRule implements DocumentTypeCustomRuleMatcher {

	private class MatchHandler extends DefaultHandler {
		private Stack<String> context = new Stack<String>();
		private boolean match;
		
		private String path;
		private String attributeName;
		private String attributeValue;
		public MatchHandler(
				String elementPath,
				String attributeName,
				String attributeValue) {
			this.path = elementPath;
			this.attributeName = attributeName;
			this.attributeValue = attributeValue;
		}

		@Override
		public void startElement(String uri, String localName, String qName,
				Attributes attributes) throws SAXException {
			context.push(localName);

			checkContext(attributes);
		}

		@Override
		public void endElement(String uri, String localName, String qName)
				throws SAXException {
			context.pop();
			
			// TODO If the teiHeader has ended we should stop the parsing. 
			if (localName.equals("teiHeader")) {
				throw new SAXException("NOT THERE");
			}
		}

		private void checkContext(Attributes attributes) throws SAXException {
			StringBuilder contextPath = new StringBuilder();
			for (int i = 0; i < context.size(); i++) {
				if (contextPath.length() > 0) {
					contextPath.append("/");
				}
				contextPath.append(context.get(i));
			}
			
			String currentPath = contextPath.toString();
			
			
			if (path.equals(currentPath)) {
				String value = attributes.getValue(attributeName);
				match = value != null && value.equals(attributeValue);
				//System.out.println("match " + match + " value " + value + " expected: " + attributeValue);
				throw new SAXException("FOUND");
			}
		}
	}
	
	private String elementPath = "TEI/teiHeader/encodingDesc";
	private String attributeName = "type";
	private String attributeValue = "expected";
	
	public CustomRule() {
		// Read them from a configuration file.

		InputStream configStream = getClass().getResourceAsStream("/teisimple.xml");
		if (configStream != null) {
			try {
				DocumentBuilder documentBuilder = ParserCreator.newDocumentBuilder();
				InputSource is = new InputSource(new InputStreamReader(configStream, "UTF-8"));
				Document document = documentBuilder.parse(is);
				
				NodeList elements = document.getElementsByTagName("param");
				for (int i = 0; i < elements.getLength(); i++) {
					Element item = (Element) elements.item(i);
					String attributeVal = item.getAttribute("name");
					if (attributeVal.equals("path")) {
						elementPath = item.getTextContent();
					} else if (attributeVal.equals("attributeName")) {
						attributeName = item.getTextContent();
					} else if (attributeVal.equals("attributeValue")) {
						attributeValue = item.getTextContent();
						
				//		System.out.println("attributeValue " + attributeValue);
					} 
					
				}
			} catch (ParserConfigurationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SAXException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Check if the SDF document type should be used for the given document properties.
	 */
	public boolean matches(
			String systemID,
			String rootNamespace,
			String rootLocalName,
			String doctypePublicID,
			Attributes rootAttributes) {
		XMLReader xmlReader = ParserCreator.newXRNoValidFakeResolver();
		
		
		MatchHandler handler = new MatchHandler(elementPath, attributeName, attributeValue);
		xmlReader.setContentHandler(handler);
		try {
			// No need to validate the HTML. We only need it to be well-formed, 
			// and the user should take care of this.
			xmlReader.setFeature("http://xml.org/sax/features/validation", false);
			InputSource source = new InputSource(systemID);
			xmlReader.parse(source);
		} catch (SAXNotRecognizedException e) {
		} catch (SAXNotSupportedException e) {
		} catch (IOException e) {
		} catch (SAXException e) {
		}

		//System.out.println("Match? " + handler.match);

		return handler.match;
	}

	/**
	 * Description.
	 */
	public String getDescription() {
		return "Checks if the current Document Type Association"
				+ " is matching the document.";
	}
}
