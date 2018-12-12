package com.shop.admin.controller.support;

import com.mine.bizservice.CurrencyService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.response.Response;
import com.mine.common.vo.CurrencyIntroductionVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.supportservice.service.CurrencyIntroductionService;
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
@RequestMapping("currencyIntroduct")
@Scope(BaseController.REQUEST_SCOPE)
public class CurrencyIntroductController extends BaseController {
	@Autowired
	private CurrencyIntroductionService currencyIntroductionService;
	@Autowired
	private CurrencyService currencyService;
	@Autowired
	private StaffOperationLogService staffOperationLogService;

	@OperatorLogger(operatorName = "进入币种介绍管理")
	@RequestMapping("index")
	public ModelAndView index() {
		ModelAndView mv = new ModelAndView("currencyIntroduct/index");
		List<CurrencyVo> currencys = currencyService.listAllEnable();
		mv.addObject("currencys", currencys);
		return mv;
	}

	@OperatorLogger(operatorName = "进入添加币种介绍页面")
	@RequestMapping("addInput")
	public ModelAndView addInput() {
		ModelAndView mv = new ModelAndView("currencyIntroduct/add");
		List<CurrencyVo> currencys = currencyService.listAllEnable();
		mv.addObject("currencys", currencys);
		return mv;
	}

	@OperatorLogger(operatorName = "进入修改币种介绍页面")
	@RequestMapping("updateInput")
	public ModelAndView updateInput(Long id) {
		ModelAndView mv = new ModelAndView("currencyIntroduct/edit");
		List<CurrencyVo> currencys = currencyService.listAllEnable();
		CurrencyIntroductionVo vo = currencyIntroductionService.getById(id);
		mv.addObject("currencys", currencys);
		mv.addObject("vo", vo);
		return mv;
	}

	@ResponseBody
	@RequestMapping("list")
	@OperatorLogger(operatorName = "获取所有币种介绍(后台)")
	public Object list(CurrencyIntroductionVo categoryVo,
					   @RequestParam(value = "offset", defaultValue = "0") Integer from,
					   @RequestParam(value = "limit", defaultValue = "10") Integer limit) {
		int total = currencyIntroductionService.count(categoryVo);
		if (total > 0) {
			list = currencyIntroductionService.list(categoryVo, from, limit);
		}
		result = true;
		return Response.listSuccess(total, list, "查询成功");
	}

	@ResponseBody
	@RequestMapping("add")
	@OperatorLogger(operatorName = "添加币种介绍(后台)")
	public Object add(CurrencyIntroductionVo categoryVo) {
		//if (StringUtils.isEmpty(categoryVo.getCategory())
		//		|| StringUtils.isEmpty(categoryVo.getInternationalType())
		//		|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null) {
		//	Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
		//	response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
		//	return response;
		//}
		currencyIntroductionService.add(categoryVo);
		//记录用户操作日志
		Staff staff = SecurityUtil.currentLogin();
		staffOperationLogService.addStaffOperationLog("新增币种介绍",staff.getRealname()+"-新增币种介绍："+categoryVo.getName(),staff.getId(),staff.getRealname());
		return Response.simpleSuccess();
	}

	/**
	 * 更新Banner信息
	 */
	@RequestMapping("/update")
	@OperatorLogger(operatorName = "修改币种介绍")
	@ResponseBody
	public Object update(CurrencyIntroductionVo categoryVo) {
		//if (StringUtils.isEmpty(categoryVo.getCategory())
		//		|| StringUtils.isEmpty(categoryVo.getInternationalType())
		//		|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null) {
		//	Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
		//	response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
		//	return response;
		//}
		currencyIntroductionService.update(categoryVo);
		//记录用户操作日志
		Staff staff = SecurityUtil.currentLogin();
		staffOperationLogService.addStaffOperationLog("修改币种介绍",staff.getRealname()+"-修改币种介绍："+categoryVo.getName(),staff.getId(),staff.getRealname());
		return Response.simpleSuccess();
	}
}
