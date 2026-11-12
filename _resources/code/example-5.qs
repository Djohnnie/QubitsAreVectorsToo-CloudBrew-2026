namespace Example5
{
    import Std.Diagnostics.DumpMachine;

    @EntryPoint()
    operation Main() : Unit {
        use qs = Qubit[2];
        H(qs[0]);
        CNOT(qs[0], qs[1]);
        DumpMachine();
        ResetAll(qs);
    }
}
