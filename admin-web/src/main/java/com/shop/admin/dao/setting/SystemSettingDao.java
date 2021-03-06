package com.shop.admin.dao.setting;

import com.mine.common.enums.SystemSettingType;
import com.shop.admin.dao.base.BaseDao;
import com.shop.admin.model.setting.SystemSetting;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 系统设置
 */
@Repository("systemSettingDao")
public class SystemSettingDao extends BaseDao {

    /* (non-Javadoc)
     */
    @Override
    protected Class<?> entityClass() {
        return SystemSetting.class;
    }

    /**
     * 根据条件分页查询
     *
     * @param from
     * @param pageSize
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<SystemSetting> list(final int from, final int pageSize) {
        String hql = "from SystemSetting";
        Session session = getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql).setFirstResult(from)
                .setMaxResults(pageSize);
        List<SystemSetting> systemSettings = query.list();
        return systemSettings;
    }

    /**
     * 查询总记录数
     *
     * @return
     */
    public Long listCount() {
        return super.getTotalCount();
    }

    /**
     * 根据id查询系统参数
     *
     * @param id
     * @return
     */
    public SystemSetting findSystemSettingById(final int id) {
        return super.get(id);
    }

    /**
     * 更新系统参数
     *
     * @param setting
     * @return
     */
    public SystemSetting updateSystemSetting(final SystemSetting setting) {
        return super.update(setting);
    }

    /**
     * 通过名称查询系统参数
     *
     * @param name
     * @return
     */
    public SystemSetting findSystemSettingByName(final String name) {

        String hql = "from SystemSetting where name=:name";
        Session session = getSessionFactory().getCurrentSession();
        Object obj = session.createQuery(hql).setParameter("name", name)
                .uniqueResult();

        return obj == null ? null : (SystemSetting) obj;
    }
    
    /**
     * 查询所有的系统参数类型
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<SystemSettingType> findAllType() {
        String hql = "select systemSettingType from SystemSetting group by systemSettingType";
        List<SystemSettingType> systemSettings = super.getSessionFactory().getCurrentSession().find(hql);
        return systemSettings;
    }

    public List<SystemSetting> findAllSetting() {
        String hql = "from SystemSetting";
        List<SystemSetting> systemSettings = super.getSessionFactory().getCurrentSession().createQuery(hql).list();
        return systemSettings;
    }

    /**
     * 添加系统参数
     *
     * @param systemSetting
     * @return
     */
    public SystemSetting add(final SystemSetting systemSetting) {
        return super.add(systemSetting);
    }

    /**
     * @param systemSettingType
     * @return
     */
    public SystemSetting getByType(final SystemSettingType systemSettingType) {
        String hql = "from SystemSetting where systemSettingType = :systemSettingType";
        Session session = getSessionFactory().getCurrentSession();
        Object obj = session.createQuery(hql)
                .setParameter("systemSettingType", systemSettingType)
                .uniqueResult();
        return obj == null ? null : (SystemSetting) obj;
    }

}
