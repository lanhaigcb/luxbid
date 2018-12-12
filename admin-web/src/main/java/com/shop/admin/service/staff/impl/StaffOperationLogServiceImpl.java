package com.shop.admin.service.staff.impl;

import com.google.common.base.Strings;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.dao.staff.StaffOperationLogDao;
import com.shop.admin.model.staff.StaffOperationLog;
import com.shop.admin.service.staff.StaffOperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("staffOperationLogServiceImpl")
public class StaffOperationLogServiceImpl implements StaffOperationLogService {

    @Autowired
    private StaffOperationLogDao staffOperationLogDao;
    @Autowired
    private MessageSource messageSource;

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public StaffOperationLog addStaffOperationLog(String name, String content, Integer staffId, String staffRealName) {
        if (Strings.isNullOrEmpty(name)) {
            throw new StaffException(messageSource.getMessage("name.is.not.null"));
        }
        if (Strings.isNullOrEmpty(content)) {
            throw new StaffException(messageSource.getMessage("content.is.not.null"));
        }
        if (staffId==null) {
            throw new StaffException(messageSource.getMessage("staffId.not.null"));
        }
        if (Strings.isNullOrEmpty(staffRealName)) {
            throw new StaffException(messageSource.getMessage("staffRealName.not.null"));
        }
        StaffOperationLog staffOperationLog = new StaffOperationLog();
        staffOperationLog.setName(name);
        staffOperationLog.setContent(content);
        staffOperationLog.setStaffId(staffId);
        staffOperationLog.setStaffRealName(staffRealName);
        staffOperationLog.setCreateTime(new Date());
        return staffOperationLogDao.save(staffOperationLog);
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public long getTotalCount(String name, Date startDate, Date endDate) {
        return staffOperationLogDao.totalCount(name,startDate,endDate);
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<StaffOperationLog> listAll(int from, int pageSize,String name, Date startDate, Date endDate) {
        return staffOperationLogDao.list(from, pageSize,name,startDate,endDate);
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<Map<String, Object>> getTitleTypeList(){
        return staffOperationLogDao.getTitleTypeList();
    }

}
