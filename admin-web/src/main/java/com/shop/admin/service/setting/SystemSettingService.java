package com.shop.admin.service.setting;



import com.mine.common.enums.SystemSettingType;
import com.shop.admin.model.setting.SystemSetting;

import java.util.List;
import java.util.Map;


/**
 * 系统参数设置service层接口
 * @author tangzhi
 * @date 2013-04-24
 */
public interface SystemSettingService {

	/**
	 * 分页查询系统参数
	 * @return
	 */
	public List<SystemSetting> list(int from, int pageSize);
	
	/**
	 * 查询系统参数总记录数
	 * @return
	 */
	public long listCount();
	
	/**
	 * 根据id查询系统参数
	 * @param id	系统参数id
	 * @return
	 */
	public SystemSetting findSystemSettingById(int id);
	
	
	/**
	 * 更新系统参数
	 * @param setting	系统参数信息
	 * @return
	 */
	public SystemSetting updateSystemSetting(Integer systemSettingId, String name, String value);
	
	
	/**
	 * 获取所有没有定义的系统参数类别
	 * @return
	 */
	public Map<String, String> findNotExsitsType();

    Map<String, String> findExsitsType();

    /**
	 * 添加系统参数
	 * @param systemSetting
	 * @return
	 */
	public SystemSetting add(SystemSettingType systemSettingType, String name, String value);
	
	/**
	 * 根据类型获取系统参数
	 */
	SystemSetting getByType(SystemSettingType systemSettingType);
	
	public SystemSetting findSystemSettingByName(String name);
	
}
