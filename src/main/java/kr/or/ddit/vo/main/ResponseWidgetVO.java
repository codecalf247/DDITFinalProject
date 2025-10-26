package kr.or.ddit.vo.main;

import lombok.Data;

@Data
public class ResponseWidgetVO<T> {
	private WidgetVO widgetVO;
	private T data;
}
