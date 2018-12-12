package com.shop.admin.controller.support;

import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.mine.common.suportVo.HelpCategoryDetailVo;
import com.mine.common.suportVo.HelpCategoryVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.supportservice.service.HelpCategoryDetailService;
import com.mine.supportservice.service.HelpCategoryService;
import com.mine.util.string.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 *
 */
@Controller
@RequestMapping("helpDetail")
@Scope(BaseController.REQUEST_SCOPE)
public class HelpDetailController extends BaseController {
	@Autowired
	private HelpCategoryDetailService helpCategoryDetailService;
	@Autowired
	private HelpCategoryService helpCategoryService;

	@Autowired
	private StaffOperationLogService staffOperationLogService;

	@OperatorLogger(operatorName = "进入帮助中心明细管理")
	@RequestMapping("index")
	public String index(ModelMap modelMap) {
		List<HelpCategoryVo> categoryVoList = helpCategoryService.list();
		modelMap.addAttribute("categoryVoList", categoryVoList);
		return "helpDetail/index";
	}


	@OperatorLogger(operatorName = "进入添加帮助中心明细页面")
	@RequestMapping("addInput")
	public String addInput(ModelMap modelMap) {
		List<HelpCategoryVo> categoryVoList = helpCategoryService.list();
		modelMap.addAttribute("categoryVoList", categoryVoList);
		return "helpDetail/add";
	}

	@OperatorLogger(operatorName = "进入修改帮助中心明细页面")
	@RequestMapping("updateInput")
	public ModelAndView updateInput(Long id) {
		ModelAndView mv = new ModelAndView("helpDetail/edit");
		HelpCategoryDetailVo categoryVo = helpCategoryDetailService.getById(id);
		mv.addObject("categoryVo", categoryVo);

		List<HelpCategoryVo> categoryVoList = helpCategoryService.list();
		mv.addObject("categoryVoList", categoryVoList);
		return mv;
	}

	@ResponseBody
	@RequestMapping("list")
	@OperatorLogger(operatorName = "获取所有帮助中心明细(后台)")
	public Object list(HelpCategoryDetailVo categoryVo,
					   @RequestParam(value = "offset", defaultValue = "0") Integer offset,
					   @RequestParam(value = "limit", defaultValue = "10") Integer limit) {
		int total = helpCategoryDetailService.count(categoryVo);
		if (total > 0) {
			list = helpCategoryDetailService.list(categoryVo, getOffset(offset), getLimit(limit));
		}
		result = true;
		return Response.listSuccess(total, list, "查询成功");
	}

	@ResponseBody
	@RequestMapping("add")
	@OperatorLogger(operatorName = "添加帮助中心明细(后台)")
	public Object add(HelpCategoryDetailVo categoryVo) {
		if (StringUtils.isEmpty(categoryVo.getTitle())
				|| categoryVo.getHelpCategoryId() == null
				|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null
				|| StringUtils.isEmpty(categoryVo.getContent())) {
			Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
			response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
			return response;
		}
		helpCategoryDetailService.add(categoryVo);
		//记录用户操作日志
		Staff staff = SecurityUtil.currentLogin();
		staffOperationLogService.addStaffOperationLog("新增帮助中心明细",staff.getRealname()+"-新增帮助中心明细："+categoryVo.getTitle(),staff.getId(),staff.getRealname());
		return Response.simpleSuccess();
	}

	/**
	 * 更新Banner信息
	 */
	@RequestMapping("/update")
	@OperatorLogger(operatorName = "修改帮助中心明细")
	@ResponseBody
	public Object update(HelpCategoryDetailVo categoryVo) {
		if (StringUtils.isEmpty(categoryVo.getTitle())
				|| categoryVo.getHelpCategoryId() == null
				|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null
				|| StringUtils.isEmpty(categoryVo.getContent())) {
			Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
			response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
			return response;
		}
		helpCategoryDetailService.update(categoryVo);
		Staff staff = SecurityUtil.currentLogin();
		staffOperationLogService.addStaffOperationLog("修改帮助中心明细",staff.getRealname()+"-修改帮助中心明细："+categoryVo.getTitle(),staff.getId(),staff.getRealname());
		return Response.simpleSuccess();
	}
}
