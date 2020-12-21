package ru.habrahabr.agent;

import java.lang.instrument.Instrumentation;

public class Agent {
    public static void premain(String agentArgument, Instrumentation instrumentation) {
        System.out.println("Agent Counter");
        instrumentation.addTransformer(new ClassTransformer());
    }
}
