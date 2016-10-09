package reader;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ReaderPerformanceTests {

    public static void main(String[] args) throws IOException {

        long start = System.currentTimeMillis();
        try (
            BufferedReader reader = new BufferedReader(new InputStreamReader(ReaderPerformanceTests.class.getResourceAsStream("big.txt")))
        ) {
            String line;
            int count = 0;

            while((line = reader.readLine()) != null ) {
                count += 1;
            }

            System.out.println(count);
        }
        long time = System.currentTimeMillis() - start;
        System.out.println(time+ " ms.");
    }
}
