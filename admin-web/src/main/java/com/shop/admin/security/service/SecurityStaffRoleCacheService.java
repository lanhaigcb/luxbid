/**
 */
package com.shop.admin.security.service;

import com.google.common.base.Strings;
import com.shop.admin.model.staff.FunctionInfo;
import com.shop.admin.model.staff.StaffRole;
import com.shop.admin.security.common.SecurityConf;
import com.shop.admin.security.staff.AuthorityVo;
import com.shop.admin.service.staff.FunctionInfoService;
import com.shop.admin.service.staff.FunctionInfoService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.stereotype.Service;

import java.util.*;


/**
 * 机构权限验证
 *
 */
@Service("staffRoleCacheService")
public class SecurityStaffRoleCacheService {

    private static Log logger = LogFactory.getLog(SecurityStaffRoleCacheService.class);
    public static Map<String, Collection<ConfigAttribute>> STAFF_ROLE_MAP = null;
    @Autowired
    private FunctionInfoService functionInfoService;

    /**
     * 根据相关url获取权限列表
     */
    public static Collection<ConfigAttribute> getAgencyRoleSetByURI(String uri) {
        return null == uri ? null : STAFF_ROLE_MAP.get(uri);
    }


    /**
     * 更新角色权限
     *
     * @param info
     */
    public static void updateAuthorityByFunctionInfo(FunctionInfo info, List<AuthorityVo> vos) {
        if (null == STAFF_ROLE_MAP) {
            STAFF_ROLE_MAP = new HashMap<String, Collection<ConfigAttribute>>();
        }

        STAFF_ROLE_MAP.remove(info.getUri());

        try {
            if (null != vos && vos.size() != 0) {
                for (AuthorityVo vo : vos) {
                    if (STAFF_ROLE_MAP.containsKey(vo.getUri())) {
                        Collection<ConfigAttribute> atts = STAFF_ROLE_MAP.get(vo.getUri());
                        atts.add(new SecurityConfig(vo.getRoleName()));
                        STAFF_ROLE_MAP.put(vo.getUri(), atts);
                    } else {
                        Collection<ConfigAttribute> atts = new ArrayList<ConfigAttribute>();
                        if (!Strings.isNullOrEmpty(vo.getRoleName())) {
                            atts.add(new SecurityConfig(vo.getRoleName()));
                        }
                        atts.add(new SecurityConfig(SecurityConf.DEFAULT_ROLE));
                        STAFF_ROLE_MAP.put(vo.getUri(), atts);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("update staff role by functionInfo failed!!!");
        }
    }

    /**
     * 更新角色权限
     *
     * @param role
     */
    public static void updateAuthorityByStaffRole(StaffRole role) {
        if (null == STAFF_ROLE_MAP) {
            STAFF_ROLE_MAP = new HashMap<String, Collection<ConfigAttribute>>();
        }
        // 首先将角色原来的权限移除，然后在将新的权限添加进去

        try {
            for (Map.Entry<String, Collection<ConfigAttribute>> map : STAFF_ROLE_MAP.entrySet()) {
                Collection<ConfigAttribute> attr = map.getValue();
                //首先进行判断
                Iterator<ConfigAttribute> ite = attr.iterator();
                while (ite.hasNext()) {
                    ConfigAttribute ca = ite.next();
                    String needRole = ((SecurityConfig) ca).getAttribute();
                    if (role.getRoleEnName().equals(needRole)) {
                        ite.remove();
                    }
                }
            }

            //添加新的权限
            Set<FunctionInfo> infos = role.getFunctionInfos();
            if (null == infos || infos.size() == 0) {
                return;
            }

            for (FunctionInfo info : infos) {
                if (STAFF_ROLE_MAP.containsKey(info.getUri())) {
                    Collection<ConfigAttribute> atts = STAFF_ROLE_MAP.get(info.getUri());
                    atts.add(new SecurityConfig(role.getRoleEnName()));
                    STAFF_ROLE_MAP.put(info.getUri(), atts);
                } else {
                    Collection<ConfigAttribute> atts = new ArrayList<ConfigAttribute>();
                    atts.add(new SecurityConfig(role.getRoleEnName()));
                    atts.add(new SecurityConfig(SecurityConf.DEFAULT_ROLE));
                    STAFF_ROLE_MAP.put(info.getUri(), atts);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("update staff role by staffRole failed!!!");
        }
    }

    public static Map<String, Collection<ConfigAttribute>> loadResourceDefine() {
        return STAFF_ROLE_MAP;
    }

    /**
     * 系统启动后执行
     */
    public void initStaffRoleWithURI() {
        logger.info("init staff role .....");
        try {
            List<AuthorityVo> vos = functionInfoService.loadResourceDefine(null);//获取所有的uri及对应的角色名

            STAFF_ROLE_MAP = new HashMap<String, Collection<ConfigAttribute>>();

            if (null != vos && vos.size() != 0) {
                for (AuthorityVo vo : vos) {//将URI和对应的角色名封装到用户角色集合中
                    if (STAFF_ROLE_MAP.containsKey(vo.getUri())) {
                        Collection<ConfigAttribute> atts = STAFF_ROLE_MAP.get(vo.getUri());
                        atts.add(new SecurityConfig(vo.getRoleName()));
                        STAFF_ROLE_MAP.put(vo.getUri(), atts);
                    } else {
                        Collection<ConfigAttribute> atts = new ArrayList<ConfigAttribute>();
                        if (!Strings.isNullOrEmpty(vo.getRoleName())) {
                            atts.add(new SecurityConfig(vo.getRoleName()));
                        }
                        atts.add(new SecurityConfig(SecurityConf.DEFAULT_ROLE));
                        STAFF_ROLE_MAP.put(vo.getUri(), atts);

                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("init agency role failed!!!");
        }
    }

}
