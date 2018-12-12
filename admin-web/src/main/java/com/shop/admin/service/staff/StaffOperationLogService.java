package com.shop.admin.service.staff;
import com.shop.admin.model.staff.StaffOperationLog;

import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 * 用户操作日志
 */
public interface StaffOperationLogService {

    /**
     * 添加用户操作日志
     *
     * @return
     */
    public StaffOperationLog addStaffOperationLog(String name, String content, Integer staffId, String staffRealName);

    /**
     * 获取所有的用户操作日志
     *
     * @param from
     * @param pageSize
     * @return
     */
    List<StaffOperationLog> listAll(int from, int pageSize, String name, Date startDate, Date endDate);

    /**
     * 查询后台用户总记录数
     *
     * @return
     */
    long getTotalCount(String name, Date startDate, Date endDate);

    /**
     * 查询所有操作类型
     */
    List<Map<String, Object>> getTitleTypeList();

}
