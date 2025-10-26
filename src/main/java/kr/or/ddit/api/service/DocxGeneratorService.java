package kr.or.ddit.api.service;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigInteger;

@Service
@Slf4j
public class DocxGeneratorService {

    public byte[] generateDocx(String content) throws IOException {
        try (
        	 XWPFDocument document = new XWPFDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()
        ) {
        	String[] lines = content.split("\\r?\\n"); // 줄바꿈 기준으로 분리
        	for(String line : lines) {
        		if (line.trim().isEmpty()) continue; // 빈 줄은 무시
        		log.info(line);  
        		XWPFParagraph paragraph = document.createParagraph();
        		XWPFRun run = paragraph.createRun();
        		
        		if (line.startsWith("# ")) { // Heading 1
                    paragraph.setStyle("Heading1");
                    run.setText(line.substring(2));
                    run.setBold(true);
                    run.setFontSize(16);
                } else if (line.startsWith("## ")) { // Heading 2
                    paragraph.setStyle("Heading2");
                    run.setText(line.substring(3));
                    run.setBold(true);
                    run.setFontSize(14);
                } else if (line.startsWith("### ")) { // Heading 3
                    paragraph.setStyle("Heading3");
                    run.setText(line.substring(4));
                    run.setBold(true);
                    run.setFontSize(12);
                } else if (line.startsWith("- ")) { // 글머리 기호
                    paragraph.setNumID(BigInteger.valueOf(1)); // 단순 글머리 기호
                    run.setText(line.substring(2));
                } else {
                    // 일반 단락
                    run.setText(line);
                }
        		
        	}
        	
            document.write(out);
            return out.toByteArray();
        }
    }
}