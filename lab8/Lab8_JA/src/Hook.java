import java.lang.instrument.Instrumentation;

public class Hook
{
    public static void premain(String agentArguments, Instrumentation instrumentation)
    {
        System.out.println("Hook start");
        Transformer transformer = new Transformer();
        instrumentation.addTransformer(transformer);
    }
}
