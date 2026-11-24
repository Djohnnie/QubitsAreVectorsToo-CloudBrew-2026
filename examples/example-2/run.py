import sys
from pathlib import Path

from qdk import qsharp

sys.stdout.reconfigure(encoding="utf-8")
qsharp.init(project_root=str(Path(__file__).resolve().parent))
qsharp.eval("Example2.Main()")
