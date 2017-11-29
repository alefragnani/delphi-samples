unit UnitTypeDefinition;

interface

type
  IGenericInterface<T,T2> = interface
  ['{2395EEA7-7E2E-485E-B6D3-C424A12FAE7F}']
  end;

  TGenericClassFromInterface<T,T2> = class(TInterfacedObject, IGenericInterface<T,T2>)
  end;


  TGenericClass<T> = class(TObject)
  end;

  TGenericClassDescendant<T> = class(TGenericClass<T>)
  end;

  TGenericClassDescendantInt = class(TGenericClass<Integer>)
  end;

implementation

end.
