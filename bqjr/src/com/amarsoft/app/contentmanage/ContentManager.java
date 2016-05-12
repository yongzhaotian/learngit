package com.amarsoft.app.contentmanage;

import java.util.List;
/**
 * 定义内容管理接口: 定义上传、下载、删除文档、创建新版本、得到所有版本、删除所有版本等方法
 */
public interface ContentManager {

	/**
	 * 文件夹常量: FOLDER_ATTACH - 附件; FOLDER_FORMAT_DOC - 格式化报告; FOLDER_IMAGE - 影像
	 */
	public static final int FOLDER_ATTACH = 0;
	public static final int FOLDER_FORMAT_DOC = 1;
	public static final int FOLDER_IMAGE = 2;
	/**
	 * 根据内容管理平台的id得到内容管理平台上的对象，并把相关信息包装为content对象,返回content对象
	 * @param id 对象的id
	 * @return Content对象
	 */
	public Content get(String id);
	
	/**
	 * 上传内容对象,返回内容管理平台中对应的对象的id
	 * @param content 内容对象
	 * 	@param folderType 上传到的目录类型(ContentManager.FOLDER_ATTACH, ContentManager.FOLDER_FORMAT_DOC, ContentManager.FOLDER_IMAGE)
	 * @return 对象的id
	 */
	public String save(Content content, int folderType);
	/**
	 * 设置对应id的文档对象的备注
	 * @param id  文档对象的id
	 * @param desc  文档对象的备注
	 * @return true/false是否设置成功
	 */
	public boolean setDesc(String id, String desc);
	/**
	 * 根据id得到对应的文档对象,并在此文档对象的基础上创建新版本,返回新版本的id
	 * @param id 文档对象的id
	 * @param content 新版本的内容
	 * @return 新版本的id
	 */
	public String newVersion(String id, Content content);
	
	/**
	 * 根据id找到对应的文档对象,删除此文档对象
	 * @param id 文档对象的id
	 * @return true/false
	 */
	public boolean delete(String id);
	
	/**
	 * 根据id找到对应的文档对象,得到与此文档对象相关的各版本
	 * @param id 文档对象的id
	 * @return 所有版本的迭代器
	 */
	public List<Content> getAllVersions(String id);
	
	/**
	 * 根据id找到对应的文档对象,删除与此文档对象相关的各版本
	 * @param id 文档对象的id
	 * @return true/false
	 */
	public boolean delAllVersion(String id);

}
