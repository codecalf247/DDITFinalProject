package kr.or.ddit.config;

import java.util.HashMap;
import java.util.Map;

/*
 *  1. new 키워드 없이 init() 함수로 생성할 수 있도록 구성
 *  	-> ParamMap.init()
 *  		-> public static paramMap init(){
 *  2. Map처럼 사용 - Map의 기능을 그대로 활용하되 키는 String, 값은 Object로 들어갈 수 있도록 구성
 *  
 *  3. 키값 입력 시 String 으로 값을 반환하는 함수 정의
 *  	String value = (String) map.get("key1");
 *  
 *  4. 키값 입력 시 Integer로 값을 반환하는 함수 정의
 *  5. 키값 입력 시 특정 타입으로 
 */

public class ParamMap extends HashMap<String, Object>{

	private ParamMap() {}
	public static ParamMap init(){
		return new ParamMap();
		
	}
	
	public String getString(String key) {
		Object object = this.get(key);
		if(object == null) {
			return null;
		}else {
			return String.valueOf(object);			
		}
	}
	
	public Integer getInteger(String key) {
		return (Integer) this.get(key);
	}
	
	// paramMap
	public <T> T get(String key, Class<T> clazz) {
		return (T) this.get(key);
	}
	
	
}
