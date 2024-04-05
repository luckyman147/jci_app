class FunctionMember{
  static int CalculateCotisation(List<bool> bools)=>
      bools.fold(0, (previousValue, element) => previousValue+(element?1:0));
}