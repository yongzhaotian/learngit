package com.amarsoft.app.contentmanage;

import java.util.List;
/**
 * �������ݹ���ӿ�: �����ϴ������ء�ɾ���ĵ��������°汾���õ����а汾��ɾ�����а汾�ȷ���
 */
public interface ContentManager {

	/**
	 * �ļ��г���: FOLDER_ATTACH - ����; FOLDER_FORMAT_DOC - ��ʽ������; FOLDER_IMAGE - Ӱ��
	 */
	public static final int FOLDER_ATTACH = 0;
	public static final int FOLDER_FORMAT_DOC = 1;
	public static final int FOLDER_IMAGE = 2;
	/**
	 * �������ݹ���ƽ̨��id�õ����ݹ���ƽ̨�ϵĶ��󣬲��������Ϣ��װΪcontent����,����content����
	 * @param id �����id
	 * @return Content����
	 */
	public Content get(String id);
	
	/**
	 * �ϴ����ݶ���,�������ݹ���ƽ̨�ж�Ӧ�Ķ����id
	 * @param content ���ݶ���
	 * 	@param folderType �ϴ�����Ŀ¼����(ContentManager.FOLDER_ATTACH, ContentManager.FOLDER_FORMAT_DOC, ContentManager.FOLDER_IMAGE)
	 * @return �����id
	 */
	public String save(Content content, int folderType);
	/**
	 * ���ö�Ӧid���ĵ�����ı�ע
	 * @param id  �ĵ������id
	 * @param desc  �ĵ�����ı�ע
	 * @return true/false�Ƿ����óɹ�
	 */
	public boolean setDesc(String id, String desc);
	/**
	 * ����id�õ���Ӧ���ĵ�����,���ڴ��ĵ�����Ļ����ϴ����°汾,�����°汾��id
	 * @param id �ĵ������id
	 * @param content �°汾������
	 * @return �°汾��id
	 */
	public String newVersion(String id, Content content);
	
	/**
	 * ����id�ҵ���Ӧ���ĵ�����,ɾ�����ĵ�����
	 * @param id �ĵ������id
	 * @return true/false
	 */
	public boolean delete(String id);
	
	/**
	 * ����id�ҵ���Ӧ���ĵ�����,�õ�����ĵ�������صĸ��汾
	 * @param id �ĵ������id
	 * @return ���а汾�ĵ�����
	 */
	public List<Content> getAllVersions(String id);
	
	/**
	 * ����id�ҵ���Ӧ���ĵ�����,ɾ������ĵ�������صĸ��汾
	 * @param id �ĵ������id
	 * @return true/false
	 */
	public boolean delAllVersion(String id);

}
