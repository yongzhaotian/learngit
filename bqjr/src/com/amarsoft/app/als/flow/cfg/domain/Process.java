package com.amarsoft.app.als.flow.cfg.domain;

import org.jdom.Document;

public class Process {

    /**
     * @return Returns the doc.
     */
    public Document getDoc() {
        return doc;
    }

    /**
     * @param doc The doc to set.
     */
    public void setDoc(Document doc) {
        this.doc = doc;
    }

    /**
     * @return Returns the name.
     */
    public String getName() {
        return name;
    }

    /**
     * @param name The name to set.
     */
    public void setName(String name) {
        this.name = name;
    }

    private String name;

    private Document doc;
}
