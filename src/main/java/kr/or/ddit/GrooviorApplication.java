package kr.or.ddit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class GrooviorApplication {

	public static void main(String[] args) {
		SpringApplication.run(GrooviorApplication.class, args);
	}

}
