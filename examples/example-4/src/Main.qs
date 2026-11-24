namespace Example4
{
    import Std.Diagnostics.DumpMachine;
    import Std.Math.PI;

    @EntryPoint()
    operation Main() : Unit {
        use q = Qubit();
        Ry(2.0 * PI() / 3.0, q);
        DumpMachine();
        Reset(q);
    }
}
