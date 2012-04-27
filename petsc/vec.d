

class Vec {
public:
  void setValue(size_t index, double value); // Set an element
  
  // Also allow [] to set values
  double opIndexAssign(double value, size_t index) { // Vec[index] = value;
    setValue(index, value);
    return value;
  }
  double opSliceAssign(double value);  // Vec[] = value
  double opSliceAssign(double value, size_t i, size_t j);  // overloads Vec[i .. j] = value
  
  Vec createSeq(int n); // member or function?
  
  
}