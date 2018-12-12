package com.shop.admin.service.setting.impl;


import com.mine.common.enums.SystemSettingType;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.dao.setting.SystemSettingDao;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


/**
 * 系统参数service实现类
 */
@Service(value = "systemSettingService")
public class SystemSettingServiceImpl implements SystemSettingService {

    @Autowired
    private SystemSettingDao systemSettingDao;

    @Autowired
    private MessageSource messageSource;


    /**
     * 分页查询系统参数
     *
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<SystemSetting> list(int from, int pageSize) {
        return systemSettingDao.list(from, pageSize);
    }

    /**
     * 查询系统参数总记录数
     *
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public long listCount() {
        return systemSettingDao.listCount();
    }


    /**
     * 根据id查询系统参数
     *
     * @param id 系统参数id
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public SystemSetting findSystemSettingById(int id) {
        return systemSettingDao.findSystemSettingById(id);
    }


    /**
     * 更新系统参数
     *
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public SystemSetting updateSystemSetting(Integer systemSettingId, String name, String value) {
        SystemSetting setting2 = findByName(name);
        if (setting2 != null && setting2.getId() == systemSettingId) {
            throw new RuntimeException(messageSource.getMessage("systemSetting.name.exists"));
        }

        SystemSetting systemSetting = findSystemSettingById(systemSettingId);
        systemSetting.setName(name);
        systemSetting.setUpdateTime(new Date());
        systemSetting.setValue(value);

        systemSetting = systemSettingDao.updateSystemSetting(systemSetting);


        return systemSetting;
    }

    private SystemSetting findByName(String name) {

        return systemSettingDao.findSystemSettingByName(name);
    }

    /**
     * 获取所有没有定义的系统参数类别
     *
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public Map<String, String> findNotExsitsType() {

        Map<String, String> typeMap = new LinkedHashMap<String, String>();

        List<SystemSettingType> systemSettings = findAllType();

        for (SystemSettingType type : SystemSettingType.values()) {

            if (systemSettings == null || !systemSettings.contains(type)) {
                typeMap.put(type.name(), type.toString());
            }
        }

        return typeMap;
    }

    @Override
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public Map<String, String> findExsitsType() {

        Map<String, String> typeMap = new LinkedHashMap<String, String>();

        List<SystemSetting> systemSettings = systemSettingDao.findAllSetting();

        for (SystemSetting setting : systemSettings) {

            typeMap.put(setting.getSystemSettingType().name(), setting.getValue());
        }
        return typeMap;
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<SystemSettingType> findAllType() {
        return systemSettingDao.findAllType();
    }

    /**
     * 添加系统参数
     *
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public SystemSetting add(SystemSettingType systemSettingType, String name, String value) {
        SystemSetting setting2 = findByName(name);
        if (setting2 != null) {
            throw new RuntimeException(messageSource.getMessage("systemSetting.name.exists"));
        }
        SystemSetting setting = new SystemSetting();
        Date date = new Date();
        setting.setCreateTime(date);
        setting.setUpdateTime(date);
        setting.setSystemSettingType(systemSettingType);
        setting.setName(name);
        setting.setValue(value);
        return systemSettingDao.add(setting);
    }

    /* (non-Javadoc)
     */
    @Override
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public SystemSetting getByType(SystemSettingType systemSettingType) {
        SystemSetting systemSetting = systemSettingDao.getByType(systemSettingType);
        return systemSetting;
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    @Override
    public SystemSetting findSystemSettingByName(String name) {
        return this.systemSettingDao.findSystemSettingByName(name);
    }

}
