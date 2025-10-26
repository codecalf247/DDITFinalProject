package kr.or.ddit.vo;

import lombok.Data;

@Data
public class TreeVO {
	private int id;
	private String parent;
	private String text;
	private String icon;
	private String deptName;
}

