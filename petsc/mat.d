class Mat {
public:
  void setValue(size_t i, size_t j, double value); // Set an element
  double opIndexAssign(double value, size_t i, size_t j) { // Mat[i,j] = value
    setValue(i, j, value);
    return value;
  }
  
  // Assembly functions
  void assemblyBegin();
  void assemblyEnd();
}