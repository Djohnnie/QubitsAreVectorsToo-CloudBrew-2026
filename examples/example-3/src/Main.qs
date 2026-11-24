namespace Example3
{
    import Std.Diagnostics.DumpMachine;

    @EntryPoint()
    operation Main() : Unit {
        use q = Qubit();
        H(q);
        DumpMachine();
        Reset(q);
    }
}
