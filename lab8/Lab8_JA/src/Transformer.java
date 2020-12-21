import java.lang.instrument.ClassFileTransformer;
import java.lang.instrument.IllegalClassFormatException;
import java.security.ProtectionDomain;


public class Transformer implements ClassFileTransformer
{
    public byte[] transform
            (
                    ClassLoader loader,
                    String className,
                    Class classBeingRedefined,
                    ProtectionDomain protectionDomain,
                    byte[] classfileBuffer
            )
            throws IllegalClassFormatException
    {
        if(className.equals("Licence"))
        {
            System.out.println("Found desired class");

            byte[] methodInternSign = hexToByteArray("4B6579506169722F7075626C69634B65790A00");
            byte[] passLicenseCheck = hexToByteArray("4B6579506169722F7075626C31634B65790A00");

            int signatureIndex = findPattern(classfileBuffer, methodInternSign);

            if(signatureIndex != -1)
            {
                System.out.println("Found method internals signature");

                for(int i = 0; i < passLicenseCheck.length; i++)
                {
                    System.out.println
                            (
                                    String.format("%02X ", classfileBuffer[signatureIndex + i])
                                            + "->" +
                                            String.format("%02X ", passLicenseCheck[i])
                            );

                    classfileBuffer[signatureIndex + i] = passLicenseCheck[i];
                }

                System.out.println("Method has been fixed");
            }
        }

        return classfileBuffer;
    }

    public static byte[] hexToByteArray(String s)
    {
        int len = s.length();
        byte[] data = new byte[len / 2];

        for (int i = 0; i < len; i += 2)
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i+1), 16));

        return data;
    }

    public static int findPattern(byte[] data, byte[] pattern)
    {
        int[] failure = computeFailure(pattern);

        int j = 0;

        for (int i = 0; i < data.length; i++)
        {
            while (j > 0 && pattern[j] != data[i])
                j = failure[j - 1];

            if (pattern[j] == data[i])
                j++;

            if (j == pattern.length)
                return i - pattern.length + 1;
        }

        return -1;
    }

    private static int[] computeFailure(byte[] pattern)
    {
        int[] failure = new int[pattern.length];

        int j = 0;
        for (int i = 1; i < pattern.length; i++)
        {
            while (j>0 && pattern[j] != pattern[i])
                j = failure[j - 1];

            if (pattern[j] == pattern[i])
                j++;

            failure[i] = j;
        }

        return failure;
    }
}