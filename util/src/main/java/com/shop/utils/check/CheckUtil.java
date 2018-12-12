package com.shop.utils.check;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 校验工具类
 */
public class CheckUtil {

	/**
	 * 是否是邮箱
	 *
	 * @param email
	 * @return
	 */
	public static boolean checkEmail(String email) {
		boolean flag = false;
		try {
			String check = "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
			Pattern regex = Pattern.compile(check);
			Matcher matcher = regex.matcher(email);
			flag = matcher.matches();
		} catch (Exception e) {
			flag = false;
		}
		return flag;
	}

	/**
	 * 验证手机号码，11位数字，1开通，第二位数必须是3456789这些数字之一 *
	 *
	 * @param mobileNumber
	 * @return
	 */
	public static boolean checkMobileNumber(String mobileNumber) {
		boolean flag = false;
		try {
			// Pattern regex = Pattern.compile("^(((13[0-9])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8})|(0\\d{2}-\\d{8})|(0\\d{3}-\\d{7})$");
			Pattern regex = Pattern.compile("^1[3456789]\\d{9}$");
			Matcher matcher = regex.matcher(mobileNumber);
			flag = matcher.matches();
		} catch (Exception e) {
			e.printStackTrace();
			flag = false;

		}
		return flag;
	}

	/**
	 * 8-16位数字密码组合
	 *
	 * @param loginPassword
	 * @return
	 */
	public static boolean checkLoginPassword(String loginPassword) {
//		String regex = "^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[~!@#$%^&*_+])).{8,24}$";
		String regex = "^(?:(?=.*[A-Za-z])(?=.*[0-9])).{8,24}$";
		return loginPassword.matches(regex);
	}

	/**
	 * 6位纯数字
	 * @param payPassword
	 * @return
	 */
	public static boolean checkPayPassword(String payPassword){
		String regex = "^\\d{6}$";
		return payPassword.matches(regex);
	}


	public static void main(String[] args) {
		String regex = "^\\d{6}$";
		String value = "11111";
		System.out.println(value.matches(regex));
	}
}
