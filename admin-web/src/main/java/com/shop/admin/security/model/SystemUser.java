package com.shop.admin.security.model;



import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import com.shop.admin.model.staff.Staff;
import com.shop.admin.model.staff.StaffRole;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


public class SystemUser implements UserDetails{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6403754169996141584L;

	private Staff staff;

	private long lastUpdateTime;


	public SystemUser(Staff staff) {
		super();
		this.staff = staff;
		this.lastUpdateTime = System.currentTimeMillis();
	}

	public Collection<? extends GrantedAuthority> getAuthorities() {
		List<GrantedAuthority> list = new LinkedList<GrantedAuthority>();
		Set<StaffRole> roles = staff.getRoles();
		if(null != roles && roles.size() != 0){
			for(StaffRole role : roles){
				list.add(new SimpleGrantedAuthority(role.getRoleEnName()));
			}
		}
		
		return list;
	}

	public String getPassword() {
		return staff.getPassword();
	}

	public String getUsername() {
		return staff.getName();
	}

	public boolean isAccountNonExpired() {
		return true;
	}

	public boolean isAccountNonLocked() {
		return true;
	}

	public boolean isCredentialsNonExpired() {
		return true;
	}

	public boolean isEnabled() {
		return staff.getEnable();
	}

	public Staff getStaff() {
		return staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}
	
	@Override
	public boolean equals(Object obj) {
		
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		final SystemUser other = (SystemUser) obj;
		if (this.staff.getId().intValue() != other.staff.getId().intValue()) {
			return false;
		}
		
		return true;
	}

	@Override
	public int hashCode() {
		int result = 31;
		if(null == staff){
			return super.hashCode();
		}
		result = 11 * result + (int) staff.getId();
		return result;
	}

	public long getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(long lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}
}
