/**
 *
 */
package com.shop.admin.service.staff.impl;

import com.google.common.base.Strings;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.dao.staff.FunctionInfoDao;
import com.shop.admin.model.staff.FunctionInfo;
import com.shop.admin.security.staff.AuthorityVo;
import com.shop.admin.service.staff.FunctionInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 */
@Service("functionInfoService")
public class FunctionInfoServiceImpl implements FunctionInfoService {

    @Autowired
    private FunctionInfoDao functionInfoDao;

    @Autowired
    private MessageSource messageSource;

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public FunctionInfo addFunctionInfo(String name, String uri, boolean enable, Integer parentId) {
        //根据提交的功能名字去查询有无此功能
        if (Strings.isNullOrEmpty(name)) {
            throw new StaffException(messageSource.getMessage("function.info.name.is.not.null"));
        }
        if (Strings.isNullOrEmpty(uri)) {
            throw new StaffException(messageSource.getMessage("function.info.uri.is.not.null"));
        }
        FunctionInfo functionInfo = new FunctionInfo();
        functionInfo.setName(name);
        functionInfo.setEnable(enable);
        functionInfo.setCreateTime(new Date());
        functionInfo.setUri(uri);
        functionInfo.setParentId(parentId);
        return functionInfoDao.addFunctionInfo(functionInfo);
    }

    /**
     * 根据 parentId查询 总记录数
     *
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public int getCountByParenId(Integer parentId) {
        return functionInfoDao.getCountByParenId(parentId);
    }

    /**
     * 根据父亲id分页查询孩子数据
     *
     * @param parentId
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<FunctionInfo> findPageFunctionInfosByParenId(Integer parentId, int from, int pageSize) {
        return functionInfoDao.findPageFunctionInfosByParenId(parentId, from, pageSize);
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<FunctionInfo> findFunctionInfosByParenId(Integer parentId) {
        return functionInfoDao.findFunctionInfosByParenId(parentId);
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public FunctionInfo getFunctionInfoById(int id) {

        return functionInfoDao.getById(id);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public FunctionInfo updateFunctionInfo(Integer functionInfoId, String name, String uri) {
        FunctionInfo functionInfo = functionInfoDao.getById(functionInfoId);
        if (null == functionInfo) {
            throw new RuntimeException("functionInfo.is.not.exsit");
        }
        if (Strings.isNullOrEmpty(name)) {
            throw new StaffException(messageSource.getMessage("function.info.name.is.not.null"));
        }
        if (Strings.isNullOrEmpty(uri)) {
            throw new StaffException(messageSource.getMessage("function.info.uri.is.not.null"));
        }
        functionInfo.setName(name);
        functionInfo.setUri(uri);
        return functionInfoDao.updateFunctionInfo(functionInfo);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public FunctionInfo enable(int id) {
        FunctionInfo temFunctionInfo = functionInfoDao.getById(id);
        if (temFunctionInfo == null) {
            throw new RuntimeException("functioninfp.name.exists");
        }
        temFunctionInfo.setEnable(true);
        return functionInfoDao.updateFunctionInfo(temFunctionInfo);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public FunctionInfo disable(int id) {
        FunctionInfo temFunctionInfo = functionInfoDao.getById(id);
        if (temFunctionInfo == null) {
            throw new RuntimeException("functioninfp.name.exists");
        }
        temFunctionInfo.setEnable(false);
        return functionInfoDao.updateFunctionInfo(temFunctionInfo);
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public int getCount() {
        return functionInfoDao.getCount();
    }

    /**
     * 查询所有的功能信息
     *
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<FunctionInfo> listAll() {
        return functionInfoDao.listAll();
    }

    /**
     * 查询所有的功能信息(不查询孩子节点信息)
     *
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    public List<Map<String, Object>> listNoChildrenAll() {

        return functionInfoDao.listNoChildrenAll();
    }

    /* (non-Javadoc)
     * @see com.qianmama.service.staff.FunctionInfoService#loadResourceDefine()
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = RuntimeException.class)
    public List<AuthorityVo> loadResourceDefine(Integer functionInfoId) {
        return functionInfoDao.loadResourceDefine(functionInfoId);
    }

}
