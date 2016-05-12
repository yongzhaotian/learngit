package com.amarsoft.app.edoc;

/**
 * 重写电子合同类
 * @author ljzhong
 *
 */

import com.amarsoft.awe.util.Transaction;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

public class EDocument {
	private static SAXBuilder builder = new SAXBuilder();

	private Document template = null;

	private Document datadef = null;
	private String templateFName = null;
	private String dataDefFName = null;

	public EDocument(String templateFName, String dataDefFName)
			throws JDOMException, IOException {
		this.templateFName = templateFName;
		this.template = builder.build(new File(templateFName));
		if (dataDefFName != null) {
			this.dataDefFName = dataDefFName;
			this.datadef = builder.build(new File(dataDefFName));
		}
	}

	public static String getTagList(String fname) throws JDOMException,
			IOException {
		Document doc = builder.build(new File(fname));
		return ETagHandle.getTagList(doc);
	}

	public String getTagList() throws JDOMException, IOException {
		return ETagHandle.getTagList(this.template);
	}

	public String getDefTagList() throws JDOMException, IOException {
		return ETagHandle.getDefTagList(this.datadef);
	}

	public String checkTag() throws JDOMException, IOException {
		return ETagHandle.checkTag(this.template, this.datadef);
	}

	private static void replaceTag(Document doc, Document data)
			throws JDOMException, IOException {
		ETagHandle.replaceSimpleTag(doc, data);

		ETagHandle.replaceTableTag(doc, data);
	}

	public String saveAsDefault(String fileName) throws FileNotFoundException,
			IOException, JDOMException {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8");
		format.setIndent("   ");

		XMLOutputter XMLOut = new XMLOutputter(format);
		Document doc = builder.build(new File(this.templateFName));
		Document data = builder.build(new File(this.dataDefFName));
		replaceTag(doc, data);
		XMLOut.output(doc, new FileOutputStream(fileName));
		return fileName;
	}

	public String saveDoc(String fileName, Map map, Transaction Sqlca)
			throws Exception {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8");
		format.setIndent("   ");

		XMLOutputter XMLOut = new XMLOutputter(format);
		Document doc = builder.build(new File(this.templateFName));
		Document data = builder.build(new File(this.dataDefFName));
		data = EDataHandle.getData(data, map, Sqlca);
		replaceTag(doc, data);
		XMLOut.output(doc, new FileOutputStream(fileName));
		return fileName;
	}

	public String saveData(String fileName, Map map, Transaction Sqlca)
			throws Exception {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8");
		format.setIndent("   ");

		XMLOutputter XMLOut = new XMLOutputter(format);
		Document data = builder.build(new File(this.dataDefFName));
		data = EDataHandle.getData(data, map, Sqlca);
		XMLOut.output(data, new FileOutputStream(fileName));
		return fileName;
	}
}
