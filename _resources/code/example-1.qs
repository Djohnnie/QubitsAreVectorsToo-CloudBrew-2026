namespace Example1
{
    import Std.Diagnostics.DumpMachine;

    @EntryPoint()
    operation Main() : Unit {
        use q = Qubit();
        DumpMachine();
    }
}
