/**
 * 
 */
package com.shop.admin.model.staff;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

/**
 * 用户操作日志
 *
 */
@Entity
@Table(name="staff_operation_log")
public class StaffOperationLog implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4219947898205356995L;

	/**
	 * id
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", nullable = false)
	private Integer id;

	/**
	 * 标题
	 */
	@Column(name = "name", nullable = false, length = 16)
	private String name;

	/**
	 * 操作人Id
	 */
	@Column(name = "staffId", nullable = false, length = 16)
	private Integer staffId;

	/**
	 * 操作人真实姓名
	 */
	@Column(name = "staffRealName", nullable = false, length = 16)
	private String staffRealName;

	/**
	 * 操作内容
	 */
	@Column(name = "content", nullable = false, length = 255)
	private String content;


	/**
	 * 创建时间
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "create_time", nullable = false)
	private Date createTime;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getStaffId() {
		return staffId;
	}

	public void setStaffId(Integer staffId) {
		this.staffId = staffId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getStaffRealName() {
		return staffRealName;
	}

	public void setStaffRealName(String staffRealName) {
		this.staffRealName = staffRealName;
	}
}
