package com.shop.admin.controller.support;

import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.mine.common.vo.mobile.MobileUpdateLogVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.mine.supportservice.service.MobileUpdateLogService;
import com.mine.util.string.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * Created by yaojunbing on 2018/4/3.
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
@RequestMapping("mobileUpdateLog")
public class MobileUpdateLogController extends BaseController {
	@Autowired
	private MobileUpdateLogService mobileUpdateLogService;

	@OperatorLogger(operatorName = "进入手机更新日志管理")
	@RequestMapping("index")
	public String index() {
		return "updateLog/index";
	}


	@OperatorLogger(operatorName = "进入添加手机更新日志管理页面")
	@RequestMapping("addInput")
	public String addInput() {
		return "updateLog/add";
	}

	@OperatorLogger(operatorName = "进入修改手机更新日志管理页面")
	@RequestMapping("updateInput")
	public ModelAndView updateInput(Long id) {
		ModelAndView mv = new ModelAndView("updateLog/edit");
		MobileUpdateLogVo categoryVo = mobileUpdateLogService.getById(id);
		mv.addObject("categoryVo", categoryVo);
		return mv;
	}

	@ResponseBody
	@RequestMapping("add")
	@OperatorLogger(operatorName = "添加手机更新日志管理后台)")
	public Object add(MobileUpdateLogVo vo) {
		if (StringUtils.isEmpty(vo.getLog())
				|| vo.getTime() == null
				|| vo.getVersion() == null) {
			Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
			response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
			return response;
		}
		mobileUpdateLogService.add(vo);
		return Response.simpleSuccess();
	}

	@ResponseBody
	@RequestMapping("list")
	@OperatorLogger(operatorName = "获取所有手机更新日志管理(后台)")
	public Object list(@RequestParam(value = "offset", defaultValue = "0") Integer from,
					   @RequestParam(value = "size", defaultValue = "10") Integer size) {
		total = mobileUpdateLogService.count();
		if (total > 0) {
			list = mobileUpdateLogService.list(from, size);
		}
		result = true;
		return Response.listSuccess(total, list, "查询成功");
	}


	/**
	 * 更新Banner信息
	 */
	@RequestMapping("/update")
	@OperatorLogger(operatorName = "修改帮助中心明细")
	@ResponseBody
	public Object update(MobileUpdateLogVo vo) {
		if (StringUtils.isEmpty(vo.getLog())
				|| vo.getTime() == null
				|| vo.getVersion() == null) {
			Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
			response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
			return response;
		}
		mobileUpdateLogService.update(vo);
		return Response.simpleSuccess();
	}
}
