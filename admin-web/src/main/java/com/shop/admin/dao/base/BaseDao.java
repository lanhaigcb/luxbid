/**
 *
 */
package com.shop.admin.dao.base;


import org.hibernate.*;
import org.hibernate.transform.ResultTransformer;
import org.hibernate.type.Type;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 */
public abstract class BaseDao extends HibernateDaoSupport {

    @Autowired
    protected void init(SessionFactory sessionFactory) {
        setSessionFactory(sessionFactory);
    }

    protected abstract Class<?> entityClass();

    @SuppressWarnings("unchecked")
    protected <T> T get(Serializable id) {
        return (T) getHibernateTemplate().get(entityClass(), id);
    }

    @SuppressWarnings("unchecked")
    protected <T> T getByCollumn(String collumn, String value) {
        String hql = " from " + entityClass().getName() + " where " + collumn + "='" + value + "'";
        return (T) getSessionFactory().getCurrentSession().createQuery(hql).uniqueResult();
    }

    @SuppressWarnings("unchecked")
    public <T> List<T> loanAll() {
        return (List<T>) getHibernateTemplate().loadAll(entityClass());
    }

    public Long getTotalCount() {
        String hql = "select count(*) from " + entityClass().getName();
        return (Long) getSessionFactory().getCurrentSession().createQuery(hql).uniqueResult();
    }

    @SuppressWarnings("unchecked")
    protected <T> List<T> list(int from, int pageSize) {
        String hql = "from " + entityClass().getName();
        return ((List<T>) getSessionFactory().getCurrentSession().createQuery(hql).setFirstResult(from).setMaxResults(pageSize).list());
    }

    protected <T> T add(T entity) {
        getHibernateTemplate().persist(entity);
        return entity;
    }

    protected <T> void remove(T entity) {
        getHibernateTemplate().delete(entity);
    }

    protected <T> T update(T entity) {
        getHibernateTemplate().merge(entity);
        return entity;
    }

    protected <T> T refresh(T entity) {
        getHibernateTemplate().refresh(entity);
        return entity;
    }

    protected Long getLikeCount(String likeStr) {
        String whereSql = " where 1=1 and ( ";
        Field[] fields = entityClass().getDeclaredFields();
        for (Field field : fields) {
            whereSql += " or " + field.getName() + " = " + likeStr;
        }
        whereSql += ")";
        String hql = "select count(*) from " + entityClass().getName() + whereSql;
        return (Long) getSessionFactory().getCurrentSession().createQuery(hql).uniqueResult();
    }

    @SuppressWarnings("unchecked")
    protected <T> List<T> getLikeListAll(int from, int pageSize, String likeStr) {
        String whereSql = " where 1=1 and ( ";
        Field[] fields = entityClass().getDeclaredFields();
        for (Field field : fields) {
            whereSql += " or " + field.getName() + " = " + likeStr;
        }
        whereSql += ")";
        String hql = "from " + entityClass().getName() + whereSql;
        return ((List<T>) getSessionFactory().getCurrentSession().createQuery(hql).setFirstResult(from).setMaxResults(pageSize).list());
    }

    protected List<?> find(final String hql) {
        return getHibernateTemplate().find(hql);
    }

    protected List<?> find(final String hql, Object... objects) {
        return getHibernateTemplate().find(hql, objects);
    }

    /**
     * 根据条件获取列表 HQL
     *
     * @param hql
     * @param condition
     * @return
     */
    protected List<?> list(final String hql,
                           final Map<String, Object> condition) {
        return listWithHqlQuery(hql, condition);
    }
    /**
     * 根据条件获取列表 SQL
     *
     * @param sql
     * @param condition
     * @return
     */
    protected List<?> listEntityWithSql(final String sql, final Map<String, Object> condition) {
        return listWithSQLQuery(sql, condition, null, null, entityClass());
    }
    /**
     * config hibernate query
     *
     * @param hql
     * @param condition
     * @return
     */
    private final List listWithHqlQuery(final String hql, final Map<String, Object> condition) {
        return getHibernateTemplate().execute(new HibernateCallback<List>() {
            @Override
            public List doInHibernate(Session session) throws HibernateException {
                Query query = session.createQuery(hql);
                configCondition(query, condition);
                return query.list();
            }
        });
    }
    /**
     * config sqlquery
     *
     * @param sql
     * @param condition
     * @return
     */
    private final List listWithSQLQuery(final String sql, final Map<String, Object> condition, final Map<String, Type> scalarMapping, final ResultTransformer resultTransformer, final Class clazz) {
        return getHibernateTemplate().execute(new HibernateCallback<List>() {
            @Override
            public List doInHibernate(Session session) throws HibernateException {
                SQLQuery query = session.createSQLQuery(sql);
                configCondition(query, condition);
                if (scalarMapping != null && !scalarMapping.isEmpty()) {
                    for (String key : scalarMapping.keySet()) {
                        Type type = scalarMapping.get(key);
                        query.addScalar(key, type);
                    }
                }
                if (resultTransformer != null) {
                    query.setResultTransformer(resultTransformer);
                }
                return clazz == null ? query.list() : query.addEntity(clazz).list();
            }
        });
    }

    /**
     * 根据条件匹配query
     *
     * @param query
     * @param condition
     */
    private void configCondition(Query query,
                                 final Map<String, Object> condition) {
        if (condition != null && !condition.isEmpty()) {
            for (String key : condition.keySet()) {
                Object object = condition.get(key);
                if (object instanceof Collection) {
                    query.setParameterList(key, (Collection) object);
                } else {
                    query.setParameter(key, object);
                }
            }
        }
    }

    /**
     * 创建map条件
     */
    protected final Map<String, Object> configMap(String[] keys, Object[] values) {
        if (keys.length != values.length) {
            throw new RuntimeException(
                    "config map failed, keys length not eq values length");
        }
        Map<String, Object> map = new HashMap<String, Object>();
        for (int i = 0; i < keys.length; i++) {
            map.put(keys[i], values[i]);
        }
        return map;
    }
}