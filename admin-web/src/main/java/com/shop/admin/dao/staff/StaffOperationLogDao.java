package com.shop.admin.dao.staff;

import com.shop.admin.dao.base.BaseDao;
import com.shop.admin.model.staff.StaffOperationLog;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Repository("staffOperationLogDao")
public class StaffOperationLogDao extends BaseDao {

    @Override
    protected Class<?> entityClass() {
        return StaffOperationLog.class;
    }

    public StaffOperationLog save(StaffOperationLog staffOperationLog) {
        return super.add(staffOperationLog);
    }

    public StaffOperationLog update(StaffOperationLog staffOperationLog) {
        return super.update(staffOperationLog);
    }

    public StaffOperationLog getById(final int id) {
        return super.get(id);
    }

	/**
	 * 分页查询后台用户
	 * @param from
	 * @param pageSize
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<StaffOperationLog> list(int from , int pageSize,String name, Date startDate, Date endDate){
		String hql = "from StaffOperationLog where 1=1";
		if (!name.equals("")){
			hql += " and name=:name";
		}
		if (startDate!=null&&endDate!=null){
			hql += " and createTime >= :startDate ";
			hql += " and createTime <= :endDate ";
		}
		hql += " order by createTime desc";
		Session session = getSessionFactory().getCurrentSession();
		Query query = session.createQuery(hql).setFirstResult(from).setMaxResults(from+pageSize);
		if(!name.equals("")){
			query.setParameter("name", name);
		}
		if (startDate!=null&&endDate!=null){
			query.setParameter("startDate",startDate);
			query.setParameter("endDate",endDate);
		}
		List<StaffOperationLog> staffs = query.list();
		return staffs;
	}
	
	/**
	 * 拿到后台用户总记录数
	 */
	public long totalCount(String name, Date startDate, Date endDate){
		return super.getTotalCount();
	}

	/**
	 * 查询所有操作类型
	 */
	public List<Map<String, Object>> getTitleTypeList() {
		String sql = " select DISTINCT name from staff_operation_log ";
		Query query = getSessionFactory().openSession().createSQLQuery(sql);
		List list = query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		return list;
	}
	
}
