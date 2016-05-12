package com.amarsoft.app.als.flow.cfg.util;

import java.io.File;
import java.io.FileFilter;

public class SingleIOFileFilter implements FileFilter {

    /**
     * 构�?函数
     * @param extend String：扩展名
     */
    public SingleIOFileFilter(String extend) {
        this(extend, "文件格式");
    }

    public SingleIOFileFilter(String extend, String description) {
        this.extend = extend.toLowerCase();
        this.description = description;
    }

    /**
     *判断文件是否可见,
     *文件夹�?合法扩展名为可见
     *@param pathname File
     *@return boolean
     */
    public boolean accept(File pathname) {
        if ((pathname != null) && (extend != null)) {
            String fileName = pathname.getName();
            int index = fileName.lastIndexOf('.');
            if ((index > 0) && (index < (fileName.length() - 1))) {
                String extension = fileName.substring(index + 1).toLowerCase();
                if (extension.equalsIgnoreCase(extend)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**对XML文件类型的描�?
     *@return String
     */
    public String getDescription() {
        if ((description == null) || (description.equals(""))) {
            description = "文件格式";
        }

        return description + "(*." + extend + ")";
    }

    //扩展�?
    private String extend;

    private String description;

}
