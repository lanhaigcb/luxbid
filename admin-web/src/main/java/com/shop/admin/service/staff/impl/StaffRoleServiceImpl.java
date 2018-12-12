/**
 *
 */
package com.shop.admin.service.staff.impl;

import com.google.common.base.Strings;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.dao.staff.StaffRoleDao;
import com.shop.admin.model.staff.FunctionInfo;
import com.shop.admin.model.staff.StaffRole;
import com.shop.admin.service.staff.FunctionInfoService;
import com.shop.admin.service.staff.StaffRoleService;
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
@Service("staffRoleService")
public class StaffRoleServiceImpl implements StaffRoleService {

	@Autowired
	private StaffRoleDao staffRoleDao;
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private FunctionInfoService functionInfoService;

	/* (non-Javadoc)
	 * @see com.qianmama.service.staff.StaffRoleService#addStaffRole(com.qianmama.model.staff.StaffRole)
	 */
	@Transactional(propagation= Propagation.REQUIRED,rollbackFor=RuntimeException.class)
	public StaffRole addStaffRole(boolean enable, String name, String enName){
		
		if(Strings.isNullOrEmpty(name)){
			throw new StaffException(messageSource.getMessage("staff.role.name.is.not.null"));
		}
		if(Strings.isNullOrEmpty(enName)){
			throw new StaffException(messageSource.getMessage("staff.role.enname.is.not.null"));
		}
		StaffRole staffRole = getByName(name);
		if(null != staffRole){
			throw new StaffException(messageSource.getMessage("staff.role.name.is.exsit"));
		}
		staffRole = getByEnName(enName);
		if(null != staffRole){
			throw new StaffException(messageSource.getMessage("staff.role.enname.is.exsit"));
		}
		staffRole = new StaffRole();
		staffRole.setCreateTime(new Date());
		staffRole.setEnable(enable);
		staffRole.setFunctionInfos(null);
		staffRole.setRoleEnName(enName);
		staffRole.setRoleName(name);
		
		return staffRoleDao.addStaffRole(staffRole);
	}

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#disableStaffRole(int)
     */
    @Transactional(propagation= Propagation.REQUIRED,rollbackFor=RuntimeException.class)
    public StaffRole disableStaffRole(int id) {
    	StaffRole staffRole = getStaffRoleById(id);
    	if(null == staffRole){
			throw new StaffException(messageSource.getMessage("staff.role.type.is.not.exsit"));
		}
    	int count = staffRoleDao.getRoleIsUsingStaffCount(id);
    	if(count > 0){
    		throw new StaffException(messageSource.getMessage("staff.role.is.usin"));
    	}
    	staffRole.setEnable(false);
        return staffRoleDao.updateStaffRole(staffRole);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#enableStaffRole(int)
     */
    @Transactional(propagation= Propagation.REQUIRED,rollbackFor=RuntimeException.class)
    public StaffRole enableStaffRole(int id) {
    	StaffRole staffRole = getStaffRoleById(id);
    	if(null == staffRole){
			throw new StaffException(messageSource.getMessage("staff.role.type.is.not.exsit"));
		}
    	staffRole.setEnable(true);
        return staffRoleDao.updateStaffRole(staffRole);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#findStaffRolesByFunctionId(int)
     */
    @Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
    public List<StaffRole> findStaffRolesByFunctionId(int functionId) {
        return null;
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#getCount()
     */
    @Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
    public int getCount() {
        return staffRoleDao.getCount();
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#getStaffRoleById(int)
     */
    @Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
    public StaffRole getStaffRoleById(int id) {
        return staffRoleDao.getById(id);
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#listAll()
     */
    @Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
    public List<StaffRole> listAll() {
        return staffRoleDao.listAll();
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.StaffRoleService#listAll(int, int)
     */
    @Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
    public List<StaffRole> listAll(int from, int pageSize) {
        return staffRoleDao.ListAll(from, pageSize);
    }


	/* (non-Javadoc)
	 * @see com.qianmama.service.staff.StaffRoleService#getByType(com.qianmama.common.staff.StaffRoleType)
	 */
	@Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
	public StaffRole getByName(String name) {
		return staffRoleDao.getByname(name);
	}
	
	@Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
	public StaffRole getByEnName(String enName) {
		return staffRoleDao.getByEnName(enName);
	}

	/* (non-Javadoc)
	 * @see com.qianmama.service.staff.StaffRoleService#listAllEnable()
	 */
	@Transactional(propagation= Propagation.SUPPORTS,readOnly=true)
	public List<StaffRole> listAllEnable() {
		return staffRoleDao.listAll();
	}



	@Transactional(propagation= Propagation.REQUIRED,rollbackFor=RuntimeException.class)
	public StaffRole authorityUpdateStaff(Integer staffRoleId,String ids){
		StaffRole staffRole = getStaffRoleById(staffRoleId);
		if(null == staffRole){
			throw new StaffException(messageSource.getMessage("staff.role.type.is.not.exsit"));
		}
		if(null == ids || "".equals(ids)){
			staffRole.setFunctionInfos(null);
		} else {
		
			String[] idArr = ids.split(",");
			Set<FunctionInfo> infos = new HashSet<FunctionInfo>();
			for(String idStr : idArr){
				FunctionInfo info = functionInfoService.getFunctionInfoById(Integer.parseInt(idStr));
				infos.add(info);
			}
			staffRole.setFunctionInfos(infos);
		}
		return staffRoleDao.updateStaffRole(staffRole);
	}

	@Override
	@Transactional(propagation= Propagation.REQUIRED,rollbackFor=RuntimeException.class)
	public StaffRole update(StaffRole staffRole) {
		StaffRole sr = staffRoleDao.getById(staffRole.getId());
		if (sr == null){
			throw new StaffException(messageSource.getMessage("staff.role.type.is.not.exsit"));
		}
		List<StaffRole> roles = staffRoleDao.getListByEnName(staffRole.getRoleEnName());
		if (roles == null){
			throw new StaffException(messageSource.getMessage("staff.role.type.is.not.exsit"));
		}
		if (roles.size() > 1){
			throw new StaffException(messageSource.getMessage("staff.role.enname.is.exsit"));
		}

		sr.setRoleName(staffRole.getRoleName());
		sr.setRoleEnName(staffRole.getRoleEnName());
		sr.setEnable(staffRole.getEnable());
		return staffRoleDao.updateStaffRole(sr);

	}

}
