import vec;

class KSP {
public:
  void setFromOptions();
  string getType();
  
  size_t getIterationNumber();
  
  void solve(in Vec b, ref Vec x);
}
