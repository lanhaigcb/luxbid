/**
 *
 */
package com.shop.admin.service.staff;


import com.shop.admin.model.staff.Staff;

import java.util.List;


/**
 */
public interface StaffService {

    public Staff updatePersistStaff(Staff staff);

    /**
     * 获取后台用户
     */
    Staff getByName(String name);

    /**
     * 更新用户
     *
     * @return
     */
    Staff updateStaff(int staffId, String realName, boolean enable, String enName);

    /**
     * 启用用户
     *
     * @param id
     * @return
     */
    Staff enableStaff(int id);

    /**
     * 禁用用户
     *
     * @param id
     * @return
     */
    Staff disableStaff(int id);

    /**
     * 根据id获取用户
     *
     * @param id
     * @return
     */
    Staff getStaffById(int id);

    /**
     * 添加用户
     *
     * @return
     */
    ///Staff addStaff(Staff staff);
    public Staff addStaff(String name, String realname, String password, boolean eable, String enName, String mobile);

    /**
     * 获取所有的用户
     *
     * @param from
     * @param pageSize
     * @return
     */
    List<Staff> listAll(int from, int pageSize);


    /**
     * 查询后台用户总记录数
     *
     * @return
     */
    public long getTotalCount();

    /**
     * 更新用户登陆信息
     */
    Staff updateStaffLoginInfo(int id, String loginIp);

    public void updateStaff(Staff staff, String roleId, Integer orgId);

    public void updateStatus(Integer id, boolean falg);

    public void updateStaff(Staff staff);

    public boolean updatePassword(Staff staff, String oldPassword);

    public Staff updateGoogle(Integer id, String googleSec);

    Staff add(Staff staff);

    public void updateGoogleBind(Integer id, Boolean googleBind);

}
