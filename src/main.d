import std.stdio;

static import analfuck;

void main(string args[]) {
  wstring src;
  
  foreach (arg; args[1..$]) {
    foreach (wstring line; File(arg, "r").lines) {
      src ~= line;
    }
  }
  
  analfuck.run(src);
}

