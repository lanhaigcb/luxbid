/**
 *
 */
package com.shop.admin.service.staff.impl;

import com.google.common.base.Strings;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.dao.staff.StaffDao;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.model.staff.StaffRole;
import com.shop.admin.service.staff.StaffRoleService;
import com.shop.admin.service.staff.StaffService;
import com.mine.util.password.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


/**
 */
@Service("staffService")
public class StaffServiceImpl implements StaffService {

    @Autowired
    private StaffDao staffDao;
    @Autowired
    private MessageSource messageSource;
    @Autowired
    private StaffRoleService staffRoleService;

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#addStaff(com.qianmama.model.staff.Staff)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff addStaff(String name, String realname, String password, boolean eable, String enName, String mobile) {
        if (Strings.isNullOrEmpty(name)) {
            throw new StaffException(messageSource.getMessage("user.name.is.not.null"));
        }
        if (Strings.isNullOrEmpty(realname)) {
            throw new StaffException(messageSource.getMessage("real.name.is.not.null"));
        }
        if (Strings.isNullOrEmpty(password)) {
            throw new StaffException(messageSource.getMessage("password.is.not.null"));
        }
        if (Strings.isNullOrEmpty(enName)) {
            throw new StaffException(messageSource.getMessage("role.is.not.null"));
        }

        // 需要进行数据校验

        Staff staff1 = getByName(name);
        if (null != staff1) {
            throw new StaffException(messageSource.getMessage("user.name.is.exsit"));
        }

        Date date = new Date();
        Staff staff = new Staff();
        staff.setCreateTime(date);
        staff.setEnable(eable);
        staff.setLoginIp(null);
        staff.setLoginTime(null);
        staff.setName(name);
        staff.setPassword(MD5Util.digest(password));
        staff.setRealname(realname);
        staff.setMobile(mobile);

        Set<StaffRole> roles = new HashSet<StaffRole>();

        String[] roleNames = enName == null ? null : enName.split(",");
        if (roleNames != null) {
            for (String roleName : roleNames) {
                StaffRole staffRole = staffRoleService.getByEnName(enName);
                roles.add(staffRole);
            }
        }
        // 需要去查询角色
        staff.setRoles(roles);

        return staffDao.save(staff);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#disableStaff(int)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff disableStaff(int id) {
        Staff staff = getStaffById(id);
        if (null == staff) {
            throw new StaffException(messageSource.getMessage("role.is.not.fund"));
        }
        staff.setEnable(false);
        return staffDao.update(staff);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#enableStaff(int)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff enableStaff(int id) {
        Staff staff = getStaffById(id);
        if (null == staff) {
            throw new StaffException(messageSource.getMessage("role.is.not.fund"));
        }
        staff.setEnable(true);
        return staffDao.update(staff);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#getByName(java.lang.String)
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public Staff getByName(String name) {
        return staffDao.getByName(name);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#getStaffById(int)
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public Staff getStaffById(int id) {
        return staffDao.getStaffById(id);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#getTotalCount()
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public long getTotalCount() {
        return staffDao.totalCount();
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#listAll(int, int)
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<Staff> listAll(int from, int pageSize) {
        return staffDao.list(from, pageSize);
    }


    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#updateStaffLoginInfo(int, java.lang.String)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff updateStaffLoginInfo(int id, String loginIp) {
        Staff staff = getStaffById(id);
        staff.setLoginIp(loginIp);
        staff.setLoginTime(new Date());
        return staffDao.update(staff);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public void updateStaff(Staff staff, String roleId, Integer orgId) {
        Staff sf = staffDao.getById(staff.getId());
        sf.setRealname(staff.getRealname());
        sf.setName(staff.getName());
        //sf.setPassword(staff.getPassword());
        String[] roleIds = roleId.split(",");
        Set<StaffRole> roles = new HashSet<StaffRole>();
        if (roleIds != null && roleIds.length != 0) {
            for (String rId : roleIds) {
                StaffRole staffRole = staffRoleService.getStaffRoleById(Integer.parseInt(rId));
                if (Strings.isNullOrEmpty(sf.getRoleName())) {
                    sf.setRoleName(staffRole.getRoleName());
                } else {
                    sf.setRoleName(sf.getRoleName() + ";" + staffRole.getRoleName());
                }
                roles.add(staffRole);
            }
        }
        sf.setRoles(roles);

        staffDao.updateStaff(sf);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public void updateStatus(Integer id, boolean falg) {
        Staff staff = staffDao.getById(id);
        staff.setEnable(falg);
        staffDao.updateStaff(staff);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff updateGoogle(Integer id,String googleSec){
        Staff staff = getStaffById(id);
        staff.setGoogleSecurity(googleSec);
        staffDao.update(staff);
        return staff;
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public void updateGoogleBind(Integer id,Boolean googleBind){
        Staff staff = getStaffById(id);
        staff.setGoogleAuth(googleBind);
        staffDao.update(staff);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff updatePersistStaff(Staff staff){
        return staffDao.updateStaff(staff);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public void updateStaff(Staff staff) {
        String realname = staff.getRealname();
        if (Strings.isNullOrEmpty(realname)) {
            throw new StaffException(messageSource.getMessage("real.name.is.not.null"));
        }
        String name = staff.getName();
        if (Strings.isNullOrEmpty(name)) {
            throw new StaffException(messageSource.getMessage("real.name.is.not.null"));
        }
        Staff staffById = getStaffById(staff.getId());
        if (null == staffById) {
            throw new StaffException(messageSource.getMessage("role.is.not.fund"));
        }

        staffById.setName(name);
        staffById.setRealname(realname);
        staffById.setPassword(MD5Util.digest(staff.getPassword()));
        staffDao.updateStaff(staffById);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public boolean updatePassword(Staff newStaff, String oldPassword) {
        boolean falg = false;
        Staff old = staffDao.getById(newStaff.getId());
        if (old == null) {
            return false;
        }
        if (!MD5Util.digest(oldPassword).equals(old.getPassword())) {
            return false;
        }
        old.setPassword(MD5Util.digest(newStaff.getPassword()));
        Staff staff = staffDao.updateStaff(old);
        return staff != null;
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff add(Staff staff) {
        return staffDao.save(staff);
    }


    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffService#updateStaff(int, java.lang.String, boolean, com.qianmama.common.staff.StaffRoleType)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public Staff updateStaff(int staffId, String realName, boolean enable, String enName) {
        if (Strings.isNullOrEmpty(realName)) {
            throw new StaffException(messageSource.getMessage("real.name.is.not.null"));
        }
        if (Strings.isNullOrEmpty(enName)) {
            throw new StaffException(messageSource.getMessage("role.is.not.null"));
        }
        Staff staff = getStaffById(staffId);
        if (null == staff) {
            throw new StaffException(messageSource.getMessage("role.is.not.fund"));
        }
        staff.setRealname(realName);
        staff.setEnable(enable);
        Set<StaffRole> roles = new HashSet<StaffRole>();
        StaffRole staffRole = staffRoleService.getByEnName(enName);
        roles.add(staffRole);
        staff.setRoles(roles);

        return staffDao.update(staff);
    }


}
