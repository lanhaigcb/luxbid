package com.shop.admin.controller.support;

import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.mine.common.suportVo.HelpCategoryVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.supportservice.service.HelpCategoryService;
import com.mine.util.string.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 */
@Controller
@RequestMapping("help")
@Scope(BaseController.REQUEST_SCOPE)
public class HelpController extends BaseController {
	@Autowired
	private HelpCategoryService helpCategoryService;

	@Autowired
	private StaffOperationLogService staffOperationLogService;

	@OperatorLogger(operatorName = "进入帮助中心分类管理")
	@RequestMapping("index")
	public String index() {
		return "help/index";
	}


	@OperatorLogger(operatorName = "进入添加帮助中心分类页面")
	@RequestMapping("addInput")
	public String addInput() {
		return "help/add";
	}

	@OperatorLogger(operatorName = "进入修改帮助中心分类页面")
	@RequestMapping("updateInput")
	public ModelAndView updateInput(Long id) {
		ModelAndView mv = new ModelAndView("help/edit");
		HelpCategoryVo categoryVo = helpCategoryService.getById(id);
		mv.addObject("categoryVo", categoryVo);
		return mv;
	}

	@ResponseBody
	@RequestMapping("list")
	@OperatorLogger(operatorName = "获取所有帮助中心分类(后台)")
	public Object list(HelpCategoryVo categoryVo,
					   @RequestParam(value = "offset", defaultValue = "0") Integer offset,
					   @RequestParam(value = "limit", defaultValue = "10") Integer limit) {
		int total = helpCategoryService.count(categoryVo);
		if (total > 0) {
			list = helpCategoryService.list(categoryVo, getOffset(offset), getLimit(limit));
		}
		result = true;
		return Response.listSuccess(total, list, "查询成功");
	}

	@ResponseBody
	@RequestMapping("add")
	@OperatorLogger(operatorName = "添加帮助中心分类(后台)")
	public Object add(HelpCategoryVo categoryVo) {
		if (StringUtils.isEmpty(categoryVo.getCategory())
				|| StringUtils.isEmpty(categoryVo.getInternationalType())
				|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null) {
			Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
			response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
			return response;
		}
		helpCategoryService.add(categoryVo);
		//记录用户操作日志
		Staff staff = SecurityUtil.currentLogin();
		staffOperationLogService.addStaffOperationLog("新增帮助中心分类",staff.getRealname()+"-新增帮助中心分类："+categoryVo.getCategory(),staff.getId(),staff.getRealname());
		return Response.simpleSuccess();
	}

	/**
	 * 更新Banner信息
	 */
	@RequestMapping("/update")
	@OperatorLogger(operatorName = "修改帮助中心分类")
	@ResponseBody
	public Object update(HelpCategoryVo categoryVo) {
		if (StringUtils.isEmpty(categoryVo.getCategory())
				|| StringUtils.isEmpty(categoryVo.getInternationalType())
				|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null) {
			Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
			response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
			return response;
		}
		helpCategoryService.update(categoryVo);
		//记录用户操作日志
		Staff staff = SecurityUtil.currentLogin();
		staffOperationLogService.addStaffOperationLog("修改帮助中心分类",staff.getRealname()+"-修改帮助中心分类："+categoryVo.getCategory(),staff.getId(),staff.getRealname());
		return Response.simpleSuccess();
	}
}
