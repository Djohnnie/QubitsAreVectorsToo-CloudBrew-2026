namespace Example2
{
    import Std.Diagnostics.DumpMachine;

    @EntryPoint()
    operation Main() : Unit {
        use q = Qubit();
        X(q);
        DumpMachine();
        Reset(q);
    }
}
