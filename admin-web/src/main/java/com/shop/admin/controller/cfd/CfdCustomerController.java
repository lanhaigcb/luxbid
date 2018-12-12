package com.shop.admin.controller.cfd;

import com.mine.bizservice.CfdNodeService;
import com.mine.common.enums.VolunteerStatus;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.cfd.CfdCustomerVo;
import com.mine.common.vo.cfd.CfdNodeVo;
import com.shop.admin.controller.BaseController;
import com.mine.userservice.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 合约用户管理
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("cfdCustomer")
public class CfdCustomerController extends  BaseController {

    @Autowired
    private UserService userService;
    @Autowired
    private CfdNodeService cfdNodeService;
    @Autowired
    private MessageSource messageSource;

    /**
     * 跳转用户管理的页面
     * @param modelMap
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "index")
    public String customerIndex(ModelMap modelMap){
        List<CfdNodeVo> list = cfdNodeService.list(new CfdNodeVo(),0,Integer.MAX_VALUE);
        modelMap.addAttribute("nodes",list);
        return "cfdCustomer/index";
    }

    /**
     * 修改代理商状态
     * @param customerId
     * @param status
     * @return
     */
    @ResponseBody
    @RequestMapping("enableAgent")
    public Object enableAgent(Integer customerId, VolunteerStatus status)
    {
        CustomerVo customerInfo = userService.getCustomerById(customerId);
        if(customerInfo!=null)
        {
            userService.updateUserVolunteerStatus(customerId,status);
        }
        result = true;
        message = "修改成功";
        return  getResultMap();
    }


    /**
     * 获取用户列表页的方法
     * @param cfdCustomerVo
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "list")
    public Map<String,Object> findList(CfdCustomerVo cfdCustomerVo, Integer offset, Integer limit, Date lastStartDate, Date lastEndDate, Date regStartDate, Date regEndDate){
       total = userService.getCustomerCount(cfdCustomerVo,lastStartDate,lastEndDate,regStartDate,regEndDate);
       if(total>0){
           List<CfdCustomerVo> customerVoList = userService.getCustomerVoList(cfdCustomerVo, getOffset(offset), getLimit(limit), lastStartDate, lastEndDate, regStartDate, regEndDate);
           list=customerVoList==null?null:customerVoList;
       }
        result = true;
        message = "查询成功";
        return  getResultMap();
    }


    /**
     * 跳转修改用户页面的方法
     * @param modelMap
     * @param id
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "updateIndex")
    public String updateCustomerIndex(ModelMap modelMap,Integer id){
        CustomerVo customerById = userService.getCustomerById(id);
        modelMap.addAttribute("customer",customerById);
        return  "cfdCustomer/edit";
    }

    /**
     * 修改用户的方法
     * @param customerVo
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "update")
    public Map<String, Object> updateCustomer(CustomerVo customerVo){
        try {
            userService.updateCustomerRate(customerVo);
            result = true;
            message = messageSource.getMessage("customer.update.success");
            return getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("customer.update.failed");
            return getResultMap();
        }

    }
}
