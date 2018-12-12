package com.shop.admin.controller.user;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.enums.RegisterType;
import com.mine.common.enums.WhiteListApplyStatus;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.ExchangeVo;
import com.mine.common.vo.ResultVo;
import com.mine.common.vo.admin.AdminWhiteListApplyVo;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.userservice.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by yaojunbing on 2018/4/16.
 */
@Controller
@RequestMapping("whitelist")
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class WhiteListController extends BaseController {
	@Autowired
	private AdminService adminService;

	@Autowired
	private ExchangeService exchangeService;

	@Autowired
	private StaffOperationLogService staffOperationLogService;

	@Autowired
	private UserService userService;

	@RequestMapping("index")
	public String index(ModelMap modelMap) {
		List<ExchangeVo> voList = exchangeService.listAllExchange();
		modelMap.addAttribute("voList", voList);
		return "whitelist/index";
	}


	@ResponseBody
	@RequestMapping("list")
	public Object list(@RequestParam(value = "offset", defaultValue = "0") Integer offset,
					   @RequestParam(value = "size", defaultValue = "10") Integer size,
					   AdminWhiteListApplyVo vo) {
		total = adminService.countWhiteList(vo);
		if (total > 0) {
			list = adminService.listWhiteList(getOffset(offset), getPageSize(size), vo);
		}
		return getResultMap();
	}

	@ResponseBody
	@RequestMapping("pass")
	public Object pass(Integer id, Boolean pass, String note,String  applyType) {
		if (pass == null){
			result = false;
			message = "审核结果不能为空";
			return getResultMap();
		}
		Staff staff = SecurityUtil.currentLogin();
		ResultVo vo = adminService.whiteListaudit(pass, id, staff.getId(), staff.getName(), note, applyType);
		if(vo.isSuccess()){
			//记录用户操作日志
			String auditResult;
			if(pass){
				auditResult="审核通过";
			}else{
				auditResult="审核不通过";
			}
			AdminWhiteListApplyVo apply = adminService.getById(id);
			CustomerVo customerVo = userService.getCustomerById(apply.getCustomerId());
			String account = customerVo.getRegType().equals(RegisterType.EMAIL) ? customerVo.getEmail() : customerVo.getMobile();
			staffOperationLogService.addStaffOperationLog("白名单审核",staff.getRealname()+"-白名单审核："+account+"("+customerVo.getRealName()+")"+auditResult,staff.getId(),staff.getRealname());
			result = true;
			message = "成功";
		}else{
			result = false;
			message = "审核失败";
		}
		return getResultMap();
	}

	@RequestMapping("auditInput")
	public String auditInput(Integer id, ModelMap modelMap) {
		modelMap.addAttribute("id", id);
		return "whitelist/audit";
	}

}
