# NO INTERNAL REFERENCE
import subprocess
import sys


class Vmsp:
    def __init__(self):
        self._executable = "spmf.jar"
        self._input = sys.argv[1]
        self._output = sys.argv[2]

    def run(self, min_supp=0.5):
        # java -jar spmf.jar run VMSP contextPrefixSpan.txt output.txt 50%
        subprocess.call(["java", "-jar", self._executable, "run", "VMSP", self._input, self._output, str(min_supp)])

    def encode_input(self, data):
        pass

    def decode_output(self):
        # read
        lines = []
        try:
            with open(self._output, "r", encoding='utf-8') as f:
                lines = f.readlines()
        except:
            print("read_output error")
                  

        # decode
        patterns = []
        for line in lines:
            line = line.strip()
            patterns.append(line.split(" -1 "))

        return patterns


if __name__ == "__main__":
    vmsp = Vmsp()
    vmsp.encode_input([])
    vmsp.run()
    print(vmsp.decode_output())
