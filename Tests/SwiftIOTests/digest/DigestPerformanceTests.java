package digest;

import java.io.InputStream;
import java.math.BigInteger;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;


public class DigestPerformanceTests {


    static byte[] getFile(String fileName) throws Exception {
        Path path = Paths.get(DigestPerformanceTests.class.getResource(fileName).toURI());
        return Files.readAllBytes(path);
    }

    static String fileHash(String digest, String fileName, int count) throws Exception{
        MessageDigest md = MessageDigest.getInstance(digest);

        byte[] data = getFile(fileName);

        for(int i=0; i<count; i++) {
            md.update(data);
        }
        byte[] hash = md.digest();

        BigInteger bigInt = new BigInteger(1,hash);
        String hashtext = bigInt.toString(16);
        while(hashtext.length() < 32 ){
            hashtext = "0"+hashtext;
        }
        return hashtext;
    }

    public static void main(String[] args) throws Exception {

        long start = System.currentTimeMillis();



        System.out.println(fileHash("MD2", "random.dat", 1000));
        long time = System.currentTimeMillis() - start;
        System.out.println(time+ " ms.");
    }
}
